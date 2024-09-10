
open OUnit2

module Student_tests =
  struct
    (* Disables "unused open" from dune. Delete this after you have written your tests. *)
    [@@@ocaml.warning "-33"]

    open Reimplementation 
    open Primes
    open Towers

    (*
      Replace these tests with your own. You must have at least five `assert_equal` statements that are not redundant with the provided tests.
    *)

    let tower_board_example_3x3 = 
      [ [ 1; 2; 3 ]; 
        [ 3; 1; 2 ]; 
        [ 2; 3; 1 ] ]

    let dummy_test1 _ =
      assert_equal (prime_factor_with_greatest_multiplicity 488) 2;
      assert_equal (prime_factor_with_greatest_multiplicity 1470) 7;
      assert_equal (prime_factor_with_greatest_multiplicity 2366) 13;
      assert_equal (prime_factor_with_greatest_multiplicity 2601) 17;
      assert_equal (prime_factors 0) [];
      assert_equal (prime_factors 2310) [2; 3; 5; 7; 11];
      assert_equal (prime_factors 8388608) [2]

    let dummy_test2 _ =
      assert_equal (factors 1) [1];
      assert_equal (factors 24) [1; 2; 3; 4; 6; 8; 12; 24];
      assert_equal (arithmetic_progression 1 1 1) [1];
      assert_equal (insert_string "a" ["d"; "c"]) (Error "insert into unordered list");
      assert_equal (insert_string "d" ["a"; "b"; "c"]) (Ok ["a"; "b"; "c"; "d"]);
      assert_equal (split_list ["a"; "b"; "c"] 1) (["a"], ["b"; "c"]);
      assert_equal (tower_board_example_3x3 |> reflect_across_vertical_axis |> reflect_across_vertical_axis)
      tower_board_example_3x3

    let series =
      "Student tests" >:::
      [ "Dummy test 1" >:: dummy_test1
      ; "Dummy test 2" >:: dummy_test2 ]
  end

let series =
  "Assignment2 Tests" >:::
  [ Student_tests.series
  ; Reimplementation_tests.series
  ; Primes_tests.series
  ; Towers_tests.series ]

(* The following line runs all the tests put together into `series` above *)

let () = run_test_tt_main series