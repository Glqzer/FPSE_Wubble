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

(*
  Notes: NOT FOUND deprecated

*)

open Core
open Simpletree

(* Disables "unused variable" warning from dune while you're still solving these! *)
[@@@ocaml.warning "-27"]

exception Not_found_error of string

let unimplemented () =
  failwith "unimplemented"

module Item = struct
  type 'a t = { key: string ; value: 'a } [@@deriving show]

  let compare (x : 'a t) (y : 'a t) : int =
    unimplemented ()

end (* module Item *)


type 'a t = 'a Item.t Simpletree.t [@@deriving show]

let empty : 'a t = Simpletree.Leaf
(** [empty] is an empty dictionary. *)

(*
  We will now define several natural operations on these dictionaries.

  IMPORTANT:

    We will implicitly require all dicts **provided to and created by** the functions below to obey the
    `Simpletree.is_ordered` and `Simpletree.is_balanced` requirements.
  
  You do not need to check that the dicts are ordered/balanced when they are provided to a function.

  The autograder for this assignment will check that all dicts resulting from these functions are balanced and ordered.
*)

(* AVL FUNCTIONS

(*
  Helper function to check the balance factor of the tree.
*)
let balance_factor (dict : 'a t) : int = 
  match dict with 
  | Leaf -> 0
  | Branch { item; left; right } -> height left - height right


(* 
  Helper function to rotate left
*)
let rotate_left ~root ~right ~right_left =
  match right with
  | Branch { item = right_item; left = _; right = right_right } ->
      Branch {
        item = right_item;
        left = Branch { item = root; left = Leaf; right = right_left };
        right = right_right;
      }
  | Leaf -> failwith "rotate_left: Invalid rotation"

(*
  Helper function to rotate right
*)
let rotate_right ~root ~left ~left_right =
  match left with
  | Branch { item = left_item; left = left_left; right = _ } ->
      Branch {
        item = left_item;
        left = left_left;
        right = Branch { item = root; left = left_right; right = Leaf };
      }
  | Leaf -> failwith "rotate_right: Invalid rotation"
*)

(* 
  We provide `size` for you to demonstrate that the Simpletree module functions work on the dict
  since the dict is a Simpletree.t.
*)

(** 
  [size t] is the number of key, value pairs in [t]. 
*)
let size (dict : 'a t) : int =
  Simpletree.size dict

(* ... below, implement the remaining functions in simpledict.mli ....*)

(*
  Helper recursive function for to_list, using :: operator so that the function runs on O(1) time or as close to it as possible.
*)
let rec to_list_helper tree aux = 
  match tree with 
  | Leaf -> aux
  | Branch { item; left; right } -> to_list_helper left ((item.Item.key, item.Item.value) :: to_list_helper right aux)
;;

(** 
[to_list t] is a list of (key,value) pairs which retains [t]'s ordering (the 'inorder' traversal).
    This should take O(n) time; recall that each (::) is O(1) and each (@) is O(n). 
*)
let to_list dict = 
  to_list_helper dict []
;;

(** [lookup t ~key] is the associated value to [key] in [t], if any.
    This must be O(log n) on average because of the is_ordered and is_balanced requirements. *)
let rec lookup (dict : 'a t) ~key : 'a option = 
  match dict with 
  | Leaf -> None
  | Branch { item; left; right } -> let comp = String.compare key item.Item.key in
  if comp = 0 then Some item.Item.value
  else if comp < 0 then lookup left ~key
  else lookup right ~key
;;

(** 
  [lookup_exn t ~key] is the associated value to [key] in [t], or an exception if it's not found. 
*)
let rec lookup_exn (dict : 'a t) ~key : 'a = 
  match dict with 
  | Leaf -> raise (Not_found_error "The requested item was not found.")
  | Branch { item; left; right } -> let comp = String.compare key item.Item.key in
  if comp = 0 then item.Item.value
  else if comp < 0 then lookup_exn left ~key
  else lookup_exn right ~key
;;

(** 
  [insert t ~key ~value] is a dictionary with [key] mapping to [value] in [t], overwriting any existing
  value attached to the key in [t] if present.
This should also be O(log n), as explained in lecture. 
*)
let rec insert (dict : 'a t) ~key ~value : 'a t = 
  match dict with
  | Leaf ->
    Branch { item = { key; value }; left = Leaf; right = Leaf }
  | Branch { item; left; right } ->
    let cmp = String.compare key item.Item.key in
    if cmp = 0 then
      Branch { item = { key; value }; left; right }
    else if cmp < 0 then
      let new_left = insert left ~key ~value in
      Branch { item; left = new_left; right }
    else
      let new_right = insert right ~key ~value in
      Branch { item; left; right = new_right }
;;


let rec of_list_helper (ls : (string * 'a) list) (dict : 'a t) : 'a t = 
  match ls with
  | [] -> dict
  | x :: xs -> of_list_helper xs (insert dict ~key:(fst x) ~value:(snd x))
;;

(** 
[of_list ls] is a dictionary containing all key, value pairs in [ls].
  If [ls] contains duplicate keys, the value associated to the last instance of the key in [ls] is kept. 
*)
let of_list (ls : (string * 'a) list) : 'a t = 
  of_list_helper ls empty
;;

(*
  Helper function for of_list_multi
*)
let rec of_list_multi_helper (ls : (string * 'a) list) (dict : 'a list t) : 'a list t = 
  match ls with 
  | [] -> dict
  | (key, value) :: xs -> match lookup dict ~key:(key) with 
    | Some values -> let updated_dict = insert dict ~key ~value:(value :: values) in
    of_list_multi_helper xs updated_dict
    | None -> let updated_dict = insert dict ~key ~value:[value] in
    of_list_multi_helper xs updated_dict
    

(** [of_list_multi ls] is a dictionary mapping the keys in [ls] to the list of all values associated to the key.
    The list of values is in the order they occur in [ls].
    e.g. [of_list_multi [("hello", 0); ("world", 1); ("hello", 2)]] gives a tree that looks like
          { key:"hello" ; value:[0; 2] }
              /               \
            Leaf         { key:"world" ; [1] }
        modulo shape of tree. *)
let of_list_multi (ls : (string * 'a) list) : 'a list t = 
  of_list_multi_helper ls empty
;;

(** 
[map t ~f] is a dictionary where every value in [t] has been mapped by [f]. The keys stay constant.
  The mapping function [f] can use the key in its calculation, so we pass it as an argument. 
*)
let rec map (dict : 'a t) ~f : 'b t = 
  match dict with 
  | Leaf -> Leaf
  | Branch { item; left; right } -> 
    let new_value = f item.Item.key item.Item.value in
    let new_item = { item with value = new_value } in
    let new_left = map left ~f in
    let new_right = map right ~f in
    Branch { item = new_item; left = new_left; right = new_right }
;;

(** 
  [update t ~key ~f] is the dictionary [t] where the value associated to [key] has been mapped with [f].
    The operation is applied to the value in [t] corresponding to exactly the given [key], and not to any other values.
  If [key] does not exist in [t], then the original dictionary is returned. 
*)
let rec update (dict : 'a t) ~key ~f : 'a t = 
  match dict with
  | Leaf -> Leaf
  | Branch { item; left; right } ->
    if String.compare key item.Item.key = 0 then
      let new_value = f item.Item.key item.Item.value in
      let new_item = { item with value = new_value } in
      Branch { item = new_item; left; right }
    else if String.compare key item.Item.key < 0 then
      let new_left = update left ~key ~f in
      Branch { item; left = new_left; right }
    else
      let new_right = update right ~key ~f in
      Branch { item; left; right = new_right }
;;

(** 
[merge a b] is a dictionary containing all key, value pairs in [a] and [b]. If both contain a value associated
    to a key, then [b]'s value is retained, and [a]'s value is overwritten. 
*)
let rec merge (dict1 : 'a t) (dict2 : 'a t) : 'a t = 
  match dict2 with
  | Leaf -> dict1
  | Branch { item; left; right } ->
    let updated_dict1 = insert dict1 ~key:item.Item.key ~value:item.Item.value in
    let merged_left = merge updated_dict1 left in
    let merged_right = merge merged_left right in
    merged_right
;;

(** [merge_with a b ~merger] is a dictionary where the values associated to a key are computed by [merger].
    [merger] gets Some or None depending on the presence of each key in [a] and [b].
    Since we have a [merger] function, the dictionaries [a] and [b] may, in principle, have different types. *)
let merge_with (dict1 : 'a t) (dict2 : 'b t) ~merger : 'c t = 
  let dict_1_list : (string * 'a) list = to_list dict1 in 
  let dict_2_list : (string * 'b) list = to_list dict2 in 
  let dictMerger1 = List.fold dict_1_list ~init:empty ~f:(fun acc (key, value) -> insert acc ~key:key ~value:(merger (Some value) (lookup dict2 ~key:key)) ) in
  let dictMerger2 = List.fold dict_2_list ~init:empty ~f:(fun acc (key, value) -> insert acc ~key:key ~value:(merger (lookup dict1 ~key:key) (Some value)) ) in
  merge dictMerger1 dictMerger2
;;
