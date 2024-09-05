
(*
  -------------
  MAIN FUNCTION   
  -------------
*)

val is_towers_solution : int list list -> int list list -> bool
(** [is_towers_solution grid clues] is true if and only if the grid is well-formed and the clues are correct. *)

(*
  -------------------
  EXPOSED FOR TESTING   
  -------------------
*)

val square_size : int list list -> (int, string) result
(** [square_size grid] is Ok side_length if [grid] is square, otherwise it is Error "not square". *)

val elements_span_range : int list -> bool
(** [elements_span_range ls] is true if each of 1..n occur exactly once in [ls] where [ls] has length n. *)

val is_well_formed_grid : int list list -> bool
(** [is_well_formed_grid grid] is true if each row and col in [grid] spans range, and [grid] is square with size at least 1. *)

val number_towers_seen : int list -> int
(** [number_towers_seen row] is the number of new maxima seen when looking down the [row]. *)

val verify_left_clues : int list list -> int list -> bool
(** [verify_left_clues grid edge_clues] is true if [edge_clues] are correct from the left for each row in [grid]. *)

val reflect_across_vertical_axis : int list list -> int list list
(** [reflect_across_vertical_axis grid] is [grid] reflected across the vertical axis. *)

val transpose : int list list -> int list list
(** [transpose grid] is [grid] transposed. *)

val rotate_ccw : int list list -> int list list
(** [rotate_ccw grid] is [grid] rotated counter-clockwise. *)