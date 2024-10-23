
(* More let (* nested in (* comments to (* at else (* the begin (* end end (* 
   

here are the closing comments *) *) (* let in match *) *) *) *) *) *)

let rec f ls =
  match ls with
  | [](*for *)-> (* let*)"| [] -> "
  | _ :: tl -> f tl

let () = let _ = f [1;2;3;4] in ()

(* NOTE: we'll say that the let in let* counts as a keyword because it gets highlighted like one,
   and it is too difficult for this assignment to ignore it. *)
let (let*) x f = Core.Option.bind x ~f
let a = let* c = Some 1 in Some (c + 1)
let ( * ) = ( + )

(*

let rec f ls = (* let rec f s = *)
  match ls with (* match ls with *)
  | [] -> "| [] -> " (* | [] -> "| [] -> " *)
  | _ :: tl -> f tl (* | _ :: tl -> f tl *)

let () = let _ = f [1;2;3;4] in () "val" (* let () = let _ = f [1;2;3;4] in () *)

*)