(*
  FPSE Assignment 2

  Name                  :
  List of Collaborators :

  Please make a good faith effort at listing people you discussed any problems with here, as per the course academic integrity policy.  CAs/Prof need not be listed!

  ------------
  INSTRUCTIONS
  ------------

  In this part of the assignment, you implement a few functions about prime numbers. Provide implementations that meet the descriptions.

  You must not use any mutation operations of OCaml in this assignment. You may define any auxiliary functions you like, and you may add `rec` to any function.
*)

open Core

(* Disables "unused variable" warning from dune while you're still solving these! *)
[@@@ocaml.warning "-27"]

let unimplemented () =
  failwith "unimplemented"

(* 
  Check if positive integer `n` is prime. This should be able to quickly handle numbers up to 2^32.
*)
let is_prime (n : int) : bool =
  unimplemented ()

(*
  Given a positive integer `n`, produce the sorted list of all prime factors of `n` without multiplicity.

  See the provided tests for exact expected behavior.

  e.g.

    # prime_factors 1
    - : int list = []
    # prime_factors 12
    - : int list = [2; 3]
*)
let prime_factors (n : int) : int list =
  unimplemented ()

(* 
  Given integer `n` greater than 1, return the prime factor of `n` that has the greatest multiplicity.

  If two prime factors have the same multiplicity, return the largest factor.

  See the provided tests for exact expected behavior.

  e.g.

    # prime_factor_with_greatest_multiplicity 120
    - : int = 2
*)
let prime_factor_with_greatest_multiplicity (n : int) : int =
  unimplemented ()