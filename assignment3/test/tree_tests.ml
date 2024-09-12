
open Core
open OUnit2

(* This is an alias to shorten the name *)
module T = Simpletree

let t1 = T.(Branch
  { item = "d"
  ; left = Branch {item = "a"; left = Leaf; right = Leaf}
  ; right = Branch {item = "e"; left = Leaf; right = Leaf}})

let test_tree_size _ =
  assert_equal 0 @@ T.size T.Leaf;
  assert_equal 3 @@ T.size t1

let test_tree_height _ =
  assert_equal 1 @@ T.height t1

let test_tree_is_balanced _ =
  assert_equal true @@ T.is_balanced t1

let test_tree_to_list _ =
  assert_equal [] @@ T.to_list T.Leaf;
  assert_equal ["a";"d";"e"] @@ T.to_list t1

let series =
  "Tree tests" >:::
  [ "size"        >:: test_tree_size
  ; "height"      >:: test_tree_height
  ; "is_balanced" >:: test_tree_is_balanced
  ; "to_list"     >:: test_tree_to_list ]

(*
  Notice that `is_ordered` is not tested in this file.
*)