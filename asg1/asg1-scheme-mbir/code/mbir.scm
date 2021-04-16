#!/afs/cats.ucsc.edu/courses/cse112-wm/usr/racket/bin/mzscheme -qr
;; $Id: mbir.scm,v 1.9 2021-01-12 11:57:59-08 - - $
;;
;; NAME
;;    mbir.scm filename.mbir
;;
;; SYNOPSIS
;;    mbir.scm - mini basic interper
;;
;; DESCRIPTION
;;    The file mentioned in argv[1] is read and assumed to be an mbir
;;    program, which is the executed.  Currently it is only printed.
;;

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
        ;; (!= ,(lambda (a b) (not (eq? a b))))
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
        (printf "Error: No such ~A ~s~n" obj item) 
        (exit 1)
    )
)

;; CURRENTLY IMPLEMENTING
(define (eval-expr expr)
    (cond 
        ((number? expr) 
            (+ expr 0.0)
        )
        ((symbol? expr) 
            (hash-ref *var-table* expr 0.0)
        )
        ((and (pair? expr) (eq? `asub (car expr))) (vector-ref (hash-ref *array-table* (cadr expr) (lambda () (print-err "Array" (cadr expr)))) (exact-round(eval-expr (caddr expr)))))
        ((pair? expr) 
            (let 
                (
                    (operator (hash-ref *function-table* (car expr) (lambda () (print-err "Function" (car expr)))))
                    (operands (map eval-expr (cdr expr)))
                )
                (apply operator operands)
            )
        )
        (else 
            (/ 0.0 0.0)
        )
     )
 )

;; IMPLEMENTED, TESTED, AND DOCUMENTED
(define (interp-dim args continuation)
    ;; (not-implemented 'interp-dim args 'nl)
    (if (symbol? (caddar args))  ;; if args[0][1:][1:][0] is a symbol
        ;; if the if condition is true:
        (hash-set! *array-table* ;; maps (key, value) pair to array-table   
            (cadar args)         ;; key: args[0][1:][0] 
            (make-vector         ;; value: vector of with size and default value
                (exact-round (hash-ref *var-table* 
                                (caddar args)                        ;; size: var-table(args[0][1:][1:][0])
                                (lambda () (print-err "Variable" (caddar args))) ;; else (not found): die
                             )
                ) 
                0.0                                                  ;; default value: 0.0
            ) ;; (dim (asub gojo n))
        )
        ;; if the if condition is false:
        (hash-set! *array-table* ;; maps (key, value) pair to array-table
            (cadar args)         ;; key: args[0][1:][0]
            (make-vector         ;; value: vector of size args[0][1:][1:][0], values initialized to 0.0
                (exact-round (caddar args)) ;; size : args[0][1:][1:][0]
                0.0                         ;; default value: 0.0
            )
        ) ;; (dim (asub megumi 10))
    )
    (interp-program continuation)
)

;; NEED TO IMPELEMENT ARRAY STUFF
(define (interp-let args continuation)
    ;; (not-implemented 'interp-let args 'nl)
    (if (symbol? (car args))
        (hash-set! *var-table*      ;; add (args[1], args[2]) pair to var-table
            (car args)              ;; key  : args[0] 
            (eval-expr(cadr args))  ;; value: eval-expr(args[1:][0])
        ) 
        ;; NEED TO ADD ARRAY STUFF 
        ;; ELSE
        (if (symbol? (caddar args))
            (vector-set! 
                (hash-ref *array-table* 
                    (cadar args) 
                    (lambda () (print-err "Array" (cadar args)))
                )
                (exact-round (eval-expr(hash-ref *var-table* 
                                        (caddar args) 
                                        (lambda () (print-err "Variable" (caddar args)))
                                       )
                             )
                )
                (eval-expr(cadr args))
            ) 
            (vector-set! (hash-ref *array-table* 
                            (cadar args)
                            (lambda () (print-err "Array" (cadar args)))
                         ) 
                         (exact-round(eval-expr(caddar args)))
                         (eval-expr(cadr args))
            )
        )
    )
    (interp-program continuation)
)

;; IMPLEMENTED, TESTED, AND DOCUMENTED
(define (interp-goto args continuation)
    ;; (not-implemented 'interp-goto args 'nl)
    (let 
        ((flag (hash-ref *label-table*         ;; let flag = value at key in label-table
                (car args)                     ;; key: args[0]          
                (lambda () (print-err "Array" (car args))) ;; else (not found): die
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
            ((flag (hash-ref *label-table*                     ;; let flag = value at key in label-table
                    (cadr args)                                ;; key: args[1:][0]
                    (lambda () (print-err "Flag" (cadr args))) ;; else (not found): die
                   )
            ))
            (interp-program flag)                              ;; execute interp-progran(flag)
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

;; IMPLEMENTED, TESTED, NEEDS DOCUMENTATION
(define (interp-input args continuation)
    ;; (not-implemented 'interp-input args 'nl)
    
    (define (read-input x)
        (let((input (read)))
            (cond  
                ((eof-object? input) 
                    (hash-set! *var-table* 'eof 1.0) 
                )
                ((number? input) 
                    (if (or (symbol? x) (eq? 0.0 (hash-ref *var-table* 'eof #f))) 
                        (let 
                            ((input-double (* input 1.0))) 
                            (hash-set! *var-table* x input-double)
                        )
                        (/ 0.0 0.0)
                    )
                )
                (else 
                    (begin (printf "Invalid Input... Try Again~nFactorial of: ") (read-input x))
                )
             )
        )
    )
    (for-each read-input args)
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

;; NEED TO IMPLEMENT
;; go thru each line
;; get the car and cdr of each line
;; store the line in the lable-table in format of (car, program) <-- of the line respectivley
;; very similar to interp-program
(define (scan-for-labels program)
    ;; (not-implemented 'scan-for-labels '() 'nl)
    (when (not (null? program))                         ;; if(program != null)
        (let 
            ((label (line-label(car program))))         ;; label = line-label(program[0])
            (when (symbol? label)                       ;; if(label.type == symbol)
                (hash-set! *label-table* label program) ;; (label, program) pair added to label-table
            ) 
            (scan-for-labels(cdr program))              ;; scan-for-labels(program[1:len(program)-1])
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

;; (display *label-table*)