(*
  FPSE Assignment 5 

  Name                  : David Wang
  List of collaborators :

  See `finite_group.mli` for a lengthy explanation of this assignment. Your answers go in this file.

  We provide a little bit of code here to help you get over the syntax hurdles.

  The total amount of code here can be very short. The difficulty is in understanding modules and functors.
*)

open Core

(*
  Copy all module types from `finite_group.mli` and put them here.   
*)

(* ... module types here ... *)

module type Enumerable =
sig
  type t [@@deriving sexp, compare]
  (** [t] is any comparable, serializable type that can be enumerated. *)

  val zero : t
  (** [zero] is the first element in the enumeration.
      It is not necessarily the identity element for all groups over this set. *)

  val next : t -> t option
  (** [next t] is the next element in the enumeration, following [t].
      It is promised that there exists some [x] such that [next x] is [None].
      Otherwise, we will not be able to brute-force find an identity element with certainty. *)
end

module type Operable =
sig
  include Enumerable (* aka Operable has everything that Enumerable has, and more! *)

  val op : t -> t -> t
  (** [op x y] is some element in the enumerable set. [op] is associative, yields
      a unique identity, and yields a unique inverse for each element. *)
end

module type S =
sig
  include Operable (* S has everything Operable has, and more. *)

  val id : unit -> t
  (** [id ()] is the identity element. It is the left and right identity for any [x : t]. *)

  val inverse : t -> t
  (** [inverse x] is the left and right inverse of [x].
      i.e. all three of the following are the same:
      - [id ()]
      - [op (inverse x) x]
      - [op x (inverse x)] *)
end

module type M = functor (Op : Operable) -> S with type t = Op.t

(*
  `Make` will be an instance of such a functor. You are to implement `Make` in
  `finite_group.ml`. Because the syntax is a little bit tricky here, we provide
  the most basic syntax for you in `finite_group.ml` to help you avoid simple
  syntax errors.

  Our expectations are as follows:
  * The `id` and `inverse` functions adhere to the descriptions in `S` above.
  * You need not worry about efficiency of your functions; it is okay to
    recompute anything as much as you want.
  * There should be no startup cost. Upon using the functor, no code gets
    eagerly evaluated.
    Here are two examples to illustrate this point:
    ```
    module Make1 (T : sig type t end) : sig val g : unit -> T.t end =
      struct
        let f = failwith "fail message" (* This gets eagerly evaluated and fails when the functor is used *)
        let g () = f
      end
    module Make2 (T : sig type t end) : sig val g : unit -> T.t end =
      struct
        let g () = failwith "fail message" (* This fails only when `g` is called, not when the functor is used *)
      end
    ```
*)

(*
  Now write your functors below. There are errors for unbound module types until you put the module types above.
*)


module Make : M = functor (Op : Operable) ->
struct

  [@@@coverage off]
  (* Type stays the same *)
  type t = Op.t [@@deriving sexp, compare]
  [@@@coverage on]


  let all_elements =
    let rec collect_elements acc current =
      match Op.next current with
      | None -> acc
      | Some next_element -> collect_elements (next_element :: acc) next_element
    in
    collect_elements [Op.zero] Op.zero

  let find_identity =
    List.find_exn all_elements ~f:(fun e ->
        List.for_all all_elements ~f:(fun x ->
            Op.compare (Op.op e x) x = 0 && Op.compare (Op.op x e) x = 0
          )
      )

  (* Check this implementation of the identity *)
  let id () = find_identity

  (* Implement inverse *)
  let inverse element =
    let rec find_inverse current_element =
      if Op.compare (Op.op current_element element) (id ()) = 0 then current_element
      else 
        match Op.next current_element with
        | None -> failwith "Invalid Group"
        | Some next_element -> find_inverse next_element
    in
    find_inverse Op.zero
  let op = Op.op

  let zero = Op.zero

  let next = Op.next

end 

module Make_memoized : M = functor (Op : Operable) ->
struct

  [@@@coverage off] 
  (* Type stays the same *)
  type t = Op.t [@@deriving sexp, compare]

  (* Map Module *)
  module PairKey = struct
    type t = Op.t * Op.t [@@deriving sexp, compare]
  end

  module PairMap = Map.Make(PairKey)

  module TMap = Map.Make(struct 
      type t = Op.t [@@deriving sexp, compare]
    end)
  [@@@coverage on]

  let all_elements =
    let rec collect_elements acc current =
      match Op.next current with
      | None -> acc
      | Some next_element -> collect_elements (next_element :: acc) next_element
    in
    collect_elements [Op.zero] Op.zero

  (* Precompute the operation map *)
  let op_map = 
    List.fold_left all_elements ~init:PairMap.empty ~f:(fun acc x ->
        List.fold_left all_elements ~init:acc ~f:(fun acc y -> Map.set ~key:(x, y) ~data:(Op.op x y) acc)
      )

  let find_identity =
    List.find_exn all_elements ~f:(fun e ->
        List.for_all all_elements ~f:(fun x ->
            Op.compare (Op.op e x) x = 0 && Op.compare (Op.op x e) x = 0
          )
      )

  (* Identity element *)
  let id () = find_identity

  let find_inverse_helper (ls : t list) (x : t) =
    List.find_exn ls ~f:(fun y -> Op.compare (Op.op x y) (id ()) = 0)

  (* Precompute the inverse map *)
  let inverse_map =
    List.fold_left all_elements ~init:TMap.empty ~f:(fun acc x ->
        let inverse_x = find_inverse_helper all_elements x in
        Map.set acc ~key:x ~data:inverse_x
      )

  (* Operation function *)
  let op x y = Map.find_exn op_map (x, y)

  (* Inverse function *)
  let inverse x = Map.find_exn inverse_map x

  (* Inherited methods from Operable *)
  let zero = Op.zero
  let next = Op.next


end
