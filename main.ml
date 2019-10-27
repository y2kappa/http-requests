module T = Http_types
module H = Http_requester

let program () =

  (* let%lwt response = H.get
    ~address:"postman-echo.com/get"
    ~args:[("x", "10"); ("y", "3")]
  in *)

  let (>>=) = Lwt.bind in

  H.get
    ~address:"postman-echo.com/get"
    ~args:[("x", "10"); ("y", "3")] >>= fun resp ->
  print_endline (T.to_string resp);

  Lwt.return ()

let () =
  Lwt_main.run (program ())