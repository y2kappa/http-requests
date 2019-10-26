open OUnit2
open Printf
module U = Http_utils

let test_args _ =
  let args = [("",""); ("a","b"); ("c", "d"); ("", "a"); ("", ""); ("z", "")] in
  let expected = "?a=b&c=d" in
  let actual = Http_utils.args_to_string args in
  assert_equal actual expected

let test_parse _ =
  let address = "http://localhost:5000/sum" in
  let expected =
    Http_utils.{
      host = "localhost";
      route = Some "sum";
      port = Some 5000
    }
  in
  let expected = Some expected in
  let actual = U.parse_http_address address in

  printf "\n%s\n" (U.address_opt_to_string expected);
  printf "%s\n" (U.address_opt_to_string actual);

  assert_equal actual expected

let tests = "tests" >::: [
  "test_args"  >:: test_args;
  "test_parse"  >:: test_parse;
]

let _ = run_test_tt_main tests