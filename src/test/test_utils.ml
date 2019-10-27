open OUnit2
module P = Printf

module T = Http_types
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
    T.{
      host = "localhost";
      route = Some "/sum";
      port = Some 5000
    }
  in
  let expected = Some expected in
  let actual = U.address_of_string address in

  (* P.printf "\n%s\n" (U.string_of_address expected);
  P.printf "%s\n" (U.string_of_address actual); *)

  assert_equal actual expected



  let test_parse_two _ =
    let address = "postman-echo.com/get" in
    let expected =
      T.{
        host = "postman-echo.com";
        route = Some "/get";
        port = None
      }
    in
    let expected = Some expected in
    let actual = U.address_of_string address in

    (* P.printf "\n%s\n" (U.string_of_address expected);
    P.printf "%s\n" (U.string_of_address actual); *)

    assert_equal actual expected

let test_value_or _ =

  assert_equal 1 (C.value_or None 1);
  assert_equal 1 (C.value_or (Some (1)) 5)

let tests = "tests" >::: [
  "test_args"  >:: test_args;
  "test_parse"  >:: test_parse;
  "test_parse_two"  >:: test_parse_two;
  "test_value_or"  >:: test_value_or;
]

let _ = run_test_tt_main tests