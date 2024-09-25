(*
  FPSE Assignment 4

  Name                  : 
  List of Collaborators :

  See `histogram.mli` for the requirements. Your answers go in this file.
*)

open Core

(* This is to silence the warning for unused variables until everything here is implemented. *)
[@@@ocaml.warning "-27"]

module Pair =
  struct
    type t =
      { keyword : string
      ; count   : int } [@@deriving sexp]

    let compare (a : t) (b : t) : int =
      String.compare a.keyword b.keyword
  end

(*
  Here we use a functor. `String_map` is a module for mapping strings to values. You will make a functor in the next assignment. Here you can just take for granted that this works.

  Check the module signatures for `Map` and `String_map`. Some useful functions will be inside `String_map`, and some will be inside `Map`.
*)
module String_map = Map.Make (String)

type t = int String_map.t [@@deriving compare]

let empty : t = String_map.empty

let increment (hist : t) (key : string) : t =
  Map.update hist key ~f:(function
      | None -> 1
      | Some count -> count + 1)
;;

let increment_many (hist : t) (keys : string list) : t =
  List.fold keys ~init:hist ~f:(fun aux key ->
    increment aux key
  )
;;

let to_pair_list (hist : t) : Pair.t list =
  let to_alist = Map.to_alist hist in
  let pairs = List.map to_alist ~f:(fun (k, v) -> { Pair.keyword = k; count = v }) in
  List.stable_sort pairs ~compare:(fun a b ->
    let cmp = Int.compare b.count a.count in
    if cmp <> 0 then cmp
    else String.compare a.keyword b.keyword
  )
;;

let of_pair_list (ls : Pair.t list) : t =
  List.fold ls ~init:empty ~f:(fun aux { Pair.keyword; count } ->
    Map.set aux ~key:keyword ~data:count
  )
;;

let to_string (hist : t) : string =
  let pairs = to_pair_list hist in
  let sexp_list = List.map pairs ~f:(fun { Pair.keyword; count } ->
    Printf.sprintf "((keyword %s)(count %d))" keyword count
  ) in
  Printf.sprintf "(%s)" (String.concat sexp_list)
;;

(*
  We implement this for you to help you avoid simple autograder failures. However, the inverse, `t_of_sexp` is still up to you.
*)
let sexp_of_t (hist : t) : Sexp.t =
  hist 
  |> to_pair_list
  |> List.sexp_of_t Pair.sexp_of_t
;;

let t_of_sexp (sexp : Sexp.t) : t =
  let pairs = List.t_of_sexp Pair.t_of_sexp sexp in
  of_pair_list pairs
;;