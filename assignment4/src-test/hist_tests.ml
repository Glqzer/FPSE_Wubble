
open OUnit2

(*
  We only provide one test on histograms.
*)

let test _ =
  assert_equal
    "(((keyword hello)(count 2))((keyword world)(count 1)))"
    (Histogram.to_string
    @@ Histogram.increment_many Histogram.empty [ "hello" ; "world" ; "hello" ])

let series =
  "Hist tests" >::: [ "Hist test" >:: test ]