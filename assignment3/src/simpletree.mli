(* 
  This file specifies the interface for your code and must not be edited (it will not be included in your zip submission). 
  Your actual implementation should go in the file `simpletree.ml` which satisfies this interface appropriately.

  Mutation operations of OCaml are not allowed or required.
*)

type 'a t =
  | Leaf
  | Branch of
      { item:  'a
      ; left:  'a t
      ; right: 'a t } [@@deriving show]

val size : 'a t -> int
(** [size t] is the number of branch items in the tree [t]. Leaf nodes do not count towards size. *)

val height : 'a t -> int
(** [height t] is the depth of the deepest non-Leaf node in [t]. The depth of the root node is zero.
  If the tree is *only* a Leaf, then say it has height -1 because a Leaf is not a "real node". *)

val is_balanced : 'a t -> bool
(** [is_balanced t] is true if for every branch in [t], the heights of the left and right subtrees do not differ by more than 1.
    It is helpful here to say that a Leaf has height -1. *)

val to_list : 'a t -> 'a list
(** [to_list t] is the tree [t] flattened into a list of items which retains the tree's ordering (the 'inorder' traversal).
    This should take O(n) time; recall that each (::) is O(1) and each (@) is O(n). *)

val is_ordered : 'a t -> compare:('a -> 'a -> int) -> bool
(** [is_ordered t ~compare] is true if for every branch in [t], all left subtree items are strictly less than the branch item, and all 
    right subtree items are strictly greater.
    Note that this requirement guarantees (by induction) that the tree has no duplicate items. *)