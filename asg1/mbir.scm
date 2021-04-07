;; Authored by: Manishankar Bhaskaran   (mbhaska1)
;;              Baladithya  Balamurugan (bbalamur)
;; File: mbir.scm



;; (file->lines "00-hello-world.mbir")


(require (planet williams/describe/describe))
(define *ARG-LIST* (vector->list (current-command-line-arguments)))


; (display (read-string 200 (open-input-file "00-hello-world.mbir")))
(display "hello world")
(newline)
(display *ARG-LIST*)
(newline)
(define source (open-input-file (car *ARG-LIST*)))
(define sourcey (read source))
(newline)
(display (describe sourcey))
(newline)
;; https://stackoverflow.com/questions/32212874/scheme-how-to-print-a-list-without-parenthesis
(define (displist lst)
  (let loop ((lst lst))
    (when (pair? lst)
      (display (car lst))
      (newline)
      (loop (cdr lst))))
  (newline))
(displist sourcey)


