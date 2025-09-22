open Lwt.Infix
type 'a io = 'a Lwt.t
let return = Lwt.return
let run t = Xen_os.Main.run t ; exit
0

let mirage_runtime_delay__key = Mirage_runtime.register_arg @@
# 33 "lib/devices/runtime_arg.ml"
  Mirage_runtime.delay
;;

let mirage_runtime_logs__key = Mirage_runtime.register_arg @@
# 204 "lib/devices/runtime_arg.ml"
  Mirage_runtime.logs
;;

let cmdliner_stdlib_setup_backtracesome_true_randomize_hashtablessome_true___key = Mirage_runtime.register_arg @@
# 385 "lib/mirage.ml"
  Cmdliner_stdlib.setup ~backtrace:(Some true) ~randomize_hashtables:(Some true) ()
;;

let mirage_bootvar__1 = lazy (
# 15 "lib/devices/argv.ml"
  return (Mirage_bootvar.argv ())
);;
# 27 "mirage/main.ml"

let struct_end__2 = lazy (
  let __mirage_bootvar__1 = Lazy.force mirage_bootvar__1 in
  __mirage_bootvar__1 >>= fun _mirage_bootvar__1 ->
# 47 "lib/functoria/job.ml"
  return Mirage_runtime.(with_argv (runtime_args ()) "watchdog" _mirage_bootvar__1)
);;
# 35 "mirage/main.ml"

let cmdliner_stdlib__3 = lazy (
  let _cmdliner_stdlib_setup_backtracesome_true_randomize_hashtablessome_true_ = (cmdliner_stdlib_setup_backtracesome_true_randomize_hashtablessome_true___key ()) in
  return (_cmdliner_stdlib_setup_backtracesome_true_randomize_hashtablessome_true_)
);;
# 41 "mirage/main.ml"

let mirage_runtime__4 = lazy (
  let _mirage_runtime_delay = (mirage_runtime_delay__key ()) in
# 283 "lib/mirage.ml"
  Mirage_sleep.ns (Duration.of_sec _mirage_runtime_delay)
);;
# 48 "mirage/main.ml"

let mirage_logs__5 = lazy (
  let _mirage_runtime_logs = (mirage_runtime_logs__key ()) in
# 21 "lib/devices/reporter.ml"
  let reporter = Mirage_logs.create () in
  Mirage_runtime.set_level ~default:(Some Logs.Info) _mirage_runtime_logs;
  Logs.set_reporter reporter;
  Lwt.return reporter
);;
# 58 "mirage/main.ml"

let mirage_sleep__6 = lazy (
  return ()
);;
# 63 "mirage/main.ml"

let mirage_ptime__7 = lazy (
  return ()
);;
# 68 "mirage/main.ml"

let mirage_mtime__8 = lazy (
  return ()
);;
# 73 "mirage/main.ml"

let mirage_crypto_rng_mirage__9 = lazy (
# 13 "lib/devices/random.ml"
  Mirage_crypto_rng_mirage.initialize (module Mirage_crypto_rng.Fortuna)
);;
# 79 "mirage/main.ml"

let unit__10 = lazy (
  return ()
);;
# 84 "mirage/main.ml"

let unikernel__11 = lazy (
  let __unit__10 = Lazy.force unit__10 in
  __unit__10 >>= fun _unit__10 ->
  (Unikernel.start _unit__10 : unit io)
);;
# 91 "mirage/main.ml"

let mirage_runtime__12 = lazy (
  let __struct_end__2 = Lazy.force struct_end__2 in
  let __cmdliner_stdlib__3 = Lazy.force cmdliner_stdlib__3 in
  let __mirage_runtime__4 = Lazy.force mirage_runtime__4 in
  let __mirage_logs__5 = Lazy.force mirage_logs__5 in
  let __mirage_sleep__6 = Lazy.force mirage_sleep__6 in
  let __mirage_ptime__7 = Lazy.force mirage_ptime__7 in
  let __mirage_mtime__8 = Lazy.force mirage_mtime__8 in
  let __mirage_crypto_rng_mirage__9 = Lazy.force mirage_crypto_rng_mirage__9 in
  let __unikernel__11 = Lazy.force unikernel__11 in
  __struct_end__2 >>= fun _struct_end__2 ->
  __cmdliner_stdlib__3 >>= fun _cmdliner_stdlib__3 ->
  __mirage_runtime__4 >>= fun _mirage_runtime__4 ->
  __mirage_logs__5 >>= fun _mirage_logs__5 ->
  __mirage_sleep__6 >>= fun _mirage_sleep__6 ->
  __mirage_ptime__7 >>= fun _mirage_ptime__7 ->
  __mirage_mtime__8 >>= fun _mirage_mtime__8 ->
  __mirage_crypto_rng_mirage__9 >>= fun _mirage_crypto_rng_mirage__9 ->
  __unikernel__11 >>= fun _unikernel__11 ->
# 366 "lib/mirage.ml"
  return ()
);;
# 115 "mirage/main.ml"

let () =
  let t = Lazy.force struct_end__2 >>= fun _ ->
  Lazy.force cmdliner_stdlib__3 >>= fun _ ->
  Lazy.force mirage_runtime__4 >>= fun _ ->
  Lazy.force mirage_logs__5 >>= fun _ ->
  Lazy.force mirage_sleep__6 >>= fun _ ->
  Lazy.force mirage_ptime__7 >>= fun _ ->
  Lazy.force mirage_mtime__8 >>= fun _ ->
  Lazy.force mirage_crypto_rng_mirage__9 >>= fun _ ->
  Lazy.force mirage_runtime__12 in
  run t
;;
