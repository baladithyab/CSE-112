(define (insert op value lst)
  (if (null? lst) (list value)
      (if (op value (car lst))
          (cons value lst)
          (cons (car lst) (Insert op value (cdr lst))))))