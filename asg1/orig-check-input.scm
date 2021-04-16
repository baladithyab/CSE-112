;; (define (check-input)
;;     (let ((input (read)))
;;         (cond
;;             ((eof-object? input)
;;                 (hash-set! *var-table* 'eof 1.0)
;;             )
;;             ((number? input) 
;;                 (* input 1.0)
;;             )
;;             (else 
;;                 (begin (printf "Invalid Input... Please Try Again~n") (check-input))
;;             )
;;         )
;;     )
;; )


;; (let ((input (check-input)))
;;     (if (or (symbol? x) (eq? 0.0 (hash-ref *var-table* 'eof #f))) 
;;         (hash-set! *var-table* x input)
;;         (/ 0.0 0.0)
;;     ) 
;; )