module Basic = struct
  type ('a, 'b) m = ('a, 'b list) State_monad.m

  let return = State_monad.return
  let bind = State_monad.bind
end

include Fpse_monad.Make(Basic)

let push x = 
  State_monad.bind State_monad.read ~f:(fun stack ->
    State_monad.return () (x :: stack)
  )

let pop =
  State_monad.bind State_monad.read ~f:(fun stack ->
    match stack with
    | [] -> failwith "Stack is empty"  (* You may want a safer option for handling this error *)
    | x :: xs -> State_monad.return x xs
  )

let is_empty =
  State_monad.bind State_monad.read ~f:(fun stack ->
    State_monad.return (stack = [])
  )

let run m =
  let (result, _) = m [] in
  result
