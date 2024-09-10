(*
  FPSE Assignment 2

  Name                  : David Wang
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

(* 
  Check if positive integer `n` is prime. This should be able to quickly handle numbers up to 2^32.
*)
let is_prime (n : int) : bool = 
  let rec check_num m = 
    if m * m > n then true
    else (n mod m <> 0 && check_num (m + 1)) in
  n >= 2 && check_num 2

let rec remove_dupes (n : int list) (aux : int list) : int list = 
  match n, aux with 
  | [], _ -> aux
  | x :: xs, a :: axs -> if x = a then remove_dupes xs aux else remove_dupes xs (x :: aux)
  | x :: xs, [] -> remove_dupes xs (x :: aux)


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
  let rec aux d n acc =
    if n = 1 || n = 0 then acc
    else if n mod d = 0 then aux d (n / d) (d :: acc)
    else aux (d + 1) n acc
  in remove_dupes (aux 2 n []) []

(* 
  Count how many times prime p divides n
*)
let rec multiplicity n p =
  if n mod p = 0 then 1 + multiplicity (n / p) p else 0

(* 
  Given integer `n` greater than 1, return the prime factor of `n` that has the greatest multiplicity.

  If two prime factors have the same multiplicity, return the largest factor.

  See the provided tests for exact expected behavior.

  e.g.

    # prime_factor_with_greatest_multiplicity 120
    - : int = 2
*)
let prime_factor_with_greatest_multiplicity (n : int) : int =
  let pf = prime_factors n in
  let rec highest_multiplicity ls record count = match ls with 
    | [] -> record
    | x :: xs -> 
      if multiplicity n x >= count then highest_multiplicity xs x (multiplicity n x) 
      else highest_multiplicity xs record count in
  highest_multiplicity pf 0 0

