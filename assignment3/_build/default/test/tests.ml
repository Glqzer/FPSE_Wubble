
open OUnit2
module D = Simpledict
module T = Simpletree

open D.Item

module Student_tests =
  struct
    (* Disables "unused open" from dune. Delete this after you have written your tests. *)
    [@@@ocaml.warning "-33"]

    (*
      Replace these tests with your own. You must have at least ten `assert_equal` statements that are not redundant with the provided tests.
    *)

    let dict_1 = D.of_list_multi [("hello", 0); ("world", 1); ("hello", 2)]

    let sol_dict1 = T.(Branch
      { item = { key = "hello" ; value = [0; 2] }
      ; left = Leaf
      ; right = Branch { item = { key = "world" ; value = [1] } ; left = Leaf ; right = Leaf }
      }   
    )

    let dict_2 = D.of_list_multi [("a", 0); ("b", 1); ("c", 2); ("a", 1); ("b", 2); ("c", 3)]

    let sol_dict2 = T.(Branch
      { item = { key = "b" ; value = [1; 2] }
      ; left = Branch { item = { key = "a" ; value = [0; 1] } ; left = Leaf ; right = Leaf }; right = Branch { item = { key = "c" ; value = [2; 3] } ; left = Leaf ; right = Leaf }
      }   
    )

    let dict_3 = D.of_list []

    let dict_4 = D.of_list [("1", "1"); ("2", "2"); ("1", "3"); ("3", "4")]

    let dict_4_sol = T.(Branch
    { item = { key = "2" ; value = "2" }
    ; left = Branch { item = { key = "1" ; value = "3" } ; left = Leaf ; right = Leaf }; right = Branch { item = { key = "3" ; value = "4" } ; left = Leaf ; right = Leaf }
    }   
    )

    let t1 = T.(Branch
      { item = "3"
      ; left = Branch {item = "1"; left = Leaf; right = Leaf}
      ; right = Branch {item = "5"; left = Leaf; right = Leaf}})

    let t2 = T.(Branch
      { item = "1"
      ; left = Branch {item = "2"; left = Branch {item = "3"; left = Leaf; right = Leaf}; right = Leaf}
      ; right = Leaf})

    let t3 = T.(Branch
      { item = "1"
      ; left = Branch {item = "1"; left = Branch {item = "2"; left = Leaf; right = Leaf}; right = Leaf}
      ; right = Leaf})

    



    let dummy_test1 _ =
      assert_equal (T.is_ordered t1 ~compare:String.compare) true;
      assert_equal (T.is_balanced t1) true;
      assert_equal (T.is_balanced t2) false;
      assert_equal (T.is_ordered t2 ~compare:String.compare) false;
      assert_equal (T.to_list t2) ["3"; "2"; "1"];
      assert_equal (T.size t2) 3;
      assert_equal (T.height t2) 2;
      assert_equal (T.is_ordered Leaf ~compare:String.compare) true;
      assert_equal (T.is_ordered t3 ~compare:String.compare) false




    let dummy_test2 _ =
      (* testing of_list_multi*)
      assert_equal dict_1 sol_dict1;
      (* testing of_list_multi again*)
      assert_equal dict_2 sol_dict2;
      (* testing of_list empty case*)
      assert_equal dict_3 Leaf;
      (* testing of_list dupes *)
      assert_equal dict_4 dict_4_sol;
      assert_equal (D.size dict_3) 0;
      assert_equal (D.size dict_4) 3;
      assert_equal (D.lookup dict_4 ~key:"3") (Some("4"));
      assert_equal (D.lookup_exn dict_4 ~key:"3") "4"

    let series =
      "Student tests" >:::
      [ "Dummy test 1" >:: dummy_test1
      ; "Dummy test 2" >:: dummy_test2 ]
  end

let series =
  "Assignment2 Tests" >:::
  [ Student_tests.series
  ; Tree_tests.series
  ; Dict_tests.series ]

(* The following line runs all the tests put together into `series` above *)

let () = run_test_tt_main series