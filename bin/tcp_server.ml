open Lwt

(* Shared mutable counter *)
let counter = ref 0
let listen_address = Unix.inet_addr_loopback
let port = 9000
let backlog = 10
let string_to_char s = char_of_int @@ int_of_string s

let handle_message msg =
  match msg with
  | "exit" -> "Bye!"
  | _ -> (
      let param_list = Str.split_delim (Str.regexp " ") msg in
      match param_list with
      | [ _; _; _ ] ->
          let char_param_list = List.map string_to_char param_list in
          Client.play_note (Array.of_list char_param_list) ();
          "Values sent to MIDI to play your note"
      | _ -> "Invalid Input: Provide 3 parameters")

let rec handle_connection ic oc () =
  Lwt_io.read_line_opt ic >>= fun msg ->
  match msg with
  | Some msg ->
      let reply = handle_message msg in
      Lwt_io.write_line oc reply >>= handle_connection ic oc
  | None -> Logs_lwt.info (fun m -> m "Connection closed") >>= return

let accept_connection conn =
  Printf.printf "Accepting connection from client\n%!";
  let fd, _ = conn in
  let ic = Lwt_io.of_fd ~mode:Lwt_io.Input fd in
  let oc = Lwt_io.of_fd ~mode:Lwt_io.Output fd in
  Lwt.on_failure (handle_connection ic oc ()) (fun e ->
      Logs.err (fun m -> m "%s" (Printexc.to_string e)));
  Logs_lwt.info (fun m -> m "New connection") >>= return

let create_socket () =
  print_endline "Creating socket";
  let open Lwt_unix in
  let sock = socket PF_INET SOCK_STREAM 0 in
  (bind sock @@ ADDR_INET (listen_address, port) |> fun x -> ignore x);
  listen sock backlog;
  sock

let create_server sock =
  print_endline "Creating server";
  let rec serve () = Lwt_unix.accept sock >>= accept_connection >>= serve in
  serve

let run_server () =
  print_endline "Running server";
  let () = Logs.set_reporter (Logs.format_reporter ()) in
  let () = Logs.set_level (Some Logs.Info) in
  let sock = create_socket () in
  let serve = create_server sock in
  Lwt_main.run @@ serve ()

(* Lwt_main.run @@ ( let redune build
   c serve () = Lwt_unix.accept sock >>= accept_connection >>= serve in serve ) () *)
