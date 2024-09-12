(*
  FPSE Assignment 3

  Name                  : 
  List of Collaborators :

  Please make a good faith effort at listing people you discussed any problems with here, as per the course academic integrity policy.

  See file simpledict.mli for the specification of this assignment. Recall from lecture that .mli files are module signatures (aka module types) and in this file you will need to provide implementations of all the functions listed there.

  Hint: start by reading the code we've put here, and then copy over parts of the .mli file to make dummy headers and fill them with `unimplemented ()`. Note the changes in syntax between .mli and .ml files.

  Note that .ml files need to include all `type` declarations in .mli files.

  You must leave all `[@@deriving show]` annotations, or your autograder won't work. We use this to pretty-print your results.

  -------------
  TIPS AND HELP
  -------------

  Your dictionary must be balanced and ordered. We think that the AVL tree is the simplest way to keep the tree balanced and ordered efficiently, but you can do it however you'd like as long as you still have the correct time complexity.

  The rotations of an AVL can be done easily using pattern matching in functions like `rotate_left`, `rotate_right`, `rotate_left_right`, and `rotate_right_left`. Notice that these functions are not defined in the `.mli`, so they are strictly helper functions for this file, and no outside module can see them.

  The following link describes well the rotations and when they should be done to keep the tree balanced, in case you'd like to make an AVL tree:

    https://www.geeksforgeeks.org/insertion-in-an-avl-tree/

  READ THIS: No matter how you balance, we HIGHLY recommend you implement all these functions using a naive, unbalanced `insert`, and then later go back to add balancing to your `insert` function. You can still earn plenty of autograder points if you don't manage to balance your tree properly.
*)

open Core

(* Disables "unused variable" warning from dune while you're still solving these! *)
[@@@ocaml.warning "-27"]

let unimplemented () =
  failwith "unimplemented"

module Item = struct
  type 'a t = { key: string ; value: 'a } [@@deriving show]

  let compare (x : 'a t) (y : 'a t) : int =
    unimplemented ()

end (* module Item *)


type 'a t = 'a Item.t Simpletree.t [@@deriving show]

let empty : 'a t = Simpletree.Leaf

(* 
  We provide `size` for you to demonstrate that the Simpletree module functions work on the dict
  since the dict is a Simpletree.t.
*)

let size (dict : 'a t) : int =
  Simpletree.size dict

(* ... below, implement the remaining functions in simpledict.mli ....*)

let to_list (dict : 'a t) : (string * 'a) list = 
  unimplemented ()
;;

let lookup (dict : 'a t) ~key : 'a option = 
  unimplemented ()
;;

let lookup_exn (dict : 'a t) ~key : 'a = 
  unimplemented ()
;;

let insert (dict : 'a t) ~key ~value : 'a t = 
  unimplemented ()
;;

let of_list (ls : (string * 'a) list) : 'a t = 
  unimplemented ()
;;

let of_list_multi (ls : (string * 'a) list) : 'a list t = 
  unimplemented ()
;;

let map (dict : 'a t) ~f : 'b t = 
  unimplemented ()
;;

let update (dict : 'a t) ~key ~f : 'a t = 
  unimplemented ()
;;

let merge (dict1 : 'a t) (dict2 : 'a t) : 'a t = 
  unimplemented ()
;;

let merge_with (dict1 : 'a t) (dict2 : 'b t) ~merger : 'c t = 
  unimplemented ()
;;
