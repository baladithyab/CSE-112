#!/afs/cats.ucsc.edu/courses/cse112-wm/usr/racket/bin/mzscheme -qr
;; AUTHORS
;;    Manishankar Bhaskaran   (mbhaska1) 
;;    Baladithya  Balamurugan (bbalamur)
;; 
;; USAGE
;;    mbir.scm filename.mbir
;;
;; SYNOPSIS
;;    mbir.scm - mini basic interper
;;
;; DESCRIPTION
;;    The file mentioned in argv[1] is read and assumed to be an mbir
;;    program, which is the executed.


(define *DEBUG* #f)
(define *STDIN* (current-input-port))
(define *STDOUT* (current-output-port))
(define *STDERR* (current-error-port))
(define *ARG-LIST* (vector->list (current-command-line-arguments)))

(define *stmt-table*     (make-hash))
(define *function-table* (make-hash))
(define *var-table*      (make-hash))
(define *array-table*    (make-hash))
(define *label-table*    (make-hash))

(for-each (lambda (var) (hash-set! *var-table* (car var) (cadr var)))
   `(
        (e    ,(exp 1.0))
        (eof  0.0)
        (nan  ,(/ 0.0 0.0))
        (pi   ,(acos -1.0))
    )
)

(for-each (lambda (var) (hash-set! *function-table* (car var) (cadr var)))
    `(
        ;; from doc: abs, acos, asin, atan, ceil, cos, exp, floor, log, log10, round, sin, sqrt, tan, trunc
        (abs   ,abs)
        (acos  ,acos)
        (asin  ,asin)
        (atan  ,atan)
        (ceil  ,ceiling)
        (cos   ,cos)
        (exp   ,exp) ;; exp = e ^ num
        (floor ,floor)
        (log   ,log)
        (log10 ,(lambda (a) (/ (log a) (log 10.0))))
        (round ,round)
        (sin   ,sin)
        (sqrt  ,sqrt)
        (tan   ,tan)
        (trunc ,truncate)
        
        ;; from tests
        (=  ,=)
        (+  ,+)
        (-  ,-)
        (*  ,*)
        (/  ,/)
        (^  ,expt)
        (<  ,<)
        (<= ,<=)
        (!= , (lambda (x y) (not (= x y))))
        (>  ,>)
        (>= ,>=)
     )
)

(define *RUN-FILE*
    (let-values
        (((dirname basename dir?)
            (split-path (find-system-path 'run-file))))
        (path->string basename)))

(define (die list)
    (for-each (lambda (item) (fprintf *STDERR* "~a " item)) list)
    (fprintf *STDERR* "~n")
    (when (not *DEBUG*) (exit 1)))

(define (dump . args)
    (when *DEBUG*
        (printf "DEBUG:")
        (for-each (lambda (arg) (printf " ~s" arg)) args)
        (printf "~n")))

(define (usage-exit)
    (die `("Usage: " ,*RUN-FILE* " [-d] filename")))

(define (line-number line)
    (car line))

(define (line-label line)
    (let ((tail (cdr line)))
         (and (not (null? tail))
              (symbol? (car tail))
              (car tail))))

(define (line-stmt line)
    (let ((tail (cdr line)))
         (cond ((null? tail) #f)
               ((pair? (car tail)) (car tail))
               ((null? (cdr tail)) #f)
               (else (cadr tail)))))

(define (not-implemented function args . nl)
    (printf "(NOT-IMPLEMENTED: ~s ~s)" function args)
    (when (not (null? nl)) (printf "~n")))

;; HELPER FUNCTION TO PRINT AN ERROR STATEMENT
(define (print-err obj item)
    (
        (printf "Error: No such ~A ~s~n" obj item) ;; print "Error: not such [obj] [item]/n"
        (exit 1)                                   ;; exit the program with status code 1
    )
)

;; IMPLEMENTED, TESTED, AND DOCUMENTED
(define (eval-expr expr)
    (cond 
        ((number? expr)  ;; if the given expression is a number
            (+ expr 0.0) ;; convert the expression to a double and return it
        )
        ((symbol? expr)           ;; if the given expression is a symbol
            (hash-ref *var-table* ;; search var-table for a {key} and return its value
                expr              ;; {key}: given expression expr
                0.0               ;; else ({key} not found): 0.0
            )
        )
        ((and                      ;; if both of the following are true
            (pair? expr)           ;; expr is of type pair
            (eq? `asub (car expr)) ;; and expr[0] == "asub"
         ) 
            (vector-ref                                         ;; return element at position {pos} for vector {vec}
                (hash-ref *array-table*                         ;; {vec}: search array-table for a {key} and return its value (vector)
                    (cadr expr)                                 ;; {key}: expr[1:][0]
                    (lambda () (print-err "Array" (cadr expr))) ;; else ({key} not found): print message and exit
                ) 
                (exact-round(eval-expr(caddr expr)))            ;; {pos}: return of eval-expr(expr[1:][1:][0])
            )
        )
        ((pair? expr)                                                         ;; if the given expression is of type pair
            (let 
                (
                    (operator (hash-ref *function-table*                      ;; let operator = value of {key} in function-table
                                (car expr)                                    ;; {key}: expr[0]
                                (lambda () (print-err "Function" (car expr))) ;; else ({key} not found): print error message
                              )
                    )
                    (operands (map eval-expr (cdr expr)))                     ;; let operands = eval-expr applied to every element of expr[1:]
                )
                (apply operator operands)                                     ;; applies the function in operator to the list operands and returns it
            )
        )
        (else           ;; if none of the above conditions are true
            (/ 0.0 0.0) ;; return nan
        )
     )
 )

;; IMPLEMENTED, TESTED, AND DOCUMENTED
(define (interp-dim args continuation)
    ;; (not-implemented 'interp-dim args 'nl)
    (if (symbol? (caddar args))  ;; if args[0][1:][1:][0] is a symbol
        ;; if the if condition is true:
        (hash-set! *array-table* ;; maps ({key}, {value}) pair to array-table   
            (cadar args)         ;; {key}: args[0][1:][0] 
            (make-vector         ;; {value}: vector of {size} and with {default value}
                (exact-round (hash-ref *var-table* 
                                (caddar args)                                    ;; {size}: var-table(args[0][1:][1:][0])
                                (lambda () (print-err "Variable" (caddar args))) ;; else (not found): print error and exit
                             )
                ) 
                0.0                                                              ;; {default value}: 0.0
            ) ;; (dim (asub gojo n))
        )
        ;; if the if condition is false:
        (hash-set! *array-table*            ;; maps ({key}, {value}) pair to array-table
            (cadar args)                    ;; {key}  : args[0][1:][0]
            (make-vector                    ;; {value}: vector of {size} and with {default value}
                (exact-round (caddar args)) ;; {size}: args[0][1:][1:][0]
                0.0                         ;; {default value}: 0.0
            )
        ) ;; (dim (asub megumi 10))
    )
    (interp-program continuation)
)

;; IMPLEMENTED, TESTED, AND DOCUMENTED
(define (interp-let args continuation)
    ;; (not-implemented 'interp-let args 'nl)
    (if (symbol? (car args))
        ;; if the if condition is true:
        (hash-set! *var-table*      ;; maps ({key}, {value}) pair to var-table
            (car args)              ;; {key}  : args[0] 
            (eval-expr(cadr args))  ;; {value}: eval-expr(args[1:][0])
        ) 
        ;; if the if condition is false:
        (if (symbol? (caddar args))                              ;; if args[0][1:][1:][0] is a symbol
            ;; if the if condition is true:
            (vector-set!                                         ;; set element at position {pos} of vector {vec} to value {val}
                (hash-ref *array-table*                          ;; {vec}: value of {key} in array-table
                    (cadar args)                                 ;; {key}: args[0][1:][0]
                    (lambda () (print-err "Array" (cadar args))) ;; else ({key} not found): print error and exit
                )
                (exact-round (eval-expr(hash-ref *var-table*     ;; {pos}: value of {key} in var-table
                                        (caddar args)            ;; {key}: args[0][1:][1:][0]
                                        (lambda () (print-err "Variable" (caddar args))) ;; else ({key} not found): print error and exit 
                                       )
                             )
                )
                (eval-expr(cadr args))                           ;;  {val}: the return value of eval-expr(args[1:][0])
            )
            ;; if the if condition is false:
            (vector-set!                                         ;; set element at position {pos} of vector {vec} to value {val}
                (hash-ref *array-table*                          ;; {vec}: value of {key} in array-table
                    (cadar args)                                 ;; {key}: args[0][1:][0]
                    (lambda () (print-err "Array" (cadar args))) ;; else ({key} not found): print error and exit
                ) 
                (exact-round(eval-expr(caddar args)))            ;; {pos}: return value of eval-expr(args[0][1:][1:][0])
                (eval-expr(cadr args))                           ;; {val}: return value of eval-expr(args[1:][0])
            )
        )
    )
    (interp-program continuation)
)

;; IMPLEMENTED, TESTED, AND DOCUMENTED
(define (interp-goto args continuation)
    ;; (not-implemented 'interp-goto args 'nl)
    (let 
        ((flag (hash-ref *label-table*         ;; let flag = value at {key} in label-table
                (car args)                     ;; {key}: args[0]          
                (lambda () (print-err "Array" (car args))) ;; else ({key} not found): print error and exit
               ) 
        ))
        (interp-program flag)                  ;; execute interp-program(flag)         
    )
)

;; IMPLEMENTED, TESTED, AND DOCUMENTED
(define (interp-if args continuation)
    ;; (not-implemented 'interp-if args 'nl)
    (if(eval-expr(car args)) ;; if eval-expr(args[0]) is true
        ;; if the if condition is true:
        (let
            ((flag (hash-ref *label-table*                     ;; let flag = value at {key} in label-table
                    (cadr args)                                ;; {key}: args[1:][0]
                    (lambda () (print-err "Flag" (cadr args))) ;; else ({key} not found): print error and exit
                   )
            ))
            (interp-program flag)                              ;; execute interp-program(flag)
        )
        ;; if the if condition if false:
        (interp-program continuation)
    )
)

(define (interp-print args continuation)
    (define (print item)
        (if (string? item)
            (printf "~a" item)
            (printf " ~a" (eval-expr item))))
    (for-each print args)
    (printf "~n");
    (interp-program continuation))

;; IMPLEMENTED, TESTED, AND DOCUMENTED
(define (interp-input args continuation)
    ;; (not-implemented 'interp-input args 'nl)
    (define (read-input x)                 ;; define a function read-input that recieves arguement x
        (let((input (read)))               ;; let input = value read from console
            (cond  
                ((eof-object? input)       ;; if the given input is an eof character (ctrl+d)
                    (hash-set! *var-table* ;; map ({key}, {value}) pair to var-table
                        'eof               ;; {key}: eof character (ctrl+d)
                        1.0                ;; {value}: 1.0
                    ) 
                )
                ((number? input)                      ;; if the given input is a number
                    (if (or                           ;; if expression {exp1} or expression {exp2} is true
                            (symbol? x)               ;; {exp1}: if given input x is a symbol
                            (eq?                      ;; {exp2}: if {val1} == {val2} 
                                0.0                   ;; {val1}: 0.0
                                (hash-ref *var-table* ;; {val2}: value of {key} in var-table
                                    'eof              ;; {key}: eof character (ctrl+d)
                                    #f                ;; else ({key} not found): false
                                )
                            )
                        )
                        ;; if the if condition is true:
                        (let 
                            ((input-double (* input 1.0))) ;; let input-double = (double) input
                            (hash-set! *var-table*         ;; map ({key}, {value}) pair to var-table
                                x                          ;; {key}: given input x
                                input-double               ;; {value}: input-double
                            )
                        )
                        ;; if the if condition is false:
                        (/ 0.0 0.0)                        ;; return nan
                    )
                )
                (else ;; if none of the above conditions are true: print error and call read-input again
                    (begin (printf "Invalid Input... Try Again~nFactorial of: ") (read-input x))
                )
             )
        )
    )
    (for-each read-input args) ;; call read-input on for each element in given args
    (interp-program continuation)
)

(for-each (lambda (fn) (hash-set! *stmt-table* (car fn) (cadr fn)))
   `(
        (dim   ,interp-dim)
        (let   ,interp-let)
        (goto  ,interp-goto)
        (if    ,interp-if)
        (print ,interp-print)
        (input ,interp-input)
    )
)

(define (interp-program program)
    (when (not (null? program))
          (let ((line (line-stmt (car program)))
                (continuation (cdr program)))
               (if line
                   (let ((func (hash-ref *stmt-table* (car line) #f)))
                        (func (cdr line) continuation))
                   (interp-program continuation)))))

;; IMPLEMENTED, TESTED, AND DOCUMENTED
(define (scan-for-labels program)
    ;; (not-implemented 'scan-for-labels '() 'nl)
    (when (not (null? program))                         ;; if given program != null
        (let 
            ((label (line-label(car program))))         ;; let label = line-label(program[0])
            (when (symbol? label)                       ;; if label is a symbol 
                (hash-set! *label-table*                ;; maps ({key}, {value}) pair added to label-table
                    label                               ;; {key}: label
                    program                             ;; {value}: program
                ) 
            ) 
            (scan-for-labels(cdr program))              ;; execute scan-for-labels(program[1:])
        )
    )
)

(define (readlist filename)
    (let ((inputfile (open-input-file filename)))
         (if (not (input-port? inputfile))
             (die `(,*RUN-FILE* ": " ,filename ": open failed"))
             (let ((program (read inputfile)))
                  (close-input-port inputfile)
                         program))))

(define (dump-program filename program)
    (define (dump-line line)
        (dump (line-number line) (line-label line) (line-stmt line)))
    (dump *RUN-FILE* *DEBUG* filename)
    (dump program)
    (for-each (lambda (line) (dump-line line)) program))

(define (main arglist)
    (cond ((null? arglist)
                (usage-exit))
          ((string=? (car arglist) "-d")
                (set! *DEBUG* #t)
                (printf "~a: ~s~n" *RUN-FILE* *ARG-LIST*)
                (main (cdr arglist)))
          ((not (null? (cdr  arglist)))
                (usage-exit))
          (else (let* ((mbprogfile (car arglist))
                       (program (readlist mbprogfile)))
                (begin (when *DEBUG* (dump-program mbprogfile program))
                       (scan-for-labels program)
                       (interp-program program))))))

(main *ARG-LIST*)