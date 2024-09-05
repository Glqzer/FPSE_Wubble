(*
  FPSE Assignment 2

  Name                  :
  List of Collaborators :

  Please make a good faith effort at listing people you discussed any problems with here, as per the course academic integrity policy.  CAs/Prof need not be listed!

	------------
	INSTRUCTIONS
	------------

  For selected functions in Assignment 1, provide a reimplementation of your previous code by refactoring the definition to use combinators provided by the List module.

  Care should be taken to use a concise, elegant combination of these provided functions to best express the task.

  These new implementations should be not explicitly recursive. Note that the autograder is not aware if you cheated and used `rec`; we will manually inspect your code and give you negative points if you used recursion.

	Define any auxiliary functions you like, but you must not use the `rec` keyword anywhere.

  You must not use any mutation operations of OCaml in this assignment.
*)

open Core

(* Disables "unused variable" warning from dune while you're still solving these! *)
[@@@ocaml.warning "-27"]

let unimplemented () =
  failwith "unimplemented"

(*
	Refer to Assignment 1 for the expected behavior of these functions.	 
*)

let factors (n : int) : int list =
  unimplemented ()

let arithmetic_progression (n : int) (d : int) (k : int) : int list =
  unimplemented ()

let insert_string (s : string) (ls : string list) : (string list, string) result =
	unimplemented ()

let split_list (ls : 'a list) (n : int) : 'a list * 'a list =
  unimplemented ()
