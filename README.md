# Lighweight HTTP request library

```OCaml
let%lwt response = H.get
    ~address:"localhost:5000/sum"
    ~args:[("x", "10"); ("y", "3")]
in

print_endline (T.to_string response);
```

## Build / Run / Test

```sh
$ dune build main.exe
$ ./_build/default/main.exe


$ dune runtest
  test_utils alias src/test/runtest
...
Ran: 3 tests in: 0.00 seconds.
OK
```