
val is_prime : int -> bool
(** [is_prime n] is true if positive integer [n] is a prime number. *)

val prime_factors : int -> int list
(** [prime_factors n] is a sorted list of all prime factors of positive integer [n], without multiplicity. *)

val prime_factor_with_greatest_multiplicity : int -> int
(** [prime_factor_with_greatest_multplicity n] is the prime factor of [n], (where [n] is at least 2), with
    the greatest multplicity. If two prime factors have the same multplicity, then this returns the greater factor. *)