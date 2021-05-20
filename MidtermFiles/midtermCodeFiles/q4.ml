let rec insert op value list = match list with
    | [] -> [value]
    | h::[]-> if value<h then [value;h] else [h;value]
    | h::t -> if (op value h) then [value;h;t] else (insert op value t)