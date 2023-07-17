let main () =
  (*TODO: Initialize Portmidi *)
  print_endline "Calling Midi.init ()\n";
  Midi.init ();

  (*TODO: List Devices  *)
  print_endline "Calling Midi.List_devices.list_devices ()\n";
  List_devices.list_devices () |> ignore;
  ()

let () =
  main ();
  (* Tcp_server.run_server () *)
  let () = Logs.set_reporter (Logs.format_reporter ()) in
  let () = Logs.set_level (Some Logs.Info) in

  (* Server *)
  let server_socket = Udp_server.create_socket () in
  let client_socket = Udp_client.create_socket () in

  let thre =
    Lwt.pick
      [
        Udp_server.create_server server_socket;
        Udp_client.create_client client_socket;
      ]
  in

  Lwt_main.run thre
