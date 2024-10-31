module Basic = struct
  type ('a, 's) m = 's -> 'a * 's

  let return x = fun s -> (x, s)

  let bind m ~f = fun s ->
    let (a, s') = m s in
    f a s'
end

include Fpse_monad.Make(Basic)

let read = fun s -> (s, s)
