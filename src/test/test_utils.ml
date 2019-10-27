open OUnit2
module P = Printf
module U = Http_utils
module C = Common

let test_args _ =
  let args = [("",""); ("a","b"); ("c", "d"); ("", "a"); ("", ""); ("z", "")] in
  let expected = "?a=b&c=d" in
  let actual = U.args_to_string args in
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

  (* printf "\n%s\n" (U.address_opt_to_string expected);
  printf "%s\n" (U.address_opt_to_string actual); *)

  assert_equal actual expected

let test_value_or _ =

  assert_equal 1 (C.value_or None 1);
  assert_equal 1 (C.value_or (Some (1)) 5)

let tests = "tests" >::: [
  "test_args"  >:: test_args;
  "test_parse"  >:: test_parse;
  "test_value_or"  >:: test_value_or;
]

let _ = run_test_tt_main tests