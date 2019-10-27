
module P = Printf
module U = Http_utils

(*
  Inspiration from https://github.com/ocsigen/lwt
*)

let value_or option_ or_ =
  match option_ with
  | Some value -> value
  | None -> or_

let address_to_socket ~host ~port =

  (*
  TODO:
  - implement async operator like: let%async res = expr in
  - implement await operator like: let res = await @@ expr in
  *)

  let%lwt addresses = Lwt_unix.getaddrinfo host (string_of_int port) [] in
  let address = List.hd addresses in
  let address = address.ai_addr in

  (* Debug printing *)
  let address_str = match address with
    | ADDR_UNIX (address) -> address
    | ADDR_INET (inetaddr, port) ->
      P.sprintf "%s:%d"
      (Unix.string_of_inet_addr inetaddr) port
  in

  P.printf "[DEBUG] Resolved to: %s \n" address_str;
  Lwt.return address


type response =
  | Response of string
  | Timeout of float
  | Error
  [@@deriving show]

let (>>=) option_ continuation_ =
  match option_ with
  | Some x -> continuation_ x
  | None -> Lwt.return Error


let build_headers args (target:U.address) =
  let str_args = U.args_to_string args in
  let route = value_or target.route "/" in
  [
    "GET " ^ route ^ str_args ^ " HTTP/1.1";
    "Host: " ^ target.host;
    "User-Agent: curl/7.49.0";
    "X-Forwarded-Port: 443";
    "X-Forwarded-Proto: https";
    "Accept: */*";
    "Connection: close\r\n\r\n";
  ]
  |> String.concat "\r\n"


let get ~address ~args =

  U.parse_http_address address >>= fun target ->
  let port = value_or target.port 80 in
  let%lwt socket = address_to_socket ~host:target.host ~port in
  let headers = build_headers args target in

  let request = Lwt_io.(with_connection socket (fun (incoming, outgoing) ->
    let%lwt () = write outgoing headers in
    let%lwt response = read incoming in
    Lwt.return (Response response)))
  in

  let timeout =
    let%lwt () = Lwt_unix.sleep 5. in
    Lwt.return (Timeout 5.)
  in

  Lwt.pick [request; timeout]

let program () =

  let%lwt response = get
    ~address:"localhost:5000/sum"
    ~args:[("x", "10"); ("y", "3")]
  in

  print_endline (show_response response);
  Lwt.return ()


let () =
  Lwt_main.run (program ())