
(*
  To assist in writing the keywordcount executable, we would like to use a histogram module to help count the keywords and display the results nicely.

  The histogram will map keywords to the counts. This will use a functional map; in the last assignment, you made a map, and in this assignment, you'll use Core's map.
  
  This file describes the module. Implement it in `histogram.ml`. We have done some setup there for you.
*)

open Core

module Pair :
  sig
    type t =
      { keyword : string
      ; count   : int } [@@deriving compare]
  end

type t [@@deriving compare]

val empty : t
(** [empty] is a histogram with nothing in it. *)

val increment : t -> string -> t
(** [increment t key] has the count associated with [key] in [t] increased by 1. *)

val increment_many : t -> string list -> t
(** [increment t keys] has the count in [t] increased by 1 for each key for each occurance of the key in [keys]. *)

val to_pair_list : t -> Pair.t list
(** [to_pair_list t] is a list of key,value pairs in [t], ordered first by count and then alphabetically when counts are tied. *)

val of_pair_list : Pair.t list -> t
(** [of_pair_list ls] is a histogram of the pairs in [ls]. *)

val sexp_of_t : t -> Sexp.t
(** [sexp_of_t t] is the s-expression for [to_pair_list t]. *)

val t_of_sexp : Sexp.t -> t
(** [sexp_of_t] is the inverse of t_of_sexp. *)

val to_string : t -> string
(** [to_string t] is [to_pair_list t] formatted as an s-expression string. *)

