
module P = Printf
module U = Http_utils
module T = Http_types
module C = Common
module H = Http_requester

(*
  Inspiration from https://github.com/ocsigen/lwt
  TODO:
  - split response into headers & body
  - make it json
*)

let program () =
(* curl --location --request GET "https://postman-echo.com/get?foo1=bar1&foo2=bar2" *)
  let%lwt response = H.get
    ~address:"postman-echo.com/get"
    ~args:[("x", "10"); ("y", "3")]
  in

  print_endline (T.to_string response);
  Lwt.return ()

let () =
  Lwt_main.run (program ())