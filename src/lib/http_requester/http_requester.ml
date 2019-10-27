
module P = Printf
module U = Http_utils
module T = Http_types
module C = Common

let (>>=) option_ continuation_ =
  match option_ with
  | Some x -> continuation_ x
  | None -> Lwt.return T.Error


let get ~address ~args =

  U.address_of_string address >>= fun target ->
  let port = C.value_or target.port 80 in
  let%lwt socket = U.address_to_socket ~host:target.host ~port in
  let headers = U.build_headers args target in

  (* P.printf "Headers \n\n%s\n\n" headers; *)

  let request = Lwt_io.(with_connection socket (fun (incoming, outgoing) ->
    let%lwt () = write outgoing headers in
    let%lwt response = read incoming in
    Lwt.return (T.Response response)))
  in

  let timeout =
    let%lwt () = Lwt_unix.sleep 5. in
    Lwt.return (T.Timeout 5.)
  in

  Lwt.pick [request; timeout]