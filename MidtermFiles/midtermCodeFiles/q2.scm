(define (foldl f z list)
    (if (null? list) z
        (foldl f (f z (car list)) (cdr list))))

(define test '(1 2 3))
(foldl (lambda (a b) (+ a 1)) test)