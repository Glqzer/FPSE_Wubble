(*
  --------
  OVERVIEW
  --------

  In this assignment you'll make a functor. We provide a long description with
  motivation and examples, and mixed in are some requirements for this assignment.
  Please read it all and then write your implementation in `finite_group.ml`.

  ----------
  MOTIVATION
  ----------
   
  This assignment covers many of the topics in the "More Modules" lecture, so you
  may want to review that for lots of hints of how to proceed here.

  One thing which is ubiquitous in many object-oriented languages is the ability
  to program against an interface and not an underlying class or type, enabling
  dependency injection, easier unit testing, and encapsulation of implementation
  details.

  We've seen in OCaml how to use polymorphic functions (those involving types
  like 'a) to operate on any kind of data, but in that case we need to know
  _nothing_ about the object. We've also seen how to hide parts of our
  implementation by not including certain details about types in our .mli files
  or module signatures (aka module types) (e.g. in Histogram from Assignment 4),
  and not including functions which are only meant to be called by some more
  limited exposed API (e.g. balancing functions from Assignment 3). But how can
  we write functions which operate on types that have a specific interface,
  rather than "any type"? Imperative languages would often use traits or
  interfaces for this, or simply dynamic dispatch and class hierarchies. What's
  idiomatic in OCaml?

  It turns out that module types and functors do the trick of naming our
  dependencies and specifying exactly what can be relied upon.

  Better than that, we aren't restricted to specifying only one "class" and its
  interfaces, we can ask for any number and kind of functions operating over
  multiple types and produce an entire module which makes use of those
  behaviors.

  Using functors in this way decouples our code from the implementation of
  functionality it depends on and from the representation of objects which it
  uses, allowing a very powerful kind of dependency injection.

  
  ----------
  BACKGROUND
  ----------
  
  In this assignment, you will implement a functor to create a finite
  mathematical group. A group is a set with an operation with three conditions:
  1. There is a unique identity element.
  2. Every element has a unique inverse.
  3. The operation is associative.

  You can check out the Wikipedia page for a group (mathematics) for some more background,
  but we think you can get by with just this assignment description.

  We will make a group over an enumerable, finite set with an operation. It is not promised
  that this operation is simple or quick to compute.

  Then, we will memoize the results in a new module for faster computation.


  ------------
  MODULE TYPES
  ------------
  
  A module type is a signature for a module. It is much like defining a type `t`.
  Here are two code fragments to serve as an example.
  This first one is something you've seen before in a .mli file that defines a type t
  and claims that some value `m` with type t will be implemented in the .ml file.
  ```
  type t = int
  val m : t
  ```
  And here is an example of a module type T and a module `M` that has type T.
  ```
  module type T = sig type t end
  module M : T
  ```
  In these examples, `t` is analogous to `T`, and `n` is analogous to `M`.

  This promises that the module type T will be defined again in the .ml file in the exact
  same way, and that some module M will have the signature of module type T. In this example,
  it is only promised that `M` will have a `type t` within it because that is all `T` requires.

  Just like every value has a type, every module has a module type. In the .mli file here,
  we declare what that module type is for each module.


  --------
  FUNCTORS
  --------

  Functors are functions on modules. They take a module as an argument, and they
  "return" a module.  Here is an example of a functor signature:
  ```
  module type T = sig type t end
  module type S = sig type t val f : t -> t end
  module F (_ : T) : S (* alternatively module F : functor (_ : T) -> S *)
  ```
  This promises that a functor F will be implemented in the .ml file, and it
  will take an argument that has module type T, and the "returned" module will
  have module type S.

  Functors were covered in the More Modules lecture. For an example, see the
  set-example-functor at
    https://pl.cs.jhu.edu/fpse/examples/set-example-functor.zip
  which was also linked in the lecture. This example shows the ".ml-side" of the
  picture, so you can see how the functors here might be implemented in the .ml file.

  With this, we should be ready to carry on to the assignment.
*)

(*
  -----
  SETUP   
  -----

  We would like to make a group over a set. What do we need from the set
  in order to make a group over it? For the sake of computability, we want
  to be able to enumerate the set, and it should be finite. Here is a module
  type that captures some of those requirements.
*)

