open Core

(* Create an n-gram model using the String module *)
module StringNGram = Ngramtype.MakeNGram(String)

(* Remove empty strings from a list *)
let remove_empty_strings words =
  List.filter ~f:(fun word -> String.length word > 0) words

(* Trim whitespace from the beginning and end of a string *)
let trim str =
  let len = String.length str in
  let rec left_pos i =
    if i >= len || not (Char.is_whitespace str.[i]) then i else left_pos (i + 1)
  in
  let rec right_pos i =
    if i < 0 || not (Char.is_whitespace str.[i]) then i else right_pos (i - 1)
  in
  let left = left_pos 0 in
  let right = right_pos (len - 1) in
  if left > right then "" else String.sub ~pos:left ~len:(right - left + 1) str

(* Sanitize a string by trimming, converting to lowercase, and removing non-alphanumeric characters *)
let sanitize_string (str : string) : string =
  let is_alphanumeric ch = Char.is_alphanum ch in
  String.filter (String.lowercase (trim str)) ~f:is_alphanumeric

(* Sanitize a sequence of strings *)
let sanitize_sequence (words : string list) : string list =
  List.map ~f:sanitize_string words

(* Read the file and split its contents into words, treating whitespace equally *)
let read_corpus (corpus_file : string) : string list =
  let content = In_channel.read_all corpus_file in
  let words = String.split ~on:' ' content in
  List.concat_map words ~f:(String.split ~on:'\n')
  |> List.filter ~f:(fun word -> not (String.is_empty (String.strip word)))

(* Initialize an n-gram distribution using the sanitized sequence and n *)
let create_string_ngram (words : string list) (n : int) : StringNGram.ngram_data =
  let rec aux acc words =
    match words with
    | [] | [_] -> acc  (* Stop when there are not enough words left *)
    | _ ->
      let context, next_elem = List.split_n words (n - 1) in
      match next_elem with
      | [] -> acc  (* No next word available, stop processing *)
      | next_word :: _ ->  (* Use head safely *)
        (* Add the next word to the sequence in the n-gram model *)
        let updated_acc = StringNGram.add_sequence acc context next_word in
        aux updated_acc (List.tl_exn words)  (* Continue with the rest of the words *)
  in
  aux StringNGram.empty words  (* Start with an empty n-gram data structure *)

let output_most_frequent_ngrams ngram_counts n_most_frequent =
  let sorted_ngrams = Map.to_alist ngram_counts 
                      |> List.sort ~compare:StringNGram.compare_ngrams in
  let most_frequent = List.take sorted_ngrams n_most_frequent in

  let output = 
    (* Start the outermost parentheses *)
    String.concat ~sep:"" (
      List.map most_frequent ~f:(fun (ngram, frequency) ->
          (* Construct the string representation of each ngram and frequency *)
          let ngram_str = 
            "(" ^ (String.concat ~sep:" " (List.map ngram ~f:(fun word -> word))) ^ ")"
          in
          "((ngram" ^ ngram_str ^ ")(frequency " ^ (Int.to_string frequency) ^ "))"
        )
    )
  in
  print_string ("(" ^ output ^ "))")

let rec sample_sequence ngram_data context length aux =

  (* Check if we've reached the desired length *)
  if List.length aux >= length then
    aux
  else
    match StringNGram.find ngram_data context with
    | None ->
      aux  (* If there are no choices, return what we have *)
    | Some choices ->
      let next_word = StringNGram.sample_random choices in

      let new_aux = aux @ [next_word] in

      (* Create a new context by dropping the head of the old context and adding the new word *)
      let new_context = List.drop context 1 @ [next_word] in

      (* Recursive call to continue sampling *)
      sample_sequence ngram_data new_context length new_aux




