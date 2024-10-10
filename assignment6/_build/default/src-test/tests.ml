
(* open Core *)
open OUnit2

module Student_tests =
  struct
    let series =
      "Student tests" >::: []
  end

let series =
  "Assignment 6 tests" >:::
  [ Student_tests.series
  ; Ngrams_tests.series ]

let () = run_test_tt_main series