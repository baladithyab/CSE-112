(* $Id: interp.ml,v 1.19 2021-04-20 20:19:30-07 - - $ *)
open Absyn

let want_dump = ref false

let source_filename = ref ""

(*IMPLEMENTED, NEED TO TEST*)
let rec eval_expr (expr : Absyn.expr) : float = match expr with
    | Number number -> number
    | Memref memref -> eval_memref memref
    | Unary (oper, expr) ->
        let res = eval_expr expr in
        Hashtbl.find Tables.unary_fn_table oper res
    | Binary (oper, expr1, expr2) ->
        let res1 = eval_expr expr1 in
        let res2 = eval_expr expr2 in
        Hashtbl.find Tables.binary_fn_table oper res1 res2

(*IMPLEMENTED, NEED TO TEST*)
and eval_memref (memref : Absyn.memref) : float = match memref with
    | Arrayref (ident, expr) -> 
        let res = (int_of_float (eval_expr expr)) in
        let arr = Hashtbl.find Tables.array_table ident in
        Array.get arr res
    | Variable ident -> try Hashtbl.find Tables.variable_table ident
                        with Not_found -> 0.0

and eval_STUB reason = (
    print_string ("(" ^ reason ^ ")");
    nan)

(*IMPLEMENTED, NEED TO TEST*)
let print_not_found func = (
    Printf.printf "Error in %s, label not found." func;
    exit(1);)

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
    | Goto label -> interp_GOTO label continue
    | If (expr, label) -> interp_STUB "If (expr, label)" continue
    | Print print_list -> interp_print print_list continue
    | Input memref_list -> interp_input memref_list continue

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

(* NEED TO IMPLEMENT *)
and interp_LET (memref, expr) (continue : Absyn.program) = 
    match memref with
    | Arrayref (ident , expr2) -> 
        let arr = (Hashtbl.find Tables.array_table ident) in
        let idx = (int_of_float (eval_expr expr2)) in
        let num = (eval_expr expr) in
        (*Array.set a n x --> a[n]=x*)
        Array.set arr idx num;
    interpret continue
    | Variable (ident) -> (print_not_found "LET")

(* and interp_let (memref, expr) (continue : Absyn.program) = 
match memref with
  (* Array.set array index number_to_set*)
  (* ---- (let a[5] 3) OR (let a[5] b[6]) ---- *)
  | Arrayref (ident, expr1) -> 
        let x1 = (int_of_float (eval_expr expr1)) in
        let x2 = (eval_expr expr) in
        (Array.set (Hashtbl.find Tables.array_table ident) x1 x2);
        interpret continue
  | Variable ident -> (* ---- (let x 5) OR (let g a[4]) *)
        let x = (eval_expr expr) in
        (Hashtbl.replace Tables.variable_table ident x);
        interpret continue *)

(*IMPLEMENTED, NEED TO TEST*)
and interp_GOTO (label) (continue : Absyn.program) = 
    try
        let flag = Hashtbl.find Tables.label_table label 
        in interpret flag
    with
        Not_found -> print_not_found "GOTO"

(*NEED TO IMPLEMENT*)
and interp_IF (expr, label) (continue : Absyn.program) = (print_not_found "IF")

(*NEED TO IMPLEMENT*)
and interp_DIM (ident, expr) (continue : Absyn.program) = (print_not_found "DIM")


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