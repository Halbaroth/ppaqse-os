open Mirage

let main = main "Unikernel" job ~packages:[ package "duration" ]
let () = register "hello" [ main ]
