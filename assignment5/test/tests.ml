(*
  You will need to create and run your own tests. Tests should cover both common
  cases and edge cases. In previous assignments, we asked for a specified number
  of additional tests, but in this assignment we will be grading based on code
  coverage.
 
  Aim for complete code coverage on all functions. We will check coverage by
  running the bisect tool on your code. For that reason, you need to add the
  following line in the dune file for your library:
      
      (preprocess (pps bisect_ppx))
 
  or else your tests will not run in the autograder.

 Additionally, you will need to write a special suite of tests here which
 verifies some specifications. See the `Readme` for details.
*)

open Core
open OUnit2

(*
  We give you one working `Operable` module and two `assert_equal`s with it. You'll likely
  need to write more modules to get good coverage.
*)

module Given_tests =
  struct
    module Op1 : Finite_group.Operable with type t = int = struct
        type t = int [@@deriving sexp, compare] 
        let zero = 0
        let next x = if x = 4 then None else Some (x + 1)
        let op x y = (x + y) mod 5
      end

    let op1_tests _ =
      let module G = Finite_group.Make (Op1) in
      assert_equal 0 (G.id ());
      assert_equal 2 (G.inverse 3)

    let series = 
      "Given tests" >::: [ "op1 tests" >:: op1_tests ]
  end

  

  module Student_tests = struct

    module IntMod : Finite_group.Operable with type t = int = struct
      type t = int [@@deriving sexp, compare]
  
      let zero = 0
  
      let next x = 
        if x < 4 then Some (x + 1) else None  (* Limit to 0, 1, 2, 3, 4 *)
  
      let op x y = (x + y) mod 5  (* Change operation to modulo 5 *)
    end
  
    (* Define tests for both regular and memoized groups *)
    let tests _ = 
      let module Group = Finite_group.Make(IntMod) in      
      let module MemoizedGroup = Finite_group.Make_memoized(IntMod) in
  
      (* Regular Group Tests *)
      assert_equal (Group.op (Group.id ()) 2) 2;
      assert_equal (Group.op 2 (Group.id ())) 2;
  
      let id = Group.id () in
      assert_equal (Group.op (Group.inverse 2) 2) id;
      assert_equal (Group.op 2 (Group.inverse 2)) id;
  
      let a, b, c = 1, 3, 2 in
      assert_equal (Group.op a (Group.op b c)) (Group.op (Group.op a b) c);
  
      (* Memoized Group Tests *)
      assert_equal (MemoizedGroup.op (MemoizedGroup.id ()) 2) 2;
      assert_equal (MemoizedGroup.op 2 (MemoizedGroup.id ())) 2;
  
      let memoized_id = MemoizedGroup.id () in
      assert_equal (MemoizedGroup.op (MemoizedGroup.inverse 2) 2) memoized_id;
      assert_equal (MemoizedGroup.op 2 (MemoizedGroup.inverse 2)) memoized_id;
  
      assert_equal (MemoizedGroup.op a (MemoizedGroup.op b c)) (MemoizedGroup.op (MemoizedGroup.op a b) c);
    ;;
  
    let series =
      "Student tests" >::: ["student tests" >:: tests]
  
  end

module Specification_tests =
  struct
    (* ... your specification tests here (see the Readme) ... *)

    let series =
      "Specification tests" >::: []
  end

let series =
  "Finite group tests" >:::
  [ Given_tests.series
  ; Student_tests.series
  ; Specification_tests.series
  ]

let () = run_test_tt_main series