(** N-gram module signature for defining n-gram data structures for any type of Element *)

module type Element = sig
  type t [@@deriving sexp, compare]
end

module MakeNGram (Elem : Element) : sig
  (** Type for n-gram data, where keys are sequences of elements and values are lists of next elements. *)
  type 'a ngram_data

  (** [add_sequence ngram_data sequence next_elem] adds or updates the map with a new sequence and its next element. *)
  val add_sequence : 'a ngram_data -> Elem.t list -> 'a -> 'a ngram_data

  (** [empty] creates an empty n-gram data structure. *)
  val empty : 'a ngram_data
end