
(*
  The state monad is a function to allow you to "thread" the state through.
  Implement this signature in `state_monad.ml`, and use `Fpse_monad.Make`
  after writing your `bind` and `return` functions.

  See the lecture notes and the `State` module for a very similar implementation.
*)

include Fpse_monad.S with type ('a, 's) m = 's -> 'a * 's

val read : ('s, 's) m
(** [read] is a monadic value whose data is the state. *)
