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
(Http_types.Response
   "HTTP/1.1 200 OK\r\nContent-Type: application/json; charset=utf-8\r\nDate: Sun, 27 Oct 2019 01:01:47 GMT\r\nETag: W/...0\"},\"url\":\"https://postman-echo.com/get?x=10&y=3\"}")

$ dune runtest
  test_utils alias src/test/runtest
...
Ran: 3 tests in: 0.00 seconds.
OK
```

## TODO

- [ ] split response into headers & body
- [ ] use json

## References

- https://github.com/ocsigen/lwt