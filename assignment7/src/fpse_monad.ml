(* fpse_monad.ml *)

(* Define the Basic module type *)
module type Basic = sig
  type ('a, 'b) m

  val bind : ('a, 'b) m -> f:('a -> ('c, 'b) m) -> ('c, 'b) m
  val return : 'a -> ('a, 'b) m
end

(* Define the S module type *)
module type S = sig
  include Basic

  val map : ('a, 'b) m -> f:('a -> 'c) -> ('c, 'b) m
  val compose : ('a -> ('b, 'c) m) -> ('b -> ('d, 'c) m) -> 'a -> ('d, 'c) m
  val (>>=) : ('a, 'b) m -> ('a -> ('c, 'b) m) -> ('c, 'b) m
  val (>>|) : ('a, 'b) m -> ('a -> 'c) -> ('c, 'b) m
  val (>=>) : ('a -> ('b, 'c) m) -> ('b -> ('d, 'c) m) -> 'a -> ('d, 'c) m
  val join : (('a, 'b) m, 'b) m -> ('a, 'b) m

  module Let_syntax : sig
    val bind : ('a, 'b) m -> f:('a -> ('c, 'b) m) -> ('c, 'b) m
    val map : ('a, 'b) m -> f:('a -> 'c) -> ('c, 'b) m
  end
end

(* Define the M functor type *)
module type M = functor (X : Basic) -> S with type ('a, 'b) m = ('a, 'b) X.m

(* Define the Make functor *)
module Make (X : Basic) : S with type ('a, 'b) m = ('a, 'b) X.m = struct
  type ('a, 'b) m = ('a, 'b) X.m

  let return = X.return

  let bind m ~f = X.bind m ~f

  let map m ~f = bind m ~f:(fun a -> return (f a))

  let compose f g x = bind (f x) ~f:g

  let (>>=) m f = bind m ~f

  let (>>|) m f = map m ~f

  let (>=>) f g x = compose f g x

  let join m = bind m ~f:(fun x -> x)

  module Let_syntax = struct
    let bind = bind
    let map = map
  end
end
