(*
  See utils.mli. This file contains implementations for your utils.mli functions.
*)

open Core

(* List of OCaml keywords *)
let words = [
  "and"; "as"; "assert"; "asr"; "begin"; "class"; "constraint"; "do"; "done";
  "downto"; "else"; "end"; "exception"; "external"; "false"; "for"; "fun";
  "function"; "functor"; "if"; "in"; "include"; "inherit"; "initializer"; 
  "land"; "lazy"; "let"; "lor"; "lsl"; "lsr"; "lxor"; "match"; "method"; 
  "mod"; "module"; "mutable"; "new"; "nonrec"; "object"; "of"; "open"; 
  "or"; "private"; "rec"; "sig"; "struct"; "then"; "to"; "true"; "try"; 
  "type"; "val"; "virtual"; "when"; "while"; "with";
]

(* 
  Check if a file is a valid OCaml file 
*)
let is_valid_file file : bool =
  Filename.check_suffix file ".ml" || Filename.check_suffix file ".mli"
;;

(*
  Traverse the directory recursively to find each OCaml source file (.ml or .mli)
*)
let rec directory_build_elts (dir : string) : string list =
  let entries = Sys_unix.readdir dir in 
  Array.fold entries ~init:[] ~f:(fun aux entry ->
    let path = Filename.concat dir entry in
    if Sys_unix.is_directory_exn path then
      aux @ directory_build_elts path
    else if is_valid_file path then
      path :: aux
    else 
      aux)

(*
  Pseudocode:
  - Get length of the OCaml Code
  - Check if we have reached end of string
  - Check if we are in a string (nesting), and check for string literals
  - If find "" need to skip to end of the string (find_string_end)

  - Find comments: make sure we are not in a string literal and not past input length


*)
let remove_stuff_from_string_helper (code : string) : string =
  let length = String.length code in 
    let rec assemble (index : int) (nesting : int) (in_string : bool) aux = 
      if index >= length then 
        let aux = List.rev aux in
        String.concat aux
      else 
        match code.[index] with 
        | '"' when nesting = 0 -> 
          let j = index + 1 in
          let rec find_string_end k = 
            if k >= length then k
            else if Char.compare code.[k] '"' = 0 then k + 1
            else find_string_end (k + 1) in
            assemble (find_string_end j) nesting false aux
        | '(' when not in_string && index + 1 < length && Char.compare code.[index + 1] '*' = 0 -> (* Comment start *)
          assemble (index + 2) (nesting + 1) in_string aux
        | '*' when not in_string && nesting > 0 && index + 1 < length && Char.compare code.[index + 1] ')' = 0 ->  (* Comment End *)
          assemble (index + 2) (nesting - 1) in_string aux
        | _ when nesting > 0 || in_string ->  (* Inside a comment or string, skip characters *)
          assemble (index + 1) nesting in_string aux
        | _ ->  (* Keep Code Same *)
          assemble (index + 1) nesting in_string (String.make 1 code.[index] :: aux)
    in
    assemble 0 0 false [] 
;;   

(*
  Given a path of an OCaml File, remove all comments and string literals.
*)
let remove_comments_and_strings (filePath : string) : string =
  let code = In_channel.read_all filePath in
  remove_stuff_from_string_helper code
;;

let is_non_character c =
  not (Char.is_alphanum c || Char.equal c '_')

(*
  Given a clean OCaml file, add to the histogram from the given keywords, the file in the form of a string
*)
let add_to_histogram (code : string) (hist : Histogram.t) : Histogram.t =
  let length = String.length code in

  let rec find_words current_char hist =
    if current_char >= length then
      hist
    else
      let char_start =
        let rec find_start index =
          if index >= length || not (is_non_character code.[index]) then
          index
          else
            find_start (index + 1)
        in
        find_start current_char
      in
      
      let char_end =
        let rec find_end index =
          if index >= length || is_non_character code.[index] then
          index
          else
            find_end (index + 1)
        in
        find_end char_start
      in

      if char_start < length && char_end > char_start then
        let clean_word = String.sub ~pos:char_start ~len:(char_end - char_start) code in
        let updated_hist =
          if List.mem words clean_word ~equal:String.equal then
            Histogram.increment hist clean_word
          else
            hist
        in
        find_words char_end updated_hist
      else
        find_words (char_end + 1) hist
  in

  find_words 0 hist
;;


