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
  Tcp_server.run_server ()
