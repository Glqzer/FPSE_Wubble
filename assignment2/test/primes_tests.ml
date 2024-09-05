
open OUnit2
open Primes

let test_is_prime _ =
  assert_equal (is_prime 2) true;
  assert_equal (is_prime 15) false;
  assert_equal (is_prime (Core.Int.pow 2 31 - 1)) true

let test_prime_factors _ =
  assert_equal (prime_factors 1) [];
  assert_equal (prime_factors 12) [2; 3]

let test_prime_factor_with_greatest_multiplicity _ =
  assert_equal (prime_factor_with_greatest_multiplicity 4) 2;
  assert_equal (prime_factor_with_greatest_multiplicity 120) 2;
  assert_equal (prime_factor_with_greatest_multiplicity 5) 5;
  assert_equal (prime_factor_with_greatest_multiplicity 252) 3

let series =
  "Primes tests" >:::
  [ "Is Prime" >:: test_is_prime
  ; "Prime factors" >:: test_prime_factors
  ; "Prime Factor with Greatest Multiplicity" >:: test_prime_factor_with_greatest_multiplicity ]