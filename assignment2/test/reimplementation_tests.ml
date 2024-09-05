
open OUnit2
open Reimplementation

(*
  These tests are simply copied from Assignment 1.
*)

let test_factors _ =
  assert_equal (factors 10) [1; 2; 5; 10];
  assert_equal (factors 12) [1; 2; 3; 4; 6; 12];
  assert_equal (factors 0) []

let test_arithmetic_progression _ =
  assert_equal (arithmetic_progression 1 3 4) [1; 4; 7; 10];
  assert_equal (arithmetic_progression (-10) (-10) 2) [-10; -20];
  assert_equal (arithmetic_progression 0 0 0) []

let test_insert_string _ =
  assert_equal (insert_string "word" ["hello"; "world"]) (Ok ["hello"; "word"; "world"]);
  assert_equal (insert_string "abc" ["world"; "hello"]) (Error "insert into unordered list")

let test_split_list _ =
  assert_equal (split_list [1; 2; 3; 4; 5] 3) ([1; 2; 3], [4; 5]);
  assert_equal (split_list [1; 2] 100) ([1; 2], [])

let series =
  "Reimplementation tests" >:::
  [ "Factors"       >:: test_factors
  ; "Arith. prog."  >:: test_arithmetic_progression
  ; "Insert string" >:: test_insert_string
  ; "Split list"    >:: test_split_list ]