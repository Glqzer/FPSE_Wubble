
val factors : int -> int list
(** [factors n] is all positive factors of [n]. *)

val arithmetic_progression : int -> int -> int -> int list
(** [arithmetic_progression n d k] is the list [n; n + d; n + 2d; ...; n + (k-1)d], where [k] is non-negative. *)

val insert_string : string -> string list -> (string list, string) result
(** [insert_string s ls] is Ok of [ls] with [s] added if [ls] is ordered, otherwise is Error "insert into unordered list". *)

val split_list : 'a list -> int -> 'a list * 'a list
(** [split_list ls n] is a tuple of the first [n] elements of [ls], and the remaining elements. *)