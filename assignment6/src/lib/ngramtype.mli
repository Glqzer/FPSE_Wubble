open Core

(* Signature for an Element that will be used as n-gram components *)
module type Element = 
sig
  type t [@@deriving sexp, compare]
end

(* Functor to create an n-gram data structure for any type of Element *)
module MakeNGram (Elem : Element) : 
sig
  (* Map structure to store n-grams and their potential next elements *)
  module NGramMap : Map.S with type Key.t = Elem.t list

  (* Type representing the n-gram data structure *)
  type ngram_data = Elem.t list NGramMap.t

  (* Add a next element to the sequence of elements in the n-gram data *)
  val add_sequence : ngram_data -> Elem.t list -> Elem.t -> ngram_data

  (* The empty n-gram data structure *)
  val empty : ngram_data

  (* Find the list of next elements for a given context *)
  val find : ngram_data -> Elem.t list -> Elem.t list option

  (* Count the occurrences of all n-grams in the data structure *)
  val count_ngrams : ngram_data -> int NGramMap.t

  (* Compare two n-grams based on frequency, and lexicographically if tied *)
  val compare_ngrams : Elem.t list * int -> Elem.t list * int -> int

  (* Sample a random element from a list of choices *)
  val sample_random : Elem.t list -> Elem.t
end
