open Core

(* Define the signature for an Element that will be used as n-gram components *)
module type Element = 
sig
  type t [@@deriving sexp, compare]
end

(* Functor to create an n-gram data structure for any type of Element *)
module MakeNGram (Elem : Element) = 
struct
  module NGramMap = Map.Make(
    struct
      type t = Elem.t list [@@deriving sexp, compare]
      let compare = compare
    end)

  type ngram_data = Elem.t list NGramMap.t

  let add_sequence ngram_data sequence next_elem =
    let current = Map.find ngram_data sequence |> Option.value ~default:[] in
    let updated = next_elem :: current in
    Map.set ngram_data ~key:sequence ~data:updated

  let empty : ngram_data = NGramMap.empty

  let find ngram_data context : Elem.t list option =
    Map.find ngram_data context

  let count_ngrams ngram_data : int NGramMap.t =
  Map.fold ngram_data ~init:NGramMap.empty ~f:(fun ~key ~data acc ->
    List.fold data ~init:acc ~f:(fun accnew elem ->
      let full_ngram = key @ [elem] in
      let count = Map.find accnew full_ngram |> Option.value ~default:0 in
      Map.set accnew ~key:full_ngram ~data:(count + 1)
    )
  )

  let compare_ngrams (ngram1, freq1) (ngram2, freq2) =
    match Int.compare freq2 freq1 with
    | 0 -> List.compare Elem.compare ngram1 ngram2
    | other -> other

  let sample_random choices : Elem.t =
    let index = Random.int (List.length choices) in
    List.nth_exn choices index

end
