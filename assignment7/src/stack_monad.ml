include Fpse_monad.Make(State_monad)

type ('a, 'b) m = ('a, 'b list) State_monad.m

(* Function to push a value*)
let push (x : 'a) : (unit, 'a) m =
  fun stack ->
    ((), x :: stack)

(* Function to pop *)
let pop : ('a, 'a) m =
  fun stack ->
    match stack with
    | [] -> failwith "pop: stack is empty"
    | x :: xs -> (x, xs)

(* Function to run the monadic stack operation *)
let run (x : ('a, 'b) m) : 'a =
  let (result, _) = x [] in
  result

(* Function to check empty stack *)
let is_empty : (bool, 'a) m =
  fun stack ->
    (List.length stack = 0, stack)
