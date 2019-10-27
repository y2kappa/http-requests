
type arg = string * string

type address =
  {
    host: string;
    route: string option;
    port: int option
  }
  [@@deriving show]

type response =
  | Response of string
  | Timeout of float
  | Error
  [@@deriving show]

val to_string :
  response ->
  string