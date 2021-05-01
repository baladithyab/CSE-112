(* $Id: interp.ml,v 1.19 2021-04-20 20:19:30-07 - - $ *)

open Absyn

let want_dump = ref false

let source_filename = ref ""

(*NEED TO IMPLEMENT*)
let rec eval_expr (expr : Absyn.expr) : float = match expr with
    | Number number -> number
    | Memref memref -> eval_memref memref
    | Unary (oper, expr) -> eval_STUB "eval_expr Unary"
        (*NEED TO IMPLEMENT*)
    | Binary (oper, expr1, expr2) -> eval_STUB "eval_expr Binary"
        (*NEED TO IMPLEMENT*)

(*NEED TO IMPELEMENT*)
and eval_memref (memref : Absyn.memref) : float = match memref with
    | Arrayref (ident, expr) -> eval_STUB "eval_memref Arrayref"
        (*NEED TO IMPLEMENT*)
    | Variable ident -> try Hashtbl.find Tables.variable_table ident
                        with Not_found -> 0.0
        (*NEED TO IMPLEMENT*)

and eval_STUB reason = (
    print_string ("(" ^ reason ^ ")");
    nan)

let print_not_found (func) =
    Print.printf "Error in " func ", label not found."
    exit(1)

let rec interpret (program : Absyn.program) = match program with
    | [] -> ()
    | firstline::continue -> match firstline with
       | _, _, None -> interpret continue
       | _, _, Some stmt -> (interp_stmt stmt continue)


(*NEED TO IMPLEMENT*)
and interp_stmt (stmt : Absyn.stmt) (continue : Absyn.program) =
    match stmt with
    | Dim (ident, expr) -> interp_STUB "Dim (ident, expr)" continue
    | Let (memref, expr) -> interp_STUB "Let (memref, expr)" continue
    | Goto label -> interp_STUB "Goto label" continue
    | If (expr, label) -> interp_STUB "If (expr, label)" continue
    | Print print_list -> interp_print print_list continue
    | Input memref_list -> interp_input memref_list continue

(*NEED TO IMPLEMENT*)
and interp_LET (memref, expr) (continue : Absyn.program) =
    

(*NEED TO IMPLEMENT*)
and interp_GOTO (label) (continue : Absyn.program) = 
(*try Hashtbl.find Tables.variable_table ident
                        with Not_found -> 0.0*)
    try
        let flag = Hashtbl.find Tables.label_table label in interpret flag
    with
        Not_found => print_not_found "GOTO"

(*NEED TO IMPLEMENT*)
and interp_IF (expr, label) (continue : Absyn.program) =


(*NEED TO IMPLEMENT*)
and interp_DIM (ident, expr) (continue : Absyn.program) =


and interp_print (print_list : Absyn.printable list)
                 (continue : Absyn.program) =
    let print_item item = match item with
        | String string ->
          let regex = Str.regexp "\"\\(.*\\)\""
          in print_string (Str.replace_first regex "\\1" string)
        | Printexpr expr ->
          print_string " "; print_float (eval_expr expr)
    in (List.iter print_item print_list; print_newline ());
    interpret continue

and interp_input (memref_list : Absyn.memref list)
                 (continue : Absyn.program)  =
    let input_number memref =
        try  let number = Etc.read_number ()
             in (print_float number; print_newline ())
        with End_of_file -> 
             (print_string "End_of_file"; print_newline ())
    in List.iter input_number memref_list;
    interpret continue

and interp_STUB reason continue = (
    print_string "Unimplemented: ";
    print_string reason;
    print_newline();
    interpret continue)

let interpret_program program =
    (Tables.init_label_table program; 
     if !want_dump then Tables.dump_label_table ();
     if !want_dump then Dumper.dump_program program;
     interpret program;
     if !want_dump then Tables.dump_label_table ())