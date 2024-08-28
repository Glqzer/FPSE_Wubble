(*
  FPSE Assignment 1

  Name                  :
  List of Collaborators :

  Please make a good faith effort at listing people you discussed any problems with here, as per the course academic integrity policy.  CAs/Prof need not be listed!

  Note that it is strictly illegal to look for direct answers to these questions using search or AI tools.  For example asking ChatGPT "how do I implement a least common multiple function in OCaml" is illegal.

  Fill in the function definitions below by replacing the 

    unimplemented ()

  with your code. You may add `rec` to any function to make it recursive. You may define any auxillary functions you'd like.

  You must not use any mutation operations of OCaml in this assignment (which we have not taught yet in any case): no arrays, for- or while-loops, references, etc. Also, you may not use the `List` module functions in this assignment, but you may use other standard libraries. In the next assignment, we will start using `List`.

*)

(* Disables "unused variable" warning from dune while you're still solving these! *)
[@@@ocaml.warning "-27"]

(*
  You are required to use core in this class. Don't remove the following line.  If the editor is not recognizing Core (red squiggle under it for example), run a "dune build" from the shell -- the first time you build it will create some .merlin files which tells the editor where the libraries are.
*)
open Core

(*
  Here is a simple function which gets passed unit, (), as argument and raises an exception. It is the initial implementation of all functions below.
*)
let unimplemented () =
	failwith "unimplemented"

(*
	All functions must be total for the specified domain;	overflow is excluded from this restriction but should be avoided.
*)

(*
  Given a non-negative integer `n`, compute `0+1+2+ ... +n` using recursion (don't use the closed-form solution, do the actual addition).
*)
let summate (n: int) : int =
  unimplemented ()

(*
  Given non-negative integers `n` and `m`, compute their least common multiple.
*)
let lcm (n: int) (m: int) : int =
  unimplemented ()	

(*
  Given a non-negative integer `n`, compute the n-th fibonacci number.	Give an implementation that does not take exponential time; the naive version from lecture is exponential	since it has two recursive calls for each call.
*)
let fibonacci (n: int) : int =
  unimplemented ()

(*
  Given non-negative integers `a` and `b`, where `a` is not greater than `b`, produce a list [a; a+1; ...; b-1].
*)
let range (a : int) (b : int) : int list =
  unimplemented ()

(*
  Given non-negative integers `n`, `d`, and `k`, produce the arithmetic progression [n; n + d; n + 2d; ...; n + (k-1)d].
*)
let arithmetic_progression (n : int) (d : int) (k : int) : int list =
  unimplemented ()

(*
  Given a positive integer `n`, produce the list of integers in the range (0, n] which it is divisible by, in ascending order.
*)
let factors (n: int) : int list =
  unimplemented ()

(* 
  Reverse a list. Your solution must be in O(n) time. Note: the solution in lecture is O(n^2).
*)
let reverse (ls : 'a list) : 'a list =
  unimplemented ()

(*
  Given a list of strings, check to see if it is ordered, i.e. whether earlier elements are less than or equal to later elements.
*)
let is_ordered (ls: string list) : bool =
  unimplemented ()

(*
  Given a string and a list of strings, insert the string into the list so that if the list was originally ordered, then it remains ordered. Return as a result the list with the string inserted.

  If the list is not ordered, then return `Error "insert into unordered list"`.

	Note this is an example of a *functional data structure*, instead of mutating	you return a fresh copy with the element added.
*)
let insert_string (s: string) (ls: string list) : (string list, string) result =
	unimplemented ()

(*
	Define a function to sort a list of strings by a functional version of the insertion sort method: repeatedly invoke insert_string to add elements one by one to an initially empty list.

	The sorted list should be sorted from smallest to largest string lexicographically.
*)
let insertion_sort (ls: string list) : string list =
	unimplemented ()

  
(* 
  Split a list `ls` into two pieces, the first of which is the first `n` elements of `ls`,
  and the second is all remaining elements.
  e.g. split_list [1;2;3;4;5] 3 evaluates to ([1;2;3], [4;5])	 
  Note that this function returns a tuple. Here is an example of a tuple.
  ```
  let f x = (x, 10)
  ```
  Assume `n` is non-negative and at most the length of the list.
*)
let split_list (ls : 'a list) (n : int) : 'a list * 'a list =
  unimplemented ()

(* 
  Sort an int list using merge sort. Your solution must have time complexity O(n log n). Note that time complexity may depend on your implementation of `split_list`.
*)
let merge_sort (ls : int list) = 
  unimplemented ()