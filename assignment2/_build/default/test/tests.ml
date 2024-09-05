
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

    let dummy_test1 _ =
      assert_equal 0 0

    let dummy_test2 _ =
      assert_equal 0 0

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