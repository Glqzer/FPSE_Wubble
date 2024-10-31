
(*
  ----------
  BACKGROUND
  ----------

  In this assignment you'll create and use a stateful stack monad. This will be done by
  writing a functor that makes most of a monad module's functions for you.

  You'll then use the functor to make your stack monad module, write a few extra helpful
  functions, and use that module in a simple program.

  Recall the monads lecture here:

    https://pl.cs.jhu.edu/fpse/lecture/encoding_effects.ml 

  To write the FPSE Monad `Make` module, you will follow a type-directed programming approach. 
  It may seem challenging to implement everything described by this `mli`, but if you
  follow the types and think about the only way to implement the functions, you'll get there.
  Think about what you are given (the inputs to the function), what you have at your disposal
  (only what is passed in as the `Basic` module), and what you need to construct.
*)

(*
  -----------
  BASIC MONAD
  -----------

  Our basic monad will be parametrized by two types and have two functions:
  * [bind] "maps" the given monad by [f]
  * [return] creates a monad from the given underlying value

  Note that in lecture we say a monad is anything matching some different general
  module type than `Basic` below (it is the `Monadic` module in the lecture notes),
  but we are simplifying it for this assignment and also adding two polymorphic 
  parameters instead of one.
*)
module type Basic =
  sig
    (* In this assignment, we'll go against the `Core` convention and call any monad type `m`. *)
    type ('a, 'b) m

    val bind : ('a, 'b) m -> f:('a -> ('c, 'b) m) -> ('c, 'b) m

    val return : 'a -> ('a, 'b) m
  end

(*
  ---------------
  MONAD SIGNATURE
  ---------------

  Provided the type and functions in the `Basic` monad, we can create
  all of the following functions in the signature `S`, to give ourselves
  more operations on the monad.

  Note that this extension operation is built into Core as the `Monad.Make` functor;
  here we are asking you to implement this extension yourselves to better 
  understand how they work.

  We give you hints for which functions from `Basic` you might use to 
  implement functions in `S`.
*)
module type S =
  sig
    include Basic

    val map : ('a, 'b) m -> f:('a -> 'c) -> ('c, 'b) m
    (** [map] is implemented using [bind] and [return]. *)

    val compose : ('a -> ('b, 'c) m) -> ('b -> ('d, 'c) m) -> 'a -> ('d, 'c) m
    (** [compose] is implemented using [bind]. *)

    val (>>=) : ('a, 'b) m -> ('a -> ('c, 'b) m) -> ('c, 'b) m
    (** [>>=] is infix [bind]. *)

    val (>>|) : ('a, 'b) m -> ('a -> 'c) -> ('c, 'b) m
    (** [>>|] is infix [map]. *)

    val (>=>) : ('a -> ('b, 'c) m) -> ('b -> ('d, 'c) m) -> 'a -> ('d, 'c) m
    (** [>=>] (aka "fish") is infix [compose]. *)

    val join : (('a, 'b) m, 'b) m -> ('a, 'b) m
    (** [join] is implemented using [bind]. *)

    (*
      We have this for the `let%bind` and `let%map` rewritings from `ppx_let`.
      These `bind` and `map` are the same as they are above.

      The rewritings can be used if there is a properly loaded `Let_syntax` module in scope.
    *)
    module Let_syntax :
      sig
        val bind : ('a, 'b) m -> f:('a -> ('c, 'b) m) -> ('c, 'b) m
        val map : ('a, 'b) m -> f:('a -> 'c) -> ('c, 'b) m
      end
  end

(*
  ------------
  MAKE FUNCTOR
  ------------

  The functor `Make` has the signature `M`, which takes a `Basic` module and
  produces an `S` module. Use the hints above to implement this in `fpse_monad.ml`.
*)
module type M = functor (X : Basic) -> S with type ('a, 'b) m = ('a, 'b) X.m

module Make : M