
open OUnit2
open Towers

let tower_board_example_2x2 =
  [ [ 1; 2 ]; 
    [ 2; 1 ] ]

let tower_board_ill_formed_example_2x2 =
  [ [ 1; 2 ]; 
    [ 2; 2 ] ]

let tower_board_not_square_example = 
  [ [ 1; 2; 3 ]; 
    [ 2; 1 ] ]

let tower_board_example_3x3 = 
  [ [ 1; 2; 3 ]; 
    [ 3; 1; 2 ]; 
    [ 2; 3; 1 ] ]

let tower_board_example_transposed_3x3 =
  [ [ 1; 3; 2 ];
    [ 2; 1; 3 ];
    [ 3; 2; 1 ] ]

let tower_board_example_reflected_3x3 = 
  [ [ 3; 2; 1 ];
    [ 2; 1; 3 ];
    [ 1; 3; 2 ] ]

let tower_board_ill_formed_3x3 =
  [ [ 1; 2; 3];
    [ 3; 2; 1];
    [ 2; 3; 1] ]

let test_square_size _ = 
  assert_equal (square_size tower_board_example_2x2) (Ok 2);
  assert_equal (square_size tower_board_example_3x3) (Ok 3);
  assert_equal (square_size tower_board_not_square_example) (Error "not square")
  
let test_elements_span_range _ = 
  assert_equal (elements_span_range [3;2;1]) true;
  assert_equal (elements_span_range [3;2;2]) false;
  assert_equal (elements_span_range [1;7;3;4;5;6;7]) false
 
let test_well_formed_grid _ =
  assert_equal (is_well_formed_grid tower_board_example_2x2) true;
  assert_equal (is_well_formed_grid tower_board_ill_formed_example_2x2) false;
  assert_equal (is_well_formed_grid tower_board_ill_formed_3x3) false
  
let test_number_towers_seen _ =
  assert_equal (number_towers_seen [1;2;3]) 3;
  assert_equal (number_towers_seen [3;2;1]) 1;
  assert_equal (number_towers_seen [1;3;2;5;4]) 3
 
let test_verify_left_clues _ =
  assert_equal (verify_left_clues tower_board_example_2x2 [ 2; 1 ]) true;
  assert_equal (verify_left_clues tower_board_example_3x3 [ 3; 1; 2]) true;
  assert_equal (verify_left_clues tower_board_example_3x3 [ 2; 1; 2]) false

let test_transpose _ =
  assert_equal (transpose tower_board_example_2x2) tower_board_example_2x2;
  assert_equal (transpose tower_board_example_3x3) tower_board_example_transposed_3x3
 
let test_reflect_across_vertical_axis _ =
  assert_equal (reflect_across_vertical_axis tower_board_example_2x2)
    [[2; 1]; 
     [1; 2]];
  assert_equal (reflect_across_vertical_axis tower_board_example_3x3) tower_board_example_reflected_3x3

(* A useful invariant: four rotations is a no-op *)
let test_rotate_ccw _ =
  assert_equal
    (tower_board_example_2x2 |> rotate_ccw |> rotate_ccw |> rotate_ccw |> rotate_ccw)
    tower_board_example_2x2;
  assert_equal (rotate_ccw tower_board_example_3x3) [ [ 3; 2; 1 ]; [ 2; 1; 3 ]; [ 1; 3; 2 ] ]

let valid_counts_example_2x2 = [ [ 2; 1 ]; [ 1; 2 ]; [ 2; 1 ]; [ 1; 2 ] ]

(* Here is the "picture" of these counts on the 2x2 example above:

    2  1  
2   1  2  1 
1   2  1  2
    1  2

    - read succesive lists of counts by rotating the whole thing ccw 90.
*)   
let valid_counts_example_3x3 = [ [ 3; 1; 2 ]; [ 1; 2; 2 ]; [ 2; 2; 1 ]; [ 2; 1; 3 ] ]
let invalid_counts_example_2x2 = [ [ 1; 2 ]; [ 2; 1 ]; [ 1; 2 ]; [ 2; 1 ] ]

let test_is_towers_solution _ =
  assert_equal
    (is_towers_solution tower_board_example_2x2 valid_counts_example_2x2)
    true;
  assert_equal
    (is_towers_solution tower_board_example_3x3 valid_counts_example_3x3)
    true;
  assert_equal
    (is_towers_solution tower_board_example_2x2 invalid_counts_example_2x2)
    false

let series =
  "Towers tests" >:::
  [ "Square size"         >:: test_square_size
  ; "Elements_span_range" >:: test_elements_span_range
  ; "Well_formed_grid"    >:: test_well_formed_grid
  ; "Number towers seen"  >:: test_number_towers_seen
  ; "Verify left clues"   >:: test_verify_left_clues
  ; "Reflect"             >:: test_reflect_across_vertical_axis
  ; "Rotate"              >:: test_rotate_ccw
  ; "Is towers solution"  >:: test_is_towers_solution ]
