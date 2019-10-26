open OUnit2

let test_one _ =
  let args = [("",""); ("a","b"); ("c", "d"); ("", "a"); ("", ""); ("z", "")] in
  let expected = "?a=b&c=d" in
  let actual = Http_utils.args_to_string args in
  assert_equal actual expected

let tests = "tests" >::: [
  "test_one"  >:: test_one;
]

let _ = run_test_tt_main tests