open Lwt.Infix

module Make (S : Tcpip.Stack.V4V6) = struct
  module Memtrace = Memtrace.Make (S.TCP)

  let rec alloc i =
    if i < 0 then Lwt.return_unit
    else
      let a = Array.init 1_000_000 (fun i -> i * i) in
      Array.sort Int.compare a;
      Lwt.pause () >>= fun () -> alloc (i - 1)

  let start s =
    S.TCP.listen (S.tcp s) ~port:1234 (fun f ->
      match Memtrace.Memprof_tracer.active_tracer () with
      | Some _ -> S.TCP.close f
      | None ->
        let tracer =
          Memtrace.start_tracing ~context:None ~sampling_rate:1e-4 f
        in
        Lwt.async (fun () ->
          S.TCP.read f >|= fun _ ->
          Memtrace.stop_tracing tracer);
        Lwt.return_unit);
    alloc 10
end

