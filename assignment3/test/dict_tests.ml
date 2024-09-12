
open Core
open OUnit2

(* These are aliases to shorten the names *)
module D = Simpledict
module T = Simpletree

open D.Item

let d1 = 
  let open T in
  Branch
  { item = {key="d"; value=0}
  ; left = Branch {item = {key="a"; value=1}; left = Leaf; right = Leaf}
  ; right = Branch {item = {key="e"; value=2}; left = Leaf; right = Leaf}}

let test_to_list _ =
  assert_equal [("a", 1); ("d", 0); ("e", 2)] @@ D.to_list d1

let test_insert _ =
  assert_equal T.(Branch {item={key="5";value=5}; left=Leaf; right=Leaf}) @@ D.insert T.Leaf ~key:"5" ~value:5

(* `test_insert_many` requires working `is_balanced` *)
let test_insert_many _ =
  let keys = [ "a" ; "b" ; "c" ; "d" ; "e" ; "f" ; "g" ; "h" ; "d" ; "c" ; "g" ; "i" ] in
  let items () = List.map keys ~f:(fun key -> { key ; value = Random.int 1000 }) in
  Fn.apply_n_times ~n:10 (* run this test 10 times with different random values each time *)
    (fun () ->
      ()
      |> items
      |> List.fold ~init:D.empty ~f:(fun acc { key ; value } -> D.insert acc ~key ~value)
      |> fun tree ->
        assert_equal true (T.is_balanced tree && D.size tree = 9) (* check that the tree is balanced with 9 unique keys inserted *)
    ) ()

(* `test_update` requires working `lookup_exn` *)
let test_update _ =
  let d = D.update d1 ~key:"a" ~f:(fun _ x -> x + 10) in
  assert_equal 11 @@ D.lookup_exn d ~key:"a";
  assert_equal 2 @@ D.lookup_exn d ~key:"e"

let example_dict1 = T.(Branch
  { item = { key = "8" ; value = 3 }
  ; left = Branch { item = { key = "1" ; value = 5 } ; left = Leaf ; right = Leaf }
  ; right = Branch { item = { key = "9" ; value = 1 } ; left = Leaf ; right = Leaf }
  }
)

let example_dict2 = T.(Branch
  { item = {key = "8"; value = 13}
  ; left = Branch
    { item = {key = "1"; value = 2}
    ; left = Leaf
    ; right = Leaf }
   ; right = Branch
    { item = {key = "99"; value = 2}
    ; left = Leaf
    ; right = Leaf }
  }
)

let merge_fun l r =
  match l, r with 
  | None, None -> failwith "should not get here!"
  | Some _, None -> 0
  | None, Some _ -> 1
  | Some a, Some b -> a * b

(* `test_merge_with` requires working `to_list` and `is_balanced` *)
let test_merge_with _ =
  let result_d = 
    D.(merge_with ~merger:merge_fun example_dict1 example_dict2)
  in
  assert_equal
    [("1", 10); ("8", 39); ("9", 0); ("99", 1)]
    (D.to_list result_d);
  assert_equal true (T.is_balanced result_d) (* check that the merged dict is balanced still *)

let series =
  "Dict tests" >:::
  [ "to_list"     >:: test_to_list
  ; "insert"      >:: test_insert
  ; "insert_many" >:: test_insert_many
  ; "update"      >:: test_update
  ; "merge_with"  >:: test_merge_with ]

(*
  Notice that the following are not tested in this file:
  * size
  * lookup
  * lookup_exn
  * map
  * of_list
  * of_list_multi
*)

