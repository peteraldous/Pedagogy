#lang racket

(struct course (name instructor students))

(course "compilers" "Matt Might" (list "That guy"
                                            "That other guy"
                                            "That one girl"))