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
;; ---------------------------------------------------------------------

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

;; ---------------------------------------------------------------------
(for-each (lambda (var)(hash-set! *var-table* (car var) (cadr var)))
   `(
        (e    ,(exp 1.0))
        (eof  0.0)
        (nan  ,(/ 0.0 0.0))
        (pi   ,(acos -1.0))
    )
)
;; ---------------------------------------------------------------------

;; ---------------------------------------------------------------------
(for-each(lambda (var) (hash-set! *function-table* (car var)(cadr var)))
    `(
        ;; from doc: abs, acos, asin, atan, ceil, cos, exp, floor, log, 
        ;;           log10, round, sin, sqrt, tan, trunc
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
;; ---------------------------------------------------------------------

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
        (printf "Error: No such ~A ~s~n" obj item) ;; print error
        (exit 1)                                   ;; exit the program
    )
)

;; ---------------------------------------------------------------------
;; IMPLEMENTED, TESTED, AND DOCUMENTED
(define (eval-expr expr)
    (cond 
        ((number? expr)  ;; if the given expression is a number
            ;; convert the expression to a double and return
            (+ expr 0.0) 
        )
        ((symbol? expr)           ;; if the given expression is a symbol
            (hash-ref *var-table* ;; search var-table for a {key} and 
                                  ;; return its value
                expr              ;; {key}: given expression expr
                0.0               ;; else ({key} not found): 0.0
            )
        )
        ((and                      ;; if both of the following are true
            (pair? expr)           ;; expr is of type pair
            (eq? `asub (car expr)) ;; and expr[0] == "asub"
         ) 
            (vector-ref ;; return element @ posit. {pos} for {vec}
                ;; {vec}: search array-table for {key} and return  
                (hash-ref *array-table*                 
                    (cadr expr) ;; {key}: expr[1:][0]
                    ;; else ({key} not found): print message and exit
                    (lambda () (print-err "Array" (cadr expr))) 
                )
                ;; {pos}: return of eval-expr(expr[1:][1:][0])
                (exact-round(eval-expr(caddr expr)))            
            )
        )
        ((pair? expr) ;; if the given expression is of type pair
            (let 
                (   ;; let operator = value of {key} in function-table
                    (operator (hash-ref *function-table* 
                                (car expr) ;; {key}: expr[0]
                          ;; else ({key} not found): print error
                          (lambda () (print-err "Function" (car expr))) 
                              )
                    )
                    ;; let operands = eval-expr mapped to expr[1:]
                    (operands (map eval-expr (cdr expr))) 
                )
                ;; applies func in operator to list operands, return 
                (apply operator operands) 
            )
        )
        (else           ;; if none of the above conditions are true
            (/ 0.0 0.0) ;; return nan
        )
     )
 )
;; ---------------------------------------------------------------------

;; ---------------------------------------------------------------------
;; IMPLEMENTED, TESTED, AND DOCUMENTED
(define (interp-dim args continuation)
    ;; (not-implemented 'interp-dim args 'nl)
    (if (symbol? (caddar args))  ;; if args[0][1:][1:][0] is a symbol
        ;; if the if condition is true:
        ;; maps ({key}, {value}) pair to array-table
        (hash-set! *array-table* 
            (cadar args)      ;; {key}: args[0][1:][0] 
            (make-vector      ;; {value}: vector of {size} and with {dv}
                (exact-round (hash-ref *var-table* 
                                ;; {size}: var-table(args[0][1:][1:][0])
                                (caddar args)
                       ;; else (not found): error exit
                       (lambda () (print-err "Variable" (caddar args))) 
                             )
                ) 
                0.0             ;; {dv}: 0.0
            ) ;; (dim (asub gojo n))
        )
        ;; if the if condition is false:
        (hash-set! *array-table* ;; maps ({key}, {value}) pair to a-t
            (cadar args)         ;; {key}  : args[0][1:][0]
            (make-vector      ;; {value}: vector of {size} and with {dv}
                ;; {size}: args[0][1:][1:][0]
                (exact-round (caddar args)) 
                0.0 ;; {dv}: 0.0
            )
        ) ;; (dim (asub megumi 10))
    )
    (interp-program continuation)
)
;; ---------------------------------------------------------------------

;; ---------------------------------------------------------------------
;; IMPLEMENTED, TESTED, AND DOCUMENTED
(define (interp-let args continuation)
    ;; (not-implemented 'interp-let args 'nl)
    (if (symbol? (car args))
        ;; if the if condition is true:
        ;; maps ({key}, {value}) pair to var-table
        (hash-set! *var-table*  
            (car args)              ;; {key}  : args[0] 
            (eval-expr(cadr args))  ;; {value}: eval-expr(args[1:][0])
        ) 
        ;; if the if condition is false:
        (if (symbol? (caddar args)) ;; if args[0][1:][1:][0] is a symbol
            ;; if the if condition is true:
            (vector-set! ;; set elem at {pos} of {vec} to {val}
                (hash-ref *array-table* ;; {vec}: value of {key} in a-t
                    (cadar args)        ;; {key}: args[0][1:][0]
                    ;; else ({key} not found): print error and exit
                    (lambda () (print-err "Array" (cadar args))) 
                )
                ;; {pos}: value of {key} in var-table
                (exact-round (eval-expr
                                (hash-ref *var-table*
                                        ;; {key}: args[0][1:][1:][0] 
                                    (caddar args) 
                      ;; else ({key} not found): error and exit
                      (lambda () (print-err "Variable" (caddar args))) 
                                )
                             )
                )
                ;; {val}: the return value of eval-expr(args[1:][0])
                (eval-expr(cadr args)) 
            )
            ;; if the if condition is false:
            (vector-set! ;; set element at {pos} of {vec} to {val}
                (hash-ref *array-table* ;; {vec}: value of {key} in a-t
                    (cadar args)        ;; {key}: args[0][1:][0]
                    ;; else ({key} not found): print error and exit
                    (lambda () (print-err "Array" (cadar args))) 
                ) 
                ;; {pos}: return value of eval-expr(args[0][1:][1:][0])
                (exact-round(eval-expr(caddar args))) 
                ;; {val}: return value of eval-expr(args[1:][0])
                (eval-expr(cadr args)) 
            )
        )
    )
    (interp-program continuation)
)
;; ---------------------------------------------------------------------

;; ---------------------------------------------------------------------
;; IMPLEMENTED, TESTED, AND DOCUMENTED
(define (interp-goto args continuation)
    ;; (not-implemented 'interp-goto args 'nl)
    (let 
        ;; let flag = value at {key} in label-table
        ((flag (hash-ref *label-table* 
                (car args) ;; {key}: args[0]
                ;; else ({key} not found): print error and exit      
                (lambda () (print-err "Array" (car args))) 
               ) 
        ))
        (interp-program flag) ;; execute interp-program(flag)    
    )
)
;; ---------------------------------------------------------------------

;; ---------------------------------------------------------------------
;; IMPLEMENTED, TESTED, AND DOCUMENTED
(define (interp-if args continuation)
    ;; (not-implemented 'interp-if args 'nl)
    (if(eval-expr(car args)) ;; if eval-expr(args[0]) is true
        ;; if the if condition is true:
        (let
            ;; let flag = value at {key} in label-table
            ((flag (hash-ref *label-table* 
                    (cadr args)            ;; {key}: args[1:][0]
                    ;; else ({key} not found): print error and exit
                    (lambda () (print-err "Flag" (cadr args))) 
                   )
            ))
            (interp-program flag) ;; execute interp-program(flag)
        )
        ;; if the if condition if false:
        (interp-program continuation)
    )
)
;; ---------------------------------------------------------------------

(define (interp-print args continuation)
    (define (print item)
        (if (string? item)
            (printf "~a" item)
            (printf " ~a" (eval-expr item))))
    (for-each print args)
    (printf "~n");
    (interp-program continuation))

;; ---------------------------------------------------------------------
;; IMPLEMENTED, TESTED, AND DOCUMENTED
(define (interp-input args continuation)
    ;; (not-implemented 'interp-input args 'nl)
    (define (read-input x)     ;; define a function read-input has arg x
        (let((input (read)))     ;; let input = value read from console
            (cond  
                ((eof-object? input);; if the given input is an eof char
                     ;; map ({key}, {value}) pair to var-table
                    (hash-set! *var-table*
                        'eof    ;; {key}: eof character (ctrl+d)
                        1.0     ;; {value}: 1.0
                    ) 
                )
                ((number? input)   ;; if the given input is a number
                    ;; if expression {exp1} or expression {exp2} is true
                    (if (or  
                            ;; {exp1}: if given input x is a symbol
                            (symbol? x)
                            ;; {exp2}: if {val1} == {val2} 
                            (eq?                      
                                0.0 ;; {val1}: 0.0
                                ;; {val2}: value of {key} in var-table
                                (hash-ref *var-table* 
                                    'eof ;; {key}: eof character
                                    #f   ;; else ({key} not found):false
                                )
                            )
                        )
                        ;; if the if condition is true:
                        (let 
                            ;; let input-double = (double) input
                            ((input-double (* input 1.0))) 
                            ;; map ({key}, {value}) pair to var-table
                            (hash-set! *var-table*         
                                x               ;; {key}: given input x
                                input-double    ;; {value}: input-double
                            )
                        )
                        ;; if the if condition is false:
                        (/ 0.0 0.0)  ; return nan
                    )
                )
                ;; if none of the above conditions are true: 
                (else 
                    ;; print error and call read-input again
                    (begin 
                        (printf "Invalid, Try Again~nFactorial of: ") 
                        (read-input x)
                    )
                )
             )
        )
    )
    ;; call read-input on for each element in given args
    (for-each read-input args) 
    (interp-program continuation)
)
;; ---------------------------------------------------------------------

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

;; ---------------------------------------------------------------------
;; IMPLEMENTED, TESTED, AND DOCUMENTED
(define (scan-for-labels program)
    ;; (not-implemented 'scan-for-labels '() 'nl)
    (when (not (null? program)) ;; if given program != null
        (let 
            ;; let label = line-label(program[0])
            ((label (line-label(car program)))) 
            (when (symbol? label)        ;; if label is a symbol 
                ;; maps ({key}, {value}) pair added to label-table
                (hash-set! *label-table* 
                    label                ;; {key}: label
                    program              ;; {value}: program
                ) 
            )
            ;; execute scan-for-labels(program[1:])
            (scan-for-labels(cdr program)) 
        )
    )
)
;; ---------------------------------------------------------------------

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
