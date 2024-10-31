
(*
  Use `State_monad` and `Fpse_monad.Make` to implement a stateful monadic stack. 
  Note you shouldn't have to write new `bind` and `return` functions but can 
  instead reference those from `State_monad`.
*)

include Fpse_monad.S with type ('a, 'b) m = ('a, 'b list) State_monad.m
(** The state of a stack monad is a ['b list]. *)

(*
  We'll need a few extra functions to use this monad practically, so
  we have all of the following in addition to the above signature.
*)

val push : 'a -> (unit, 'a) m
(** [push a] is a monadic value that has [a] on the top of the stack. *)

val pop : ('a, 'a) m
(** [pop] is a monadic value whose underlying data is the top value of the stack, 
    and the new state no longer has the top value. This may throw an exception when run. *)

val run : ('a, 'b) m -> 'a
(** [run x] takes [x] out of monad-land by providing an initial empty stack and throwing 
    away the final stack.  Recall that ['a] is the underlying data type, and ['b] is the 
    type of value in the stack. From this signature, we see that the data in the stack 
    is thrown away, and the underlying data is kept. *)

val is_empty : (bool, 'a) m
(** [is_empty] is a monadic value whose underlying data is true if and only if the stack is empty *)
