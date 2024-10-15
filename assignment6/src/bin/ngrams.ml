(*
  FPSE Assignment 6

  Name                  : David Wang
  List of Collaborators : No one! Just me! I have no friends! 
*)

open Core
open Utils

(*
  Here is some simple starter code to parse the arguments.   
*)

(* Main program logic *)
let () = 
  match Sys.get_argv () |> Array.to_list with
  | _ :: n_string :: corpus_filename :: other_args -> begin
      let n = Int.of_string n_string in
      assert (Sys_unix.is_file_exn corpus_filename);
      let words = read_corpus corpus_filename in
      let sanitized_words = sanitize_sequence words in
      let non_empty_words = remove_empty_strings sanitized_words in
      let ngram_data = create_string_ngram non_empty_words n in  (* Create n-gram model *)

      match other_args with
| "--sample" :: sample_len_string :: initial_words -> 
    let sample_length = Int.of_string sample_len_string in
    let initial_words = List.map ~f:sanitize_string initial_words in

    (* Check if sample_length is valid *)
    if sample_length <= 0 then
      printf "Sample length must be a positive integer.\n"
    else
      let sampled_words = 
        if List.is_empty initial_words then 
          (* Use the last n - 1 sanitized words if initial_words is empty *)
          sample_sequence ngram_data (List.take sanitized_words (n - 1)) sample_length []
        else 
          let new_init = List.take initial_words (n - 1) in
          sample_sequence ngram_data new_init sample_length new_init
      in
      (* Join and print the sampled words *)
      printf "%s\n" (String.concat ~sep:" " (sampled_words |> List.map ~f:(fun w -> w)))

      | "--most-frequent" :: n_most_string :: _ -> 
          let n_most = Int.of_string n_most_string in
          let ngram_counts = StringNGram.count_ngrams ngram_data in
          Utils.output_most_frequent_ngrams ngram_counts n_most

      | _ -> eprintf "Invalid arguments\n"
  end
  | _ -> eprintf "Invalid arguments\n"
