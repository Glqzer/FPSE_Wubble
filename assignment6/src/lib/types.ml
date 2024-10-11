open Core

(* Define the signature for an Element that will be used as n-gram components *)
module type Element = 
sig

  type t [@@deriving sexp, compare]

end

(* Functor to create an n-gram data structure for any type of Element *)
module MakeNGram (Elem : Element) = 
struct

  (* Define a map type where keys are lists of the Element type *)
  module NGramMap = Map.Make(
  struct

    type t = Elem.t list [@@deriving sexp, compare]  (* Derive functions for the key type *)

  end)

  (* Type for n-gram data; keys are sequences of Elem.t and values are lists of next elements *)
  type 'a ngram_data = 'a list NGramMap.t

  (* Add or update the map with a new sequence and its next element *)
  let add_sequence (ngram_data : 'a ngram_data) (sequence : Elem.t list) (next_elem : 'a) =
    (* Find the current list of next elements for the given sequence *)
    let current = Map.find ngram_data sequence |> Option.value ~default:[] in
    (* Update the list with the new next element *)
    let updated = next_elem :: current in
    (* Return the updated map with the new entry *)
    Map.set ngram_data ~key:sequence ~data:updated

  (* A function to create an empty n-gram data structure *)
  let empty : 'a ngram_data = NGramMap.empty

  (* Function to count n-gram frequencies in the n-gram model *)
    let count_ngrams (ngram_data : Elem.t ngram_data) : int NGramMap.t =
      Map.fold ngram_data ~init:NGramMap.empty ~f:(fun ~key ~data acc ->
        List.fold data ~init:acc ~f:(fun accnew elem ->
          let full_ngram = key @ [elem] in
          let count = Map.find accnew full_ngram |> Option.value ~default:0 in
          Map.set accnew ~key:full_ngram ~data:(count + 1)
        )
      )
  
  (* Comparator function for sorting by frequency and lexicographically *)
  let compare_ngrams (ngram1, freq1) (ngram2, freq2) =
    match Int.compare freq2 freq1 with
    | 0 -> List.compare Elem.compare ngram1 ngram2
    | other -> other

  (* Function to output the frequent n-grams in sexp format *)
  let output_most_frequent_ngrams (ngram_counts : int NGramMap.t) (n_most_frequent : int) =
    (* Convert the map to a sorted list of (ngram, frequency) pairs *)
    let sorted_ngrams = Map.to_alist ngram_counts |> List.sort ~compare:compare_ngrams in
    (* Take the top N most frequent n-grams *)
    let most_frequent = List.take sorted_ngrams n_most_frequent in

    (* Convert the n-grams and their frequencies into sexp format *)
    let sexp_list = List.map most_frequent ~f:(fun (ngram, frequency) ->
      Sexp.List [
        Sexp.List [Sexp.Atom "ngram"; Sexp.List (List.map ngram ~f:Elem.sexp_of_t)];
        Sexp.List [Sexp.Atom "frequency"; Sexp.Atom (Int.to_string frequency)]
      ]
    ) in

    print_s (Sexp.List sexp_list);

end
