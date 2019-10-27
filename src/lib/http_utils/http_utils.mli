module T = Http_types

val args_to_string : T.arg list -> string

val address_of_string : string -> T.address option
val string_of_address : T.address option -> string

val address_to_socket :
  host : string ->
  port : int ->
  Unix.sockaddr Lwt.t

val build_headers :
  T.arg list ->
  T.address ->
  string