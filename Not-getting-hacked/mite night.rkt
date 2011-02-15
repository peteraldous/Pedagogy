#lang racket/gui
(require slideshow)

(define password-length 4)
(define num-possible-chars 26)
(define executions-per-frame 31)
(define num-steps (quotient (- (expt num-possible-chars password-length) 1)
                            executions-per-frame))
(define dictionary-port (open-input-file "four-letter-words.txt"))
(define substitution-port (open-input-file "four-letter-words.txt"))
(define possible-mutations (add1 (*
                                  (sub1 num-possible-chars)
                                  password-length)))

(define start-time 0)

(define (time-elapsed)
  (- (current-milliseconds) start-time))

; tusk with one mutation
(define the-password "tusb")

(define brute-force-last-try "")
(define dictionary-last-try "")
(define substitution-last-try "")
(define current-substitution-word "")

(define brute-force-attempts 0)
(define dictionary-attempts 0)
(define substitution-attempts 0)

(define brute-force-done #f)
(define dictionary-done #f)
(define subst-done #f)

(define (do-n-times n thunk)
  (if (zero? n)
      (void)
      (do-n-times (sub1 n) thunk))
  (thunk))

(define (make-one-char-string select)
  (string (integer->char
           (+ 97 select))))

(define (add-one-char char add-me)
  (string (integer->char
           (let ([new-ascii(+ (char->integer char) add-me)])
             (if (new-ascii . > . 122)
                 (new-ascii . - . 26)
                 new-ascii)))))

(define (make-password-string select sub-password-length tally)
  (if (zero? sub-password-length)
      tally
      (make-password-string
       (quotient select num-possible-chars)
       (sub1 sub-password-length)
       (string-append
        (make-one-char-string (remainder select num-possible-chars))
        tally))))

(define (get-next-brute-force select)
  (define (do-times this-select times)
    (if (zero? times)
        brute-force-last-try
        (begin (if (equal? brute-force-last-try the-password)
                   (unless brute-force-done
                     (set! brute-force-done #t)
                     (printf "Brute force finished at ~a~n" (time-elapsed)))
                   (begin
                     (set! brute-force-attempts (add1 brute-force-attempts))
                     (set! brute-force-last-try
                           (make-password-string
                            this-select
                            password-length
                            ""))))
               (do-times (add1 this-select) (sub1 times)))))
  (do-times select executions-per-frame))

(define (get-next-word)
  (do-n-times executions-per-frame
              (lambda ()
                (if (equal? dictionary-last-try the-password)
                    (begin
                      (unless dictionary-done
                        (set! dictionary-done #t)
                        (printf "Dictionary finished at ~a~n" (time-elapsed)))
                      dictionary-last-try)
                    (let ([next-word (read-line dictionary-port)])
                      (if (eof-object? next-word)
                          "----"
                          (begin
                            (set! dictionary-attempts
                                  (add1 dictionary-attempts))
                            (set! dictionary-last-try next-word)
                            next-word)))))))

(define (mutate str mutation)
  #;(with-output-to-file "subst-attempts"
      #:exists 'replace
      (λ ()
        (printf "mutating ~a, #~a~n" str mutation)))
  (define (mutate-substr substr sub-mutation)
    (if (sub-mutation . < . num-possible-chars)
        (string-append
         (add-one-char (string-ref substr 0)
                       sub-mutation)
         (substring substr 1))
        (string-append
         (string (string-ref substr 0))
         (mutate-substr (substring substr 1)
                        (- sub-mutation (sub1 num-possible-chars))))))
  (mutate-substr str mutation))

(define (get-next-substitution mutation)
  (define (do-times times sub-mutation)
    (if (zero? times)
        substitution-last-try
        (begin
          (if (or (equal? substitution-last-try the-password)
                  subst-done)
              (begin
                (unless subst-done
                  (set! subst-done #t)
                  (printf "Substitution finished at ~a~n"
                          (time-elapsed)))
                substitution-last-try)
              (if (zero? sub-mutation)
                  (let ([next-word (read-line substitution-port)])
                    (if (eof-object? next-word)
                        (begin
                          (set! substitution-last-try "----")
                          (set! subst-done #t)
                          "----")
                        (begin
                          (set! substitution-attempts
                                (add1 substitution-attempts))
                          (set! substitution-last-try next-word)
                          (set! current-substitution-word next-word)
                          next-word)))
                  (begin
                    (set! substitution-attempts
                          (add1 substitution-attempts))
                    (set! substitution-last-try
                          (mutate current-substitution-word sub-mutation))
                    substitution-last-try)))
          (do-times (sub1 times)
                    (remainder (add1 sub-mutation) possible-mutations)))))
  (do-times executions-per-frame mutation))

(define (make-password-slide select)
  (let ([attempt (round (inexact->exact (* num-steps select)))]
        [width 325]
        [height 250])
    (hc-append
     (pin-over
      (blank width height) 0 0
      (vl-append (t (format "Brute Force: ~a"
                            (get-next-brute-force (* attempt
                                                     executions-per-frame))))
                 (t (format "Attempts: ~a" brute-force-attempts))))
     (pin-over
      (blank width height) 0 0
      (vl-append (t (format "Dictionary: ~a"
                            (get-next-word)))
                 (t (format "Attempts: ~a" dictionary-attempts))))
     (pin-over
      (blank width height) 0 0
      (vl-append (t (format "Substitution (~a)"
                            current-substitution-word))
                 (t (get-next-substitution
                     (remainder (* attempt executions-per-frame)
                                possible-mutations)))
                 (t (format "Attempts: ~a"
                            substitution-attempts)))))))

(define (show-passwords)
  (define step 0)
  (set! start-time (current-milliseconds))
  
  (define the-frame 
    (let-values ([(w h) (get-display-size #t)]
                 [(x y) (get-display-left-top-inset)])
      (new frame%
           [label "Password"]
           [width w]
           [height h]
           [x (- x)]
           [y (- y)]
           [style '(no-resize-border
                    no-caption
                    hide-menu-bar)])))
  
  (define the-canvas
    (new (class canvas%
           (define/override (on-char e)
             (case (send e get-key-code)
               [(escape #\q) (send the-frame on-exit)]))
           (super-new
            [parent the-frame]
            [paint-callback
             (lambda (c dc)
               (define p (make-password-slide
                          (exact->inexact (/ step num-steps))))
               (define-values (cw ch) (send dc get-size))
               (draw-pict p dc 
                          (/ (- cw (pict-width p)) 2)
                          (/ (- ch (pict-height p)) 2)))]))))
  
  (define animate-timer
    (new timer%
         [interval 1]
         [notify-callback (lambda ()
                            (yield)
                            (set! step (add1 step))
                            (send the-canvas refresh)
                            (unless (and (send the-frame is-shown?)
                                         (< step num-steps))
                              (send animate-timer stop)))]))
  
  (send the-frame show #t))

; helper
(define (make-bog title bad okay good)
  (slide
   #:title title
   (parameterize ([current-font-size 32])
     (para #:align 'left
           (t (format "Bad: ~a" bad))))
   (parameterize ([current-font-size 38])
     (para #:align 'left
           (t (format "Okay: ~a" okay))))
   (parameterize ([current-font-size 44])
     (para #:align 'left
           (t (format "Good: ~a" good))))))

(slide
 (parameterize ([current-font-size 50])
   (t "How to not get hacked")))

; intro - things are different on the internet
; creative commons
(slide
 (bitmap "Jesse_james.jpg"))

; creative commons
(slide
 (bitmap "AlCapone.jpg"))

(slide
 (t "The guy who made Conficker"))

(slide
 (t "Whoever made Stuxnet"))

(slide
 (t "We're not in Kansas anymore"))

;; profiling cybercriminals

(slide
 (t "What do they want, anyway?"))
; botnets - DDoS extortion and spam

#;(make-bog "Dealing with cybercriminals"
            "try to hide"
            "write to your senator"
            "pay attention tonight")

;; malware

; http://upload.wikimedia.org/wikipedia/commons/e/e7/Supertalent_USB-Stick.jpg
(slide
 (bitmap "USB-Stick.jpg"))

(make-bog "Malware"
          "relax"
          "scan for viruses"
          "install software carefully")

;; Facebook worms

; http://www.facebook-games.info/images/farmville.jpg
(slide
 (bitmap "farmville.jpg"))

(make-bog "Being safe on Facebook"
          "click away"
          "open in another browser"
          "ask your friend")

; sidejacking

(slide
 (parameterize ([current-font-size 50])
   (t "Use HTTPS")))

(slide
 (bitmap "FB-https.png"))

;; encryption

; http://adsoftheworld.com/files/images/1Mailman_BSNPoster.jpg
(slide
 (bitmap "Mailman.jpg"))

; http://www.dragoart.com/tuts/4119/1/1/how-to-draw-a-thief.htm
(slide
 (bitmap "thief.jpg"))

(make-bog "Email"
          "do nothing"
          "use caution in what you send"
          "encrypt")

(slide
 (parameterize ([current-font-size 50])
   (t "Wireless routers: Use WPA")))

(slide
 (clickback (t "Why it's a good idea to choose a random password")
            show-passwords))

(slide
 (let ([width 325]
       [height 250])
   (hc-append
    (pin-over
     (blank width height) 0 0
     (t "Brute Force: 456976"))
    (pin-over
     (blank width height) 0 0
     (t "Dictionary: 2294"))
    (pin-over
     (blank width height) 0 0
     (t "Substitution: 231694")))))

(make-bog "Passwords"
          "based on a word"
          "based on a sentence"
          "random")

(slide
 #:title "What if they get me?"
 (item "Change your passwords")
 (item "Scan for viruses")
 (item "Catch up on updates")
 (item "Contact the authorities if it's serious"))

(slide #:title "Questions?")

#|
; four lowercase letters
; 456976 possible combinations
; 2294 English words
; 231694 (possibly redundant) single mutations from words
(play
 make-password-slide
 #:steps (- (expt num-possible-chars password-length) 1)
 #:delay 0.001
 #:title "Password Cracking")
|#
