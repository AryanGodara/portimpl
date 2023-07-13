open Lwt.Infix

(* Shared mutable counter *)
let counter = ref 0
let listen_address = Unix.inet_addr_loopback
let port = 9000
let backlog = 10
let string_to_char s = char_of_int @@ int_of_string s

let handle_message msg =
  match msg with
  | "quit" -> "quit"
  | "read" -> string_of_int !counter
  | "inc" ->
      counter := !counter + 1;
      "Counter has been incremented"
  | _ -> "Unknown command"

let rec handle_request server_socket =
  print_endline "Waiting for request";
  let buffer = Bytes.create 1024 in
  server_socket >>= fun server_socket ->
  Lwt_unix.recvfrom server_socket buffer 0 1024 []
  >>= fun (num_bytes, client_address) ->
  let message = Bytes.sub_string buffer 0 num_bytes in
  let reply = handle_message message in
  match reply with
  | "quit" ->
      print_endline "Quitting Server...";
      Lwt_unix.sendto server_socket (Bytes.of_string reply) 0
        (String.length reply) [] client_address
      >>= fun _ -> Lwt.return ()
  | _ ->
      Lwt_unix.sendto server_socket (Bytes.of_string reply) 0
        (String.length reply) [] client_address
      >>= fun _ -> handle_request (Lwt.return server_socket)

let create_server sock =
  print_endline "Creating server";
  handle_request sock

let create_socket () : Lwt_unix.file_descr Lwt.t =
  print_endline "Creating socket";
  let open Lwt_unix in
  let sock = socket PF_INET SOCK_DGRAM 0 in
  bind sock @@ ADDR_INET (listen_address, port) >>= fun () -> Lwt.return sock
