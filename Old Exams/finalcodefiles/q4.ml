let rec monotonic oper lst = match lst with
    | [] -> true
    | hd::[] -> true
    | hd::hd2::tl -> if (oper hd hd2) then (monotonic oper hd2::tl) else false;;

Printf.printf "%b" monotonic (<) [1; 2; 3; 3; 4; 9; 9];;