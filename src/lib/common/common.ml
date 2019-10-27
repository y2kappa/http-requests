let value_or option_ or_ =
  match option_ with
  | Some value -> value
  | None -> or_
