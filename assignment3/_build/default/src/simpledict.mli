(* 
  This file specifies the interface for your code and must not be edited (it will not be included in your zip submission). 
  Your actual implementation should go in the file `simpledict.ml` which satisfies this interface appropriately.

  Mutation operations of OCaml are not allowed or required.
*)

module Item : sig
  (*
    The Item module describes a type so that a Tree can represent a dictionary. 
    The type holds a key and a value.
  *)

  type 'a t = { key: string ; value: 'a } [@@deriving show]
  (** For simplicity, we restrict keys to be strings only; the values are type 'a. *)

  val compare : 'a t -> 'a t -> int
  (** [compare a b] is [String.compare a.key b.key]. Values are not compared. *)

end (* module Item *)


type 'a t = 'a Item.t Simpletree.t [@@deriving show]
(** The dict type is a tree of 'a Item.t. Note that because this type is a tree, all Simpletree module functions will work on it.
 
  You may ignore the `[@@deriving show]`. You will not need to work with it, and it is to pretty-print your autograder results. *)

val empty : 'a t
(** [empty] is an empty dictionary. *)

(*
  We will now define several natural operations on these dictionaries.

  IMPORTANT:

    We will implicitly require all dicts **provided to and created by** the functions below to obey the
    `Simpletree.is_ordered` and `Simpletree.is_balanced` requirements.
  
  You do not need to check that the dicts are ordered/balanced when they are provided to a function.

  The autograder for this assignment will check that all dicts resulting from these functions are balanced and ordered.
*)

val size : 'a t -> int
(** [size t] is the number of key, value pairs in [t]. *)

val to_list : 'a t -> (string * 'a) list
(** [to_list t] is a list of (key,value) pairs which retains [t]'s ordering (the 'inorder' traversal).
    This should take O(n) time; recall that each (::) is O(1) and each (@) is O(n). *)

val lookup : 'a t -> key:string -> 'a option
(** [lookup t ~key] is the associated value to [key] in [t], if any.
    This must be O(log n) on average because of the is_ordered and is_balanced requirements. *)

val lookup_exn : 'a t -> key:string -> 'a
(** [lookup_exn t ~key] is the associated value to [key] in [t], or an exception if it's not found. *)

val insert : 'a t -> key:string -> value:'a -> 'a t
(** [insert t ~key ~value] is a dictionary with [key] mapping to [value] in [t], overwriting any existing
    value attached to the key in [t] if present.
    This should also be O(log n), as explained in lecture. *)

val of_list : (string * 'a) list -> 'a t
(** [of_list ls] is a dictionary containing all key, value pairs in [ls].
    If [ls] contains duplicate keys, the value associated to the last instance of the key in [ls] is kept. *)

val of_list_multi : (string * 'a) list -> 'a list t
(** [of_list_multi ls] is a dictionary mapping the keys in [ls] to the list of all values associated to the key.
    The list of values is in the order they occur in [ls].
    e.g. [of_list_multi [("hello", 0); ("world", 1); ("hello", 2)]] gives a tree that looks like
          { key:"hello" ; value:[0; 2] }
              /               \
            Leaf         { key:"world" ; [1] }
        modulo shape of tree. *)

val map : 'a t -> f:(string -> 'a -> 'b) -> 'b t
(** [map t ~f] is a dictionary where every value in [t] has been mapped by [f]. The keys stay constant.
    The mapping function [f] can use the key in its calculation, so we pass it as an argument. *)

val update : 'a t -> key:string -> f:(string -> 'a -> 'a) -> 'a t
(** [update t ~key ~f] is the dictionary [t] where the value associated to [key] has been mapped with [f].
    The operation is applied to the value in [t] corresponding to exactly the given [key], and not to any other values.
    If [key] does not exist in [t], then the original dictionary is returned. *)

val merge : 'a t -> 'a t -> 'a t
(** [merge a b] is a dictionary containing all key, value pairs in [a] and [b]. If both contain a value associated
    to a key, then [b]'s value is retained, and [a]'s value is overwritten. *)

val merge_with : 'a t -> 'b t -> merger:('a option -> 'b option -> 'c) -> 'c t
(** [merge_with a b ~merger] is a dictionary where the values associated to a key are computed by [merger].
    [merger] gets Some or None depending on the presence of each key in [a] and [b].
    Since we have a [merger] function, the dictionaries [a] and [b] may, in principle, have different types. *)
