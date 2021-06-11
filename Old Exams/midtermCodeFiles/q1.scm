(define (adjacent op list)
    (if (or (null? list)(apply op (cons (car list) (cadr list)))) #t 
        (adjacent (cdr list))))