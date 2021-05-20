(define (remainder a b)
  (- a (* b (truncate (/ a b)))))