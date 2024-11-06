(*
  FPSE Assignment 7

  Name                  : David Wang
  List of Collaborators : None

  In this file you use the `Stack_monad` module to refactor some stateful OCaml code.

  Only begin on this file after finishing the `Fpse_monad`, `State_monad`, and
  `Stack_monad` modules.
*)

open Core
open Stack_monad (* this puts `m` and `Let_syntax` in scope. *)

(*
  -------------
  EXAMPLE USAGE
  -------------

  This is an example usage of the stack monad. Note this doesn't run yet because
  the state monad puts a `fun ... ` around all of it.

  Because `Let_syntax` is in scope, we can use the let bindings from `ppx_let`.
*)
let simple_stack : ('a, char) m =
  let%bind () = push 'a' in
  let%bind () = push 'b' in
  let%bind () = push 'c' in
  let%bind c = pop in
  return Char.(c = 'c')

(*
  Alternatively, we can use `let%map` to implicitly return the final line.
*)
let simple_stack' : ('a, char) m =
  let%bind () = push 'a' in
  let%bind () = push 'b' in
  let%bind () = push 'c' in
  let%map c = pop in
  Char.(c = 'c')

(* This will now run each of the above and assert they worked correctly. *)
let _ = assert (run simple_stack && run simple_stack')

(*
  ---------------------
  MUTABLE STACK PROGRAM
  ---------------------

  We'll now look at a simple mutable-stack program.

  The program checks if a string `s` has all parentheses '(' and ')' balanced. It uses the
  `Core.Stack` module, which is an actual mutable stack, not a monadic encoding of one.

  This is true if and only if the string [s] is a string of opening '(' and
    closing ')' parentheses that are balanced.
    This implementation returns [false] if we catch an exception from an illegal pop.
*)

(** [are_balanced_mutable s] is true if and only if the string [s] is a string of opening '(' and
    closing ')' parentheses that are balanced.
    This implementation returns [false] if we catch an exception from an illegal pop.
*)
let are_balanced_mutable (s : string) : bool =
  let stack_of_lefts = Stack.create () in
  let match_with s c = Char.(c = Stack.pop_exn s) in
  let parse = function
    | '(' -> Stack.push stack_of_lefts '('; true
    | ')' -> match_with stack_of_lefts '('
    | _ -> true
  in
  try
    let r = String.fold ~init:true ~f:(fun b c -> b && parse c) s in
    r && Stack.is_empty stack_of_lefts
  with _ -> false

(*
  And now we'll refactor a mutable-stack program into a program with the same
  structure and functionality by using our `Stack_monad` in place of a mutable stack.

  Rewrite the above function by turning all of the mutable stack operations into
  `Stack_monad` ones. You can still use try/with because `Stack_monad.pop` may
  raise an exception that needs to be caught. However, you may not use any mutable
  state. You must use `Stack_monad` for all stack operations, you must *not* use 
  `Core.Stack`, and you must write the program monadically.

  To make things easier we will extract some of the auxiliary functions we had
  above as separate functions with types declared for your benefit. Pay close
  attention to those types: the auxiliary functions are returning monadic values.
*)

let parse (c : char) : (bool, char) Stack_monad.m =
  try
    match c with
    | '(' -> 
      let%map () = push '(' in
      true 
    | ')' -> 
      let%bind not_empty = is_empty >>| not in       
      if not_empty then 
        let%map _ = pop in 
        true 
      else 
        return false   
    | _ -> return true                 
  with _ -> return false
;;


let main_monadic (s : string) : (bool, char) Stack_monad.m =
  let%bind parsed = String.fold s ~init:(return true) ~f:(fun aux ch ->
    let%bind aux' = aux in
    if aux' then parse ch else return false)
  in 
  let%map is_empty = is_empty in
  parsed && is_empty
;;

let are_balanced_monadic (s : string) : bool =
  try run @@ main_monadic s with _ -> false

(*
  And that's it! Now go test your code thoroughly in `test/tests.ml` and check out
  the discussion question in `discussion.txt`.
*)