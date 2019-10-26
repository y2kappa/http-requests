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