#lang slideshow

(require slideshow/code)

; shamelessly copied from Matt Might
; http://matt.might.net/teaching/compilers/spring-2011/lectures/racket-lecture.rkt
(define-syntax code-reduce
  (syntax-rules ()
    ((_ exp) 
     (let ((t exp))
       (hb-append (code exp) (tt " => ") (code (unsyntax t)))))))

(slide #:title "Racket - a crash course")

(slide #:title "What is Racket?"
       (t "Scheme with useful libraries")
       (t "(plus some other stuff)"))
(slide #:title "DrRacket howto"
       ; definitions window
       ; interactions window
       ; help desk
       )
(slide #:title "Command-line Racket howto"
       (item "racket")
       (item "raco")
       #;(item "Add to $PATH if necessary")
       #;(item "Why the errors?"))
(slide #:title "Scheme Basics"
       'next
       (para "s-expressions:")
       'next
       (item "atoms"
             (subitem "numbers")
             (subitem "arrays")
             (subitem "strings")
             (subitem "symbols"))
       ; what is #:title? is that an addition by Racket?
       ; identifiers are symbols, right?
       'next
       (item "lists")
       'next
       (t "Yes, this really is all there is."))
(slide #:title "Scheme Basics"
       (para "Function application:")
       (item (tt "(") (it "fun arg ...") (tt ")"))
       'next
       (item (code-reduce (+ 4 5))))
(slide #:title "Scheme Basics"
       (para "Lists:"
             (item (code empty))
             (item "A pair of a value and a list")))
(slide #:title "Scheme Basics"
       (para "List construction:"
             (item (tt "(cons") (it "value list") (tt ")"))
             (item (tt "(list") (it "value") (tt "...)"))))
(slide #:title "Scheme Basics"
       (para "Function definition:")
       (item (tt "(λ (")
             (it "formal")
             (tt "...)")
             (it "body-expr")
             (tt "...)"))
       (item (tt "(lambda (")
             (it "formal")
             (tt "...)")
             (it "body-expr")
             (tt "...)")))
(slide #:title "Scheme Basics"
       (item (tt "(define") (it "name value") (tt ")"))
       (item (tt "(let ([")
             (it "name value")
             (tt "] ...)")
             (it "body ...")
             (tt ")")))
(slide #:title "Putting it all together"
       (item ""))
(slide #:title "List operations"
       (item (t "Syntax:")
             (para (tt "(map") (it "proc list ...") (tt ")")))
       (item (t "Examples:")
             (para (code-reduce (map add1 (list 2 3 4))))
             (para (code-reduce (map * (list 2 3 4)
                                     (list 1 2 3))))))
(slide #:title "List operations"
       (item (t "Syntax:")
             (para (tt "(foldl") (it "proc init list ...") (tt ")")))
       (item (t "Examples:")
             (para (code-reduce (foldl + 0 (list 1 2 3 4 5))))
             (para (code-reduce (foldl * 1 (list 1 2 3 4 5))))))
(slide #:title "Module System"
       ; maybe show racket doc to demonstrate how to know what to import
       (item (code \#lang racket))
       (item (tt "(require") (it "module") (tt ")")))
(slide #:title (para #:align 'center (code (read)) (t "and") (code (write)))
       (item (t "Typical use:")
             (subitem (tt "(read)"))
             (subitem (tt "(write") (it "datum") (tt ")")))
       (item (t "Other use:")
             (subitem (tt "(read") (it "input-port") (tt ")"))
             (subitem (tt "(write") (it "datum output-port") (tt ")"))))
(slide #:title (para #:align 'center (code (read)) (t "and") (code (write)))
       (para (code-reduce
              (let ([temp-file (build-path
                                (current-directory)
                                "temp")])
                (with-output-to-file
                    #:exists 'replace temp-file
                  (λ () (write (list 1 2 3))))
                (with-input-from-file
                    temp-file
                  read)))))
(slide #:title "match construct and quasiquotes"
       (para (code (match exp
                     
                     ; Symbols stay the same:
                     [(? symbol?)         exp]
                     
                     ; Boolean and conditionals:
                     [#t                  ...]
                     [#f                  ...]
                     [`(if ,condi ,t ,f)  ...]
                     [`(and ,a ,b)        ...]
                     [`(or ,a ,b)         ...]
                     
                     ...
                     
                     ; Lambdas:
                     [`(λ () ,exp)           ...]
                     [`(λ (,v) ,exp)         ...]
                     [`(λ (,v ,vs ...) ,exp) ...]
                     ...))))
(slide #:title "regular expressions"
       (para (t "Literals like")
             (colorize (tt "#rx\"a+\"") (current-literal-color)))
       (para (code-reduce (regexp-match-positions
                           #rx"a+"
                           "banana"))))
(slide #:title "structs"
       (item (t "Essentially lists with constructors"))
       (item (code (write)) (t "and") (code (read))
             (t "handle structs elegantly")))

(slide)