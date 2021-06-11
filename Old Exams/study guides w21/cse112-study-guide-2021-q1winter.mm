.so Tmac.mm-etc
.if t .Newcentury-fonts
.INITR* \n[.F]
.SIZE 12 14
.ds Quarter Winter\~2021
.TITLE CSE-112 \*[Quarter] "Study Guide"
.RCS \
"$Id: study-guide-2021-q1winter.mm,v 1.39 2021-03-10 10:37:54-08 - - $"
.PWD
.URL
.SA 0
.na
.nr Hy 0
.nh
.de HHH
.   DE
.   DS
.   fi
.   H 1 "\\$1"
..
.DS
.HHH "Week 1 \[em] January 5"
.ALX a ()
.LI
Syllabus, pair programming, course overview.
.LI
Lab0 intro unix, and review of Data Structures labs.
.LI
Lecture notes\(::
.V= scheme-1-language.pdf
(p.\~1\[en]4).
.LI
.V= Languages/scheme/Examples
\[em]
Simple introductory Scheme programs\(::
.br
.V= hello.scm ,
.V= argv.scm ,
.V= false.scm ,
.V= hashbang.scm ,
.V= commandline.scm ,
.br
.V= factorial.scm ,
.V= fibonacci.scm ,
.V= divmod.scm ,
.V= complex.scm .
.LE
.HHH "Week 1 \[em] January 7"
.ALX a ()
.LI
.V= asg1-scheme-mbir
\[em]
Programming project\(::
interpreter for Minibasic written in scheme.
Program specifications.
.LI
Example 
.V= mbir
programs to be interpreted\(::
syntax and semantics.
.LI
.V= misc-cons-lists.d
\[em]
pictures and diagrams of Scheme lists with 
.V= cons .
.LI
.V= code/mbir.scm
\[em]
starter code for the interpreter,
begin general dissection and details of the code.
.LE
.HHH "Week 2 \[em] January 12"
.ALX a ()
.LI
Continued dissection and examination of starter code
.V= code/mbir.scm .
.LI
Somewhat more complex Scheme programs, showing
data structures and expression evaluation\(::
.br
.V= readnums.scm ,
.V= simple-eval.scm ,
.V= evalexpr.scm ,
.V= hashexample.scm ,
.br
.V= labelhash.scm ,
.V= symbols.scm ,
.V= mergesort.scm .
.LE
.HHH "Week 2 \[em] January 14"
.ALX a ()
.LI
Lecture notes\(::
.V= scheme-1-language.pdf
(p.\~5\[en]end).
.LI
Mathematical derivation of factorial\(::
non tail recursive and tail recursive versions,
showing call stack depth.
.LI
Scheme tracing on factorial and Fibonacci functions.
.LE
.HHH "Week 3 \[em] January 19"
.ALX a ()
.LI
Lecture notes\(::
.V= scheme-2-higherorder.pdf
(p.\~1\[en]12)
\[em] higher order functions in Scheme.
.LE
.HHH "Week 3 \[em] January 21"
.ALX a ()
.LI
Lecture notes\(::
.V= scheme-2-higherorder.pdf
(p.\~12\[en]19)
\[em] higher order functions in Scheme.
.LI
.V= testrun.sh
\[em]
Testing scripts and test data,
how the graders will do the grading of submitted programs.
.LI
Mention as an example a book that uses Ocaml as a
Unix Systems programming language.
.LI
Lecture notes\(::
.V= ocaml-1-notes.pdf
(p.\~1\[en]9)
\[em] introducing Ocaml, another functional lanuage,
but one that compiles to native machine code.
.LE
.HHH "Week 4 \[em] January 26"
.ALX a ()
.LI
Lecture notes\(::
.V= ocaml-1-notes.pdf
(p.\~9\[en]19).
.LI
Minibasic language specification\(::
Language description.
.br
Sample programs\(::
syntax and semantics.
.LI
.V= asg2-ocaml-interp
\[em]
Programming project\(::
interpreter for Minibasic written in Ocaml.
.LI
Begin dissection of Ocaml starter code, general overview.
.LE
.HHH "Week 4 \[em] January 28"
.ALX a ()
.LI
Finish dissection of starter code for Minibasic interpreter in Ocaml.
.V= \&.mli
files are interface specifications,
and
.V= \&.ml
files are implementations.
.ALX 1 () "" 0
.LI
.V= absyn.mli 
\[em]
abstract syntax definitions for the interpreter.
.LI
.V= dumper.mli ,
.V= dumper.ml
\[em]
formatting and printing abstract syntax for debugging.
.LI
.V= etc.mli ,
.V= etc.ml
\[em]
miscellaneous functions.
.LI
.V= interp.mli ,
.V= interp.ml
\[em]
functions performing the interpretation of statements
and expressions,
and supervisory functions calling these.
.LI
.V= main.ml
\[em]
main program and options analysis.
.LI
.V= tables.mli ,
.V= tables.ml
\[em]
dispatch tables for labels, arrays, variables, and functions.
.LI
.V= scanner.mll ,
.V= parser.mly 
\[em]
complete scanner and parser provided,
not student-edited,
in lex-like and yacc-like format.
.LI
.V= Makefile .
.LE
.LI
.V= Languages/ocaml/Examples/a-list
\[em]
Simple introductory Scheme programs\(::
.br
.V= hello.ml ,
.V= helloworld.ml ,
.V= argv.ml ,
.V= length.ml ,
.V= factorial.ml ,
.V= fibonacci.ml .
.LI
.V= Languages/ocaml/Examples/b-list
\[em]
Ocaml examples specifically relevant to the programming assignment\(::
.br
.V= eval1-simple.ml ,
.V= eval2-symbols.ml ,
.V= hashexample.ml ,
.V= readnumber.ml .
.LE
.HHH "Week 5 \[em] February 2"
.ALX a ()
.LI
Lecture notes\(::
.V= ocaml-2-higherorder.pdf
(p.\~1\[en]9)
\[em] higher order functions in Ocaml.
.LI
Frivolous\(::
EWD-714\(::
E.W.Dijkstra, trip report to Santa Cruz (UCSC), 1979.
.br
EWD-498\(::
E.W.Dijkstra,
How do we tell truths that might hurt\(??
.LI
.V= Languages/ocaml/Examples/c-list
\[em]
Some more advanced Ocaml examples\(::
.br
.V= ackermann.ml ,
.V= complex-nrs.ml ,
.V= exponent.ml ,
.V= mergesort.ml ,
.V= ncat.ml ,
.br
.V= odd-even.ml ,
.V= qsort.ml .
.LE
.HHH "Week 5 \[em] February 4"
.ALX a ()
.LI
.V= Languages/ocaml/Examples/x86-64-code
\[em]
Examples of constant propagation optimization and
tail call elimination in code generated for the x86-64 architecture\(::
.br
.V= boolconst.s-opt ,
.V= boolvar.s-opt ,
.V= cfacloop.s-opt ,
.V= cfacrec.s-opt ,
.br
.V= tailrectest.s-opt .
.LI
Lecture notes\(::
.V= object-oriented.pdf
\[em]
Object-oriented programming.
Polymorphism\(::
parametric (universal),
inclusion (object oriented),
overloading (ad hoc),
and conversion (ad hoc).
.LI
Lecture notes\(::
.V= smalltalk-notes.pdf
\[em] introduction to Smalltalk.
.LE
.HHH "Week 6 \[em] February 9"
.ALX a ()
.LI
.V= asg3-smalltalk-mbst
\[em] programming project\(::
interpreter for Minibasic written in Smalltalk.
Overview of intermediate code files to be processed by
the interpreter.
.LI
.V= asg3/Examples/
\[em] examples of simple Smalltalk programs showing general ideas.
.ALX 1 () "" 0
.LI
.V= a-trivial.d
\[em] some trivial examples\(::
.br
.V= hello.st ,
.V= echoargs.st ,
.V= arithmetic.st ,
.V= cmdline.st ,
.V= divide.st ,
.br
.V= intsort.st ,
.V= dictionary.st ,
.V= collatz-block.st ,
.V= collatz-class.st .
.LI
.V= b-simple.d
\[em] some very simple examples\(::
.br
.V= ashex.st ,
.V= filein.st ,
.V= isgraph.st ,
.V= perform.st ,
.V= priority.st ,
.V= string.st ,
.V= terminalecho.st .
.LE
.LI
.V= code/mbint.st
\[em] dissection of starter code for interpreter.
.LE
.HHH "Week 6 \[em] February 11"
.ALX a ()
.LI
.V= code/mbint.st
\[em] continuation of dissection of starter code for interpreter.
Most of lecture.
.LI
.V= c-involved.d
\[em] a few more involved examples\(::
.br
.V= initarray.st ,
.V= sorted-names.st .
.LE
.HHH "Week 7 \[em] February 16"
.ALX a ()
.LI
Midterm exam.
No lecture.
.LE
.HHH "Week 7 \[em] February 18"
.ALX a ()
.LI
.V= asg3/Examples/c-involved.d
\[em] more Smalltalk examples\(::
.br
.V= binepsilon.st ,
.V= catfile.st ,
.V= complexx.st ,
.V= euler.st ,
.br
.V= sorted-names.st ,
.V= treeleaf.st ,
.V= wordcount.st .
.LI
.V= asg3/misc-evalexpr
\[em] miscellaneous parallel examples comparing features of
Scheme, Ocaml, and Smalltalk.
.ALX 1 ()
.LI
.V= perform.ml ,
.V= perform.scm ,
.V= perform.st 
\[em]
examples comparing performing indirect operators.
.LI
.V= evalexpr.ml ,
.V= evalexpr.scm ,
.V= evalexpr.st 
\[em]
examples comparing symbolic evaluations of expressions.
.LE
.LE
.HHH "Week 8 \[em] February 23"
.ALX a ()
.LI
reviewed midterm exzm questions and answers.
.LI 
.V= Perl-notes.d
(1..156)
\[em]
introduction to Perl.
.LI 
.V= perl/Examples
\[em]
a few example programs\(::
.V= hello.perl ,
.V= argv.perl .
.LI 
Brief overview of asg5 
.V= pmake . 
.LE
.HHH "Week 8 \[em] February 25"
.ALX a ()
.LI
.V= asg4-perl-pmake
\[em]
Perl project to implement a small subset of
.V= make .
.LI
.V= asg4/misc
subdirectory with relevant example code.
.ALX 1 () "" 0
.LI
.V= graph.perl
\[em]
creating a graph using a hash with values
pointing at arrays.
.LI
.V= modtime.perl
\[em]
find a file's modification time.
.LI
Various C++ programs and a Makefile showing how make
reacts to various exit status codes and signal crashes.
.LE
.LI
.V= code/pmake
\[em]
detailed dissection of starter code for the project.
.LE
.HHH "Week 9 \[em] March 2"
.ALX a ()
.LI
.V= Perl-notes.d
(156..end) \[em]
includeing regular expressions.
.LI
Some Perl examples\(::
.V= wc.perl ,
.V= text2html .
.LE
.HHH "Week 9 \[em] March 4"
.ALX a ()
.LI
More Perl examples\(::
.V= subst-macros.perl ,
.V= nvcat.perl ,
.V= switch.perl ,
.br
.V= wordfreq.perl ,
.V= xref.perl .
.LI
Notes\(::
delayed evaluation, Haskell.
.LE
.HHH "Week 10 \[em] March 9"
.ALX a ()
.LI
.V= Lecture-notes/lambda-calculus
\[em] Lambda calculus.
abstraction,
currying,
beta conversion,
alpha conversion,
eta conversion,
strict vs non-struct evaluation.
.LI
.V= Lecture-notes/data-types
\[em] static vs dyntamic types,
primitive vs declared types, type constructors,
type checking, compatibility.
Universal and ad-hoc polymorphism.
.LI
.V= Lecture-notes/procedures-environments
\[em] procedure activation,
parameter passing,
stack based runtime and local stack frames,
activation records.
.LE
.HHH "Week 10 \[em] March 11"
.ALX a ()
.LI
Review final exams from previous quarters.
.LE
.DE
