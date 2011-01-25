#lang racket

(struct course (name instructor students))

(define compilers (course "compilers" "Matt Might" (list "That guy"
                                                         "That other guy"
                                                         "That one girl")))

(course-name compilers)
(course-instructor compilers)
(course-students compilers)
(first (course-students compilers))