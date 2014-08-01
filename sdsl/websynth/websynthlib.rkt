#lang s-exp rosette

(require "dom.rkt")
(provide (except-out (all-defined-out) tag-type))

(require rosette/solver/z3/z3)
(current-solver (new z3%))

(define-syntax-rule (define-tags tags)
  (begin
    (define-enum tag (cons "" tags))
    (tag-type tag?)))

(define tag-type (make-parameter #f))

(define (tag str) (enum-value (tag-type) str))

(define-syntax tag?
  (syntax-id-rules ()
    [tag? (tag-type)]
    [(tag? v) ((tag-type) v)]))

; Maximum depth of the DOM, so we know how many variables
; to allocate. (Writen by Emina Torlak)
(define (depth dom)
  (if (DOMNode? dom)
      (+ 1 (apply max (cons 0 (map depth (DOMNode-content dom)))))
      0))

(define (size dom )
  (if (DOMNode? dom)
      (+ 1 (apply + (map size (DOMNode-content dom))))
      0))

; Checker function that returns true iff a prefix of the 
; given path connects the source node to the sink node. (Writen by Emina Torlak)
(define (path? path source sink)
  (or (and (equal? source sink)
           (andmap (lambda (p) (equal? p (tag ""))) path))
      (and (DOMNode? source) 
           (not (null? path))
           (equal? (car path) (tag (DOMNode-tagname source)))
           (ormap (lambda (child) (path? (cdr path) child sink)) (DOMNode-content source)))))

; Convert the final evaluated solution into a zpath string
(define (synthsis_solution->zpath zpath_list)
  ;(string-append "/" (string-join (remove* (list "") (cdr zpath_list)) "/")))
  (string-append "/" (string-join (remove* (list "") zpath_list) "/")))

; Mask function
(define (generate-mask zpath1 zpath2 mask depth)
  (if (= (length zpath1) 0)
      null
      (begin
        (assert (eq? (car mask) 
                   (eq? (car zpath1) (car zpath2))))
        (generate-mask (cdr zpath1) (cdr zpath2) (cdr mask) depth))))

; Zip
; Found at http://jeremykun.wordpress.com/2011/10/02/a-taste-of-racket/ in the comments.
(define (zip list . lists)
  (apply map (cons (lambda (x . xs) (cons x xs)) (cons list lists))))