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


(** [size t] is the number of branch items in the tree [t]. Leaf nodes do not count towards size. *)
let rec size (tree : 'a t) : int =
  match tree with 
  | Leaf -> 0
  | Branch {item; left; right } -> 1 + size left + size right
;;

(* ... below, implement the remaining functions in simpletree.mli ....*)

(** [height t] is the depth of the deepest non-Leaf node in [t]. The depth of the root node is zero.

  If the tree is *only* a Leaf, then say it has height -1 because a Leaf is not a "real node". 
*)
let rec height (tree : 'a t) : int = 
  match tree with 
  | Leaf -> -1
  | Branch {item; left; right} -> 1 + max (height left) (height right)
;;

(*
  Helper function to determine if a branch of a tree is balanced or not depending on its heights.
*)
let is_balanced_helper (branch : 'a t) : bool =
  match branch with 
  | Leaf -> true
  | Branch {item; left; right} -> abs (height left - height right) <= 1
;;

(** [is_balanced t] is true if for every branch in [t], the heights of the left and right subtrees do not differ by more than 1.

  It is helpful here to say that a Leaf has height -1
*)
let rec is_balanced (tree : 'a t) : bool = 
  match tree with
  | Leaf -> true
  | Branch {item; left; right} -> is_balanced_helper tree && is_balanced left && is_balanced right
;;

(*
  Helper recursive function for to_list, using :: operator so that the function runs on O(1) time or as close to it as possible.
*)
let rec to_list_helper (tree : 'a t) (aux : 'a list) : 'a list = 
  match tree with 
  | Leaf -> aux
  | Branch {item; left; right} -> 
    to_list_helper left (item :: to_list_helper right aux)
;;

(** [to_list t] is the tree [t] flattened into a list of items which retains the tree's ordering (the 'inorder' traversal).
  This should take O(n) time; recall that each (::) is O(1) and each (@) is O(n). 
*)
let to_list (tree : 'a t) : 'a list = 
  to_list_helper tree []
;;

(*
  Helper function to determine whether or not a value is within the min or max
*)
let within_min_max (item : 'a) (min : 'a) (max : 'a) ~compare : bool = 
  (match min with
    | Some min_val -> compare item min_val > 0
    | None -> true)
  &&
  (match max with
    | Some max_val -> compare item max_val < 0
    | None -> true)
;;

(*
  Helper function to determine if a branch is ordered or not, depending on its left and right node and minimum and maximum values for said nodes.
*)
let rec is_ordered_helper (tree : 'a t) (min : 'a) (max : 'a) ~compare : bool = 
  match tree with 
  | Leaf -> true
  | Branch {item; left; right} -> within_min_max item min max ~compare && is_ordered_helper left min item ~compare && is_ordered_helper right item ~compare max
;;

(** [is_ordered t ~compare] is true if for every branch in [t], all left subtree items are strictly less than the branch item, and all 
    right subtree items are strictly greater.
    Note that this requirement guarantees (by induction) that the tree has no duplicate items. *)

let is_ordered (tree : 'a t) ~compare : bool = 
  is_ordered_helper tree None None ~compare
;;
