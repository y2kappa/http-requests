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


type address =
  {
    host: string;
    route: string option;
    port: int option
  }
  [@@deriving show]

let address_opt_to_string address_opt =
  match address_opt with
  | None -> "None"
  | Some address ->
    (show_address address)

let parse_http_address address : address option =

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
    | hd::tl -> (Some hd, Some(String.concat "/" tl))
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