(* stack_monad.ml *)

(* Include the necessary module *)
include Fpse_monad.Make(State_monad)

(* Define the type for the stack monad *)
type ('a, 'b) m = ('a, 'b list) State_monad.m

(* Function to push a value onto the stack *)
let push (x : 'a) : (unit, 'a) m =
  fun stack ->
    ((), x :: stack)  (* Returns unit and the new stack with x on top *)

(* Function to pop a value from the stack *)
let pop : ('a, 'a) m =
  fun stack ->
    match stack with
    | [] -> failwith "pop: stack is empty"  (* Raise an exception if the stack is empty *)
    | x :: xs -> (x, xs)  (* Return the top value and the new stack without the top value *)

(* Function to run the monadic stack operation *)
let run (x : ('a, 'b) m) : 'a =
  let (result, _) = x [] in  (* Start with an empty stack *)
  result  (* Return the result, discarding the final stack *)

(* Function to check if the stack is empty *)
let is_empty : (bool, 'a) m =
  fun stack ->
    (List.length stack = 0, stack)  (* Return true if the stack is empty, along with the stack *)
