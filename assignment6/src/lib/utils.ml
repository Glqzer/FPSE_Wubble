open Core

module StringNGram = Types.MakeNGram(String)

(* Sanitize a string by converting it to lowercase and removing non-alphanumeric characters *)
let sanitize_string (str : string) : string =
  let is_alphanumeric ch = Char.is_alphanum ch in
  String.filter (String.lowercase str) ~f:is_alphanumeric

(* Sanitize a sequence of strings *)
let sanitize_sequence (words : string list) : string list =
  List.map ~f:sanitize_string words

(* Read the file and split its contents into words, treating whitespace equally *)
let read_corpus (corpus_file : string) : string list =
  let content = In_channel.read_all corpus_file in
  let words = String.split ~on:' ' content in
  List.concat_map words ~f:(String.split ~on:'\n')
  |> List.filter ~f:(fun word -> not (String.is_empty (String.strip word)))

(* Initialize an n-gram distribution using the sanitized sequence and N *)
let create_string_ngram (words : string list) (n : int) : string list StringNGram.ngram_data =
  let rec aux acc words =
    match words with
    | [] | [_] -> acc  (* Stop when there are not enough words left *)
    | _ ->
      let context, next_elem = List.split_n words (n - 1) in
      let next_word = List.hd_exn next_elem in
      let updated_acc = StringNGram.add_sequence acc context [next_word] in
      aux updated_acc (List.tl_exn words)
  in
  aux StringNGram.empty words

