
module T = Http_types

val get :
  address : string ->
  args : T.arg list ->
  T.response Lwt.t