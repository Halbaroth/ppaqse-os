open Mirage

let main =
  main "Unikernel.Make"
    ~packages:[
      package "duration";
      package "memtrace-mirage"
    ]
    (stackv4v6 @-> job)

let stackv4v6 = generic_stackv4v6 default_network

let () = register "memtrace" [ main $ stackv4v6 ]
