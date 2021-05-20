
let rec adjacent op = function
    | [] -> false
    | h::t -> if (op h (List.hd t)) then true else (adjacent op t)
