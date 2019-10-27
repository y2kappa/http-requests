module P = Printf
module C = Common
module T = Http_types

let args_to_string args =

  (*
  TODO:
  - we could also filter out duplicate keys

  Expect:
  args_to_string [("",""); ("a","b"); ("c", "d"); ("", "a"); ("", ""); ("z", "")];;
  *)

  let ne = fun s -> not (String.equal s "") in

  let to_string () =
    args
    |> List.filter (fun (fst, snd) -> (ne fst) && (ne snd))
    |> List.map (fun (fst, snd) -> fst ^ "=" ^ snd)
    |> String.concat "&"
    |> fun x -> "?" ^ x
  in

  match List.length args with
  | 0 -> ""
  | _ -> to_string ()


let string_of_address address =
  match address with
  | None -> "None"
  | Some address ->
    (T.show_address address)

let address_of_string address : T.address option =

  (*

  http://localhost:5000/sum     -> Some (localhost, sum, Some (5000))
  https://localhost:5000/sum    -> Some (localhost, sum, Some (5000))
  localhost:5000/sum            -> Some ("localhost", Sone("sum"), Some(5000))
  localhost/sum                 -> Some ("localhost", Some("sum"), None)
  localhost/sum/of              -> Some ("localhost", Some("sum/of"), None)
  localhost                     -> Some ("localhost", Some("sum"), None)
  localhost:a:1/2               -> None
  google.com                    -> Some ("google.com", None, None)

  *)

  let remove address prefixes =
    List.fold_left
      (fun address prefix ->
        let re = Str.regexp prefix in
        Str.global_replace re "" address)
      address
      prefixes
  in

  let prefixes = ["https://"; "http://"] in
  let address = remove address prefixes in

  let (host_and_port, route) = match String.split_on_char '/' address with
    | [x] -> (Some x, None)
    | host_port::route ->
      let route = match route with
        | [root] -> "/" ^ root
        | deep_route -> String.concat "/" deep_route
      in
      (Some host_port, Some route)
    | _ -> (None, None)
  in

  let host, port = match host_and_port with
    | None -> (None, None)
    | Some x ->
      (match String.split_on_char ':' x with
        | [x] -> (Some x, None)
        | [x; y] -> (Some x, Some (int_of_string y))
        | _ -> (None, None))
  in

  match host, route, port with
  | Some h, _, _ -> Some ({host=h; route; port})
  | _ -> None


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

let build_headers args (target:T.address) =
  let str_args = args_to_string args in
  let route = C.value_or target.route "/" in
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