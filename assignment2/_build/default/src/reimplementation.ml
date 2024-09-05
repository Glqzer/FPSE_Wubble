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

(*
let unimplemented () =
  failwith "unimplemented"
*)

(*
	Refer to Assignment 1 for the expected behavior of these functions.	 
*)

(*
  Given a positive integer `n`, produce the list of integers in the range (0, n] which it is divisible by, in ascending order.
*)
let factors (n : int) : int list = match n with
 | 0 -> []
 | x -> List.init x ~f:(fun i -> i + 1) |> List.filter ~f:(fun m -> n mod m = 0);;

(*
  Given non-negative integers `n`, `d`, and `k`, produce the arithmetic progression [n; n + d; n + 2d; ...; n + (k-1)d].
*)
let arithmetic_progression (n : int) (d : int) (k : int) : int list =
  List.init k ~f:(fun k -> n + (k * d));;

(* Function to compare two strings *)
let compare_strings s1 s2 =
  String.compare s1 s2;;

(*
  Given a string and a list of strings, insert the string into the list so that if the list was originally ordered, then it remains ordered. Return as a result the list with the string inserted.

  If the list is not ordered, then return `Error "insert into unordered list"`.

	Note this is an example of a *functional data structure*, instead of mutating	you return a fresh copy with the element added.
*)
let insert_string (s : string) (ls : string list) : (string list, string) result =
  if List.is_sorted ls ~compare:compare_strings then
	  let smaller, greater = 
      List.partition_tf ls ~f:(fun str -> String.(str < s)) in
    Ok(smaller @ s :: greater)
  else Error("insert into unordered list")

(* 
  Split a list `ls` into two pieces, the first of which is the first `n` elements of `ls`,
  and the second is all remaining elements.
  e.g. split_list [1;2;3;4;5] 3 evaluates to ([1;2;3], [4;5])	
*)
let split_list (ls : 'a list) (n : int) : 'a list * 'a list =
  List.split_n ls n;;
