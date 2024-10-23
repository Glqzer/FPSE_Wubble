open Core

(* Create an n-gram model using the String module *)
module StringNGram : module type of Ngramtype.MakeNGram(String)

(* Remove empty strings from a list *)
val remove_empty_strings : string list -> string list

(* Trim whitespace from the beginning and end of a string *)
val trim : string -> string

(* Sanitize a string by trimming, converting to lowercase, and removing non-alphanumeric characters *)
val sanitize_string : string -> string

(* Sanitize a sequence of strings *)
val sanitize_sequence : string list -> string list

(* Read the file and split its contents into words, treating whitespace equally *)
val read_corpus : string -> string list

(* Initialize an n-gram distribution using the sanitized sequence and n *)
val create_string_ngram : string list -> int -> StringNGram.ngram_data

(* Output the most frequent n-grams *)
val output_most_frequent_ngrams : int Ngramtype.MakeNGram(String).NGramMap.t -> int -> unit

(* Sample a sequence of a given length from the n-gram data *)
val sample_sequence : StringNGram.ngram_data -> string list -> int -> string list -> string list