module type Enumerable =
  sig
    type t [@@deriving sexp, compare]
    (** [t] is any comparable, serializable type that can be enumerated. *)

    val zero : t
    (** [zero] is the first element in the enumeration.
        It is not necessarily the identity element for all groups over this set. *)

    val next : t -> t option
    (** [next t] is the next element in the enumeration, following [t].
        It is promised that there exists some [x] such that [next x] is [None].
        Otherwise, we will not be able to brute-force find an identity element with certainty. *)
  end

(*
  We would further like this enumerable type to have an operation. If this
  operation is associative and yields a unique identity and an inverse for each
  element, then we can make a group out of it.   

  The OCaml type system doesn't allow us to encode such requirements--"associative",
  "invertible", etc.--and instead, we just have to make a promise in a comment.
*)

module type Operable =
  sig
    include Enumerable (* aka Operable has everything that Enumerable has, and more! *)
    
    val op : t -> t -> t
    (** [op x y] is some element in the enumerable set. [op] is associative, yields
        a unique identity, and yields a unique inverse for each element. *)
  end

(*
  Module type `S` is a signature for the finite group module (we are within
  `finite_group.mli`, and we use S to refer to the signature of some finite
  group, which will be needed for a functor later).

  Such a group lets the user operate on elements (as is given in `Operable`),
  and it lets the user see the identity element and get the inverse for
  any element.

  That's it. That's all a group is!
*)
module type S =
  sig
    include Operable (* S has everything Operable has, and more. *)

    val id : unit -> t
    (** [id ()] is the identity element. It is the left and right identity for any [x : t]. *)

    val inverse : t -> t
    (** [inverse x] is the left and right inverse of [x].
        i.e. all three of the following are the same:
        - [id ()]
        - [op (inverse x) x]
        - [op x (inverse x)] *)
  end

(*
  -----------------
  WRITING A FUNCTOR   
  -----------------

  We've now seen what we are working with and what we need to make. Let's now
  describe how a user can make a group.

  The user can make a group using a functor of module type `M`. Any module
  having this module type will be a functor that takes `Op` with type
  `Operable`, and it returns a group where the element has the same type as the
  given module `Op`.

  In short, a functor that "makes" a group has the following module type.
*)

module type M = functor (Op : Operable) -> S with type t = Op.t

(*
  `Make` will be an instance of such a functor. You are to implement `Make` in
  `finite_group.ml`. Because the syntax is a little bit tricky here, we provide
  the most basic syntax for you in `finite_group.ml` to help you avoid simple
  syntax errors.

  Our expectations are as follows:
  * The `id` and `inverse` functions adhere to the descriptions in `S` above.
  * You need not worry about efficiency of your functions; it is okay to
    recompute anything as much as you want.
  * There should be no startup cost. Upon using the functor, no code gets
    eagerly evaluated.
    Here are two examples to illustrate this point:
    ```
    module Make1 (T : sig type t end) : sig val g : unit -> T.t end =
      struct
        let f = failwith "fail message" (* This gets eagerly evaluated and fails when the functor is used *)
        let g () = f
      end
    module Make2 (T : sig type t end) : sig val g : unit -> T.t end =
      struct
        let g () = failwith "fail message" (* This fails only when `g` is called, not when the functor is used *)
      end
    ```
*)

module Make : M

(*
  Above we put no restrictions on efficiency. If the group operation is
  expensive, then it will be terribly slow to call any of the functions made by
  `Make`. If we expect to use each element of the group a lot, then potentially
  it is beneficial to precompute the identity, every operation, and every inverse.
  Then, these functions become simple lookups and won't have high cost.

  You will write an alternative implementation, `Make_memoized`, that addresses
  this problem and "memoizes" every result possible. This will be done with no
  mutation; instead the module will simply hold a map containing the precomputed
  results.

  Here are our expectations for your implementation of `Make_memoized (Op : Operable)`:
  * All results will be computed upon calling the functor.
  * `Op.op` is called at most once per pair of values. Should the same result
    be needed again, the memoized version is used.
  * Space complexity may be O(n^2) where `Op` describes `n` elements.
  * Supposing `Op.compare` is O(1), then `Make_memoized` must give the following time complexity:
      * `op` is now O(log n)
      * `id` is O(1)
      * `inverse` is O(log n)
  * You are required to use `Map` to achieve these time complexities. Remember that `Map`
    needs a module with sexp and compare (hence why we have [@@deriving sexp, compare] in
    the Enumerable module type).
*) 

module Make_memoized : M
