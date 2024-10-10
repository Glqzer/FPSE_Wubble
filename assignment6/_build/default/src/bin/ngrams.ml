(*
  FPSE Assignment 6

  Name                  : 
  List of Collaborators :
*)

open Core

(*
  Here is some simple starter code to parse the arguments.   
*)

let () = 
  match Sys.get_argv () |> Array.to_list with
  | _ :: n_string :: corpus_filename :: other_args -> begin
    let n = Int.of_string n_string in
    assert (Sys_unix.is_file_exn corpus_filename);
    match other_args with
    | "--sample" :: sample_len :: initial_words -> failwith "unimplemented: --sample"
    | "--most-frequent" :: n_most :: _ -> failwith "unimplemented: --most-frequent"
    | _ -> eprintf "Invalid arguments\n"
  end
  | _ -> eprintf "Invalid arguments\n"
