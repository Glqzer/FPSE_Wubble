
(* open Core *)
open OUnit2

module Student_tests =
  struct
    
    (* Write your own non-redundant tests here for any part of the assignment. *)

    let test _ =
      assert_equal
        "(((keyword a)(count 2))((keyword b)(count 1)))"
        (Histogram.to_string
        @@ Histogram.increment_many Histogram.empty [ "b" ; "a" ; "a" ])
    
      let test_increment_single_key _ =
        let hist = Histogram.empty in
        let hist = Histogram.increment hist "word" in
          assert_equal (Histogram.to_pair_list hist) ([{Histogram.Pair.keyword = "word"; count = 1}])

      let test_to_pair_list _ =
        let hist = Histogram.increment_many Histogram.empty ["a"; "b"; "a"; "c"] in
        let pair_list = Histogram.to_pair_list hist in
        let expected = [{ Histogram.Pair.keyword = "a"; count = 2 }; { Histogram.Pair.keyword = "b"; count = 1 }; { Histogram.Pair.keyword = "c"; count = 1 }] in
        assert_equal pair_list expected

      let test_to_string _ =
        let hist = Histogram.increment_many Histogram.empty ["a"; "b"; "a"; "c"] in
        let hist_str = Histogram.to_string hist in
        let expected = "(((keyword a)(count 2))((keyword b)(count 1))((keyword c)(count 1)))" in
        assert_equal hist_str expected

        let test_is_valid_file _ =
          assert_equal (Utils.is_valid_file "test.ml") true;
          assert_equal (Utils.is_valid_file "test.mli") true;
          assert_equal (Utils.is_valid_file "test.txt") false;
          assert_equal (Utils.is_valid_file "test.ml.txt") false

          let test_remove_stuff_from_string_helper _ =
            let code = {|
              (* This is a comment *)
              let x = "string literal";
              let y = (* nested (comment) *) 42;
              "Another string";
              (* Multi-line
                 comment *)
              let z = 10
            |} in
          
            assert_equal (Utils.remove_stuff_from_string_helper code) "\n              \n              let x = ;\n              let y =  42;\n              ;\n              \n              let z = 10\n            "

            let test_add_to_histogram _ =
              let code = "let and while true false" in
              let hist = Histogram.empty in
              let updated_hist = Utils.add_to_histogram code hist in
            
              assert_equal (Histogram.to_string updated_hist) "(((keyword and)(count 1))((keyword false)(count 1))((keyword let)(count 1))((keyword true)(count 1))((keyword while)(count 1)))"
            ;;

      


    

    let series =
      "Student tests" >:::
      [ "Basic Test" >:: test;
      "Increment Single Key"   >:: test_increment_single_key
      ; "To Pair List" >:: test_to_pair_list
      ; "To String"  >:: test_to_string
      ; "Valid File" >:: test_is_valid_file
      ; "Remove Stuff" >:: test_remove_stuff_from_string_helper
      ; "Add to Histogram" >:: test_add_to_histogram ]

  end

let series =
  "Assignment 4 tests" >:::
  [ Student_tests.series
  ; Hist_tests.series
  ; Exec_tests.series ]

let () = run_test_tt_main series