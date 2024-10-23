(*
  Put all helper functions needed for keywordcount here. Helper functions should be tested, and
  they go in this file so that they are testable. If they are only in keywordcount.ml,
  which compiles to an executable, then they are not accessible from a test file.

  Feel free to remove `placeholder` when you add your actual functions.
*)

val is_valid_file : string -> bool

val directory_build_elts : string -> string list

val remove_stuff_from_string_helper : string -> string

val remove_comments_and_strings : string -> string

val is_non_character : char -> bool

val add_to_histogram : string -> Histogram.t -> Histogram.t

