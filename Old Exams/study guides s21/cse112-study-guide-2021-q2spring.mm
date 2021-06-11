.so Tmac.mm-etc
.if t .Newcentury-fonts
.INITR* \n[.F]
.SIZE 12 14
.ds Quarter Spring\~2021
.TITLE CSE-112 \*[Quarter] "Study Guide"
.RCS \
"$Id: cse112-study-guide-2021-q2spring.mm,v 1.79 2021-06-01 23:57:54-07 - - $"
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
.HHH "Week 1 \[em] Tuesday March 30"
.ALX a ()
.LI
Syllabus, pair programming, course overview.
Lab0 intro unix, and review of Data Structures labs.
Reference to study guides.
.LI
.V= Languages/Hello ,
.V= Languages/Collatz \[em]
Examples of simple programs in multiple languages\(::
Bash, C++, Ocaml, Perl, Prolog, Scheme, Smalltalk.
.LI
Lecture notes\(::
.V= scheme-1-language.pdf 
(p.\~1\[en]4).
.if n .sp
.LI
.V= Languages/scheme/Examples/a-simple
\[em]
Simple introductory Scheme programs\(::
.V= hello.scm ,
.V= false.scm ,
.V= factorial.scm ,
.V= fibonacci.scm
(with tracing).
.LE
.HHH "Week 1 \[em] Thursday April 1"
.ALX a ()
.LI
Finish
.V= a-simple/ .
.ALX 1 () "" 0
.LI
.V= derivation-factorial 
\[em]
whowing tail vs non-atil call formula derivations.
.LI
.V= stack-tail-usage.scm
\[em]
program using small stack space with tail recursion
but blowing up stack without tail calls.
.LE
.LI
.V= Examples/b-arith
\[em]
examples showing interaction with the command line,
hash-bang
.=V ( #! )
scripts,
and other examples.
.if n .sp
.LI
.V= asg1-scheme-mbir
specifications.
Writing an interpreter in Scheme for a small mini-basic language.
.LI
.V= code/mbir.scm
\[em]
brief overview of the starter code and introduction to
interpretation.
.LE
.HHH "Week 2 \[em] Tuesday April 6"
.ALX a ()
.LI
.V= Examples/c-evalexpr
\[em] examples related to evaluating expressions and scanning
for labels.
.ALX 1 () "" 0
.LI
.V= euler.scm
\[em]
simple examples of using built-in 
.V= eval
function to evaluate lists as expressions.
.LI
.V= simple-eval.scm
\[em]
hand-coded simple evaluator of expressions.
.LI
.V= evalexpr.scm
\[em]
hand-coded evaluator of expressions with operators and
variables stored in hash tables.
.LI
.V= hashexample.scm
\[em]
use of hash tables for storing infomration.
.LI
.V= labelhash.scm
\[em]
scanning a program list and identifying labels.
.LI
.V= readnums.scm
\[em]
reading numbers and detecting non-numbers and end of file.
.LE
.LI
.V= misc-cons-lists.d/
\[em]
Simple diagram of some node configurations.
.V= picture-21-let-if
contains a diagram of the 
.V= mbir
program structure.
.LI
.V= mbir.scm
\[em]
detailed dissection of the starter code for the interpreter.
.LE
.HHH "Week 2 \[em] Thursday April 8"
.ALX a ()
.LI
.V= Lecture-notes/scheme-1-language.pdf
\[em]
notes on Scheme made from Dybvig's text
(p.\~4\[en]13).
.LI
Numerous online examples.
.LE
.HHH "Week 3 \[em] Tuesday April 13"
.ALX a ()
.LI
.V= Lecture-notes/scheme-1-language.pdf
(p.\~13\[en]end).
.LI
.V= scheme-2-higherorder.pdf
\[em] Scheme higher order functions
(p.\~1\[en]12).
.LE
.HHH "Week 3 \[em] Thursday April 15"
.ALX a ()
.LI
.V= scheme-2-higherorder.pdf
\[em] Scheme higher order functions
(p.\~12\[en]end).
.LI
.V= Examples/d-functions
\[em] wrap up examples with some programs.
.V= mergesort.scm ,
.V= mutualrec.scm ,
.V= facfun.scm ,
.V= quine.scm
.LI
.V= Lecture-notes/ocaml-1-notes.pdf
(p.\~1\[en]2),
plus numerous online examples.
Introduction to Ocaml.
.LE
.HHH "Week 4 \[em] Tuesday April 20"
.ALX a ()
.LI
.V= Examples/a-simple
.ALX 1 () "" 0
.LI
.V= hello.ml ,
.V= helloworld.ml
.LI
.V= argv.ml
\[em] access to the command line
.LI
.V= epsilon.ml
\[em] showing 1 + \[*e] \[==] 1
.LI
.V= factorial.ml ,
.V= fibonacci.ml
\[em] repeat of examples from Scheme tail call and tail recursions 
discussion.
.LI
.V= length.ml
\[em] another example of internal function with tail recursion
.LE
.LI
.V= Examples/b-evalexpr
.ALX 1 () "" 0
.LI
.V= eval1-simple.ml ,
.V= eval2-symbols.ml
\[em] examples of recursive evaluations of expressions,
with and without a symbol table.
.LI
.V= find.ml
\[em]
example of type
.V= "\&'a option"
for returning an object that might not exist
.LE
.LI
Assignment 2 specifications
.LI
.V= asg2/code
.ALX 1 () "" 0
.LI
.V= absyn.mli
\[em] abstract syntax of the interpreter
.LI
.V= parser.mly ,
.V= scanner.mll
\[em] brief overview of parser and scanner (provided,
not written by students).
.LI
.V= main.ml
\[em] main function calling interpreter
.LE
.LE
.HHH "Week 4 \[em] Thursday April 22"
.ALX a ()
.LI
.V= asg2/code
\[em] finish discussion from last lecture.
.ALX a () "" 0
.LI
.V= interp.{mli,ml}
\[em] extensive discussion of interpreter,
where students do the majority of coding for this project.
.LI
.V= tables.{mli,ml}
\[em]
variable and function tables for maintaining data.
.LI
.V= dumper.{mli,ml}
\[em] data dumper and stringification functions for absyn.
.LI
.V= etc.{mli,ml}
\[em] miscellaneous other functions.
.LE
.LI
.V= Examples/b-evalexpr
.ALX 1 () "" 0
.LI
.V= find-opt-exn.ml
\[em] function for searching a list.
Type
.V= "\&'a option" .
.LI
.V= hashexample.ml
\[em] use of
.V= Hashtbl.find
and
.V= Hashtbl.find_opt 
.LI
.V= readnumber.ml
\[em] scanning input for individual numbers from stdin.
.LE
.LI
.V= Examples/c-functions
\[em] brief look during remaining lecture time
.LE
.HHH "Week 5 \[em] Tuesday April 27"
.ALX a ()
.LI
.V= Lecture-notes/ocaml-1-notes.pdf
\[em] review.
.LI
.V= Examples/c-functions
\[em] miscellaneous functions showing more Ocaml style\(::
.ALX 1 () "" 0
.LI
.V= ackermann.ml
\[em] test of computational complexity
.LI
.V= complex-nrs.ml
\[em] module
.V= Complex
and
.V= float
numbers
.LI
.V= exponent.ml
\[em] efficient integer exponent computation
.LI
.V= mergesort.ml
\[em] polymorphic efficient sorting of a list
.LI
.V= odd-even.ml
\[em] mututally recursive functions
.LE
.LI
.V= Examples/x86-64-code
\[em] generated x86-64 code showing how compilers eliminate
tail recursion and rewrite as loops.
Source code in Ocaml and C.
.ALX 1 () "" 0
.LI
.V= boolconst.ml.s ,
.V= boolvar.ml.s
\[em] constant propagation to eliminate a boolean test always false.
.LI
.V= length.ml.s ,
.V= facrec.c.s ,
.V= factorial.ml.s
\[em] tail recursive functions implemented as loops
by the code generator.
.LE
.LE
.HHH "Week 5 \[em] Thursday April 29"
.ALX a ()
.LI
.V= Lecture-notes/ocaml-2-higherorder.pdf
\[em] higher-order functions in Ocaml.
.LI
.V= Examples/d-higherorder
\[em] examples of higher-order functions in Ocaml.
.ALX 1 () "" 0
.LI
.V= p1-uncurry.ml
\[em] functions
.V= curry
and
.V= uncurry
.LI
.V= p2-apply.ml
\[em] appliction of function argument to other arguments.
.LI
.V= p3-foldl.ml
\[em] functions written directly using tail recursion,
and functions written as arguments to fold left\(::
.V= sum ,
.V= length ,
.V= reverse ,
.V= member .
.LI
.V= p3-foldl.ml
\[em] 
.V= reduce ,
exception producing folding, e.g.,
.V= find_minimum
using 
.V= failwith
and returning an
.V= "\&'a option" .
.LI
.V= p4-foldr.ml
\[em] fold right functions that can not be written tail
recursively,
implementation using direct recursion and as a parameter to
fold right\(::
.V= map ,
.V= filter ,
.V= append .
.LI
.V= p5-zip.ml
\[em] merging and splitting lists\(::
.V= unzip ,
.V= zip ,
.V= zipwith ,
.V= inner_product .
.LE
.LE
.HHH "Week 6 \[em] Tuesday May 4"
.ALX a ()
.LI
.V= Examples/a-trivial.d
.ALX 1 () "" 0
.LI
.V= hello.st ,
.V= usage.st ,
.V= echoargs.st ,
.V= showargv.st
\[em] trivial examples involving command line.
.LI
.V= arithmetic.st ,
.V= divide.st ,
.V= dictionary.st ,
.V= fns-radix.st ,
.V= intsort.st
\[em] simple examples showing arithmetic and some 
library data structures.
.LI
.V= collatz-block.st ,
.V= collatz-class.st
\[em] coding examples\(::
blocks and a simple class.
.LE
.LI
.V= Examples/b-simple.d
\[em] slightly more advanced examples.
.ALX 1 () "" 0
.LI
.V= arraysum.st ,
.V= ashex.st ,
.V= isgraph.st
\[em] extending a class on the fly with new methods.
.LI
.V= perform.st
\[em] use of keyword method
.V= perform: 
and
.V= perform:with:
as an analog to a functional language's
.V= apply
function.
.LI
.V= sillypet.st
\[em] simple example of class inheritance of methods,
dynamic typing,  and
``duck typing''.
.LI
.V= simple-eval.st
\[em]
example of a numeric and expression class with inheritance,
including
.V= value ,
.V= printOn: ,
and
.V= perform:with:\&
methods.
.LI
.V= filein.st ,
.V= parseargs.st ,
.V= priority.st ,
.V= string.st ,
.V= terminalecho.st
\[em] miscellaneous other simple examples.
.LE
.LE
.HHH "Week 6 \[em] Thursday May 6"
.ALX a ()
.LI
.V= asg3-smalltalk-mbst/
.ALX 1 () "" 0
.LI
asg3-smalltalk-mbst specifications overview.
.LI
discussion of 
.V= \&.mbst
intermediate code files for interpreter
.LI
.V= code/mbint.st
\[em]
line by line analysis of starter code for project.
.LE
.LE
.HHH "Week 7 \[em] Tuesday May 11"
.ALX a ()
.LI
Midterm Examination.
No lecture.
.LE
.HHH "Week 7 \[em] Thursday May 13"
.ALX a ()
.LI
.V= asg3-smalltalk-mbst/
.ALX 1 () "" 0
.LI
.V= code/mbint.st
\[em] repetition of review of starter code.
.LE
.LI
.V= asg3/misc
\[em] comparison of similar problems illustrated by code in
Scheme, Ocaml, and Smalltalk,
all with the same purpose.
.ALX 1 () "" 0
.LI
.V= euler.{scm,ml,st}
\[em] examples of complex number arithmetic,
somewhat combersome in Ocaml.
.LI
.V= perform.{scm,ml,st}
\[em] application of operators to operands in various ways.
.LI
.V= evalexpr.{scm,ml,st}
\[em] evaluations of symolic expressions from data structures.
.LE
.LI
.V= Examples/c-involved.d
\[em] various further examples of Smalltalk code\(::
.br
.V= binepsilon.st ,
.V= complexx.st ,
.V= epsilon.st ,
.V= euler.st ,
.V= floatd-inspect.st ,
.V= floatd-format.cpp ,
.V= initarray.st ,
.V= sorted-names.st ,
.V= treeleaf.st
.LE
.HHH "Week 8 \[em] Tuesday May 18"
.ALX a ()
.LI
.V= perl/Examples/a-simple
Some simple examples of Perl scripts involving
command line, etc.\(::
.V= hello.perl ,
.V= argv.perl ,
.V= ncat.perl ,
.V= count.perl ,
.V= xref.perl .
.LI
Lecture notes.
.V= asg4/Perl-notes.d
(lines 1\[en]298).
Introduction to Perl syntax and semantics.
.LE
.HHH "Week 8 \[em] Thursday May 20"
.ALX a ()
.LI
Review midterm exam with answers and variations.
.LI
.V= asg4-perl-pmake
\[em] specifications for project,
a small subset of the
.V= make
utility.
.LI
.V= asg4/misc
\[em] some examples related to project.
.ALX 1 () "" 0
.LI
.V= modtime.perl
\[em] obtain modification time from a file.
.LI
.V= runcmd.perl
\[em] run a command using the shell,
obtain the resulting success or error status
as a message.
.LI
.V= graph.perl
\[em] sipmle example of how to create a graph in Perl.
.LE
.LI
.V= asg4/code/pmake
\[em] preliminary tour of the starter code,
including parsing a
.V= Makefile .
.LI
.V= asg4/dot.score
and subdiretories\(:
discussion of the test data and attendant
.V= Makefile s.
.LI
.V= asg4/sample-output.d
\[em] test data showing effects of actual
.V= make .
.LE
.HHH "Week 9 \[em] Tuesday May 25"
.ALX a ()
.LI
.V= asg4-perl-pmake
\[em] details of pseudo-code for the make_goal algorithm
and calling sequence for run_command.
Special details of the 
.V= @
and
.V= -
command markers.
.LI
.V= asg4/code/pmake
\[em] detailed dissection of the starter code and discussion
of the data structures.
.LI
.V= asg4/misc
\[em] finish discussion of miscellaneous related Perl programs.
.LI
Answered many questions from zoom chat about the program
and Perl in general.
.LI
Lecture notes.
.V= asg4/Perl-notes.d
(lines 298\[en]380).
.LE
.HHH "Week 9 \[em] Thursday May 27"
.ALX a ()
.LI
Lecture notes.
.V= asg4/Perl-notes.d
(lines 380\[en]end),
including regular expressions.
.LI
.V= Perl/Examples/b-moreso\(::
.ALX 1 () "" 0
.LI
.V= cat.perl ,
accessing files and iterating
.V= @ARGV .
.LI
.V= dumper ,
showing
.V= Data::Dumper .
.LI
.V= switch.perl ,
implementing a switch statement by putting subs (lambdas)
in a hash table.
.LI
.V= text2html.perl ,
converting plain text into html and recognizing URLs.
.LE
.LI
A short overview discussion of Javascript and timers on web pages.
.LE
.HHH "Week 10 \[em] Tuesday June 1"
.ALX a ()
.LI
Further discussion of 
.V= pmake
assignment,
answering students' questions.
.ALX 1 () "" 0
.LI
Details of test scripts,
discussion of 
.V= bash
code in each of the testing directories.
.LI
Example of copying test scripts to a
.V= /tmp
directory and replacing 
.V= pmake
with
.V= make
to determine expected output.
.LI
.V= asg4/misc/
.V= quotameta.perl
\[em] handling wildcards such as
.V= "%.o : %.c" .
.LI
.V= asg4/misc/
.V= subst-macros.perl
\[em] substituting the values of
.V= pmake
macros.
.LI
.V=  asg4/misc/
.V= modtime.perl
\[em] finding the modification time of a file
and determining existence of a file.
.LE
.LI
Discusscion of shell scripting using
.V= bash
with examples of some production bash scripts in the
.V= bin/
directory.
.LI
Finish up lecture with brief introduction to lambda calculus.
.LE
.HHH "Week 10 \[em] Thursday June 3"
.ALX a ()
.LI
Review of exams from previous quarters.
.LE
.DE
