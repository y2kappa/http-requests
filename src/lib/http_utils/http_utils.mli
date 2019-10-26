
type address =
  {
    host: string;
    route: string option;
    port: int option
  }
  [@@deriving show]

val args_to_string : (string * string) list -> string
val parse_http_address : string -> address option
val address_opt_to_string : address option -> string