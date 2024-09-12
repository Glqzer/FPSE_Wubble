(*
  FPSE Assignment 3

  Name                  : 
  List of Collaborators :

  Please make a good faith effort at listing people you discussed any problems with here, as per the course academic integrity policy.

  See file simpletree.mli for the specification of this assignment. Recall from lecture that .mli files are module signatures (aka module types) and in this file you will need to provide implementations of all the functions listed there.

  Hint: start by reading the code we've put here, and then copy over parts of the .mli file to make dummy headers and fill them with `unimplemented ()`. Note the changes in syntax between .mli and .ml files.

  Note that .ml files need to include all `type` declarations in .mli files. We have written this in for you.

  You must leave all `[@@deriving show]` annotations. Otherwise, your autograder won't work. We use this to pretty-print your results.
*)

open Core

(* Disables "unused variable" warning from dune while you're still solving these! *)
[@@@ocaml.warning "-27"]

let unimplemented () = failwith "unimplemented"

type 'a t =
  | Leaf
  | Branch of
      { item:  'a
      ; left:  'a t
      ; right: 'a t } [@@deriving show]

let size (tree : 'a t) : int =
  unimplemented ()

(* ... below, implement the remaining functions in simpletree.mli ....*)
