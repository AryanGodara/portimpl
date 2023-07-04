(* let dev = Midi.Device.create 1 *)

let play_note param_list () =
  (*TODO: Initialize Portmidi *)
  print_endline "Calling Midi.init ()\n";
  Midi.init ();

  (*TODO: List Devices  *)
  print_endline "Calling Midi.List_devices.list_devices ()\n";
  List_devices.list_devices () |> ignore;

  let dev = Midi.Device.create 1 in
  let channel = param_list.(0) in
  let note = param_list.(1) in
  let volume = param_list.(2) in

  for i = 1 to 4 do
  Printf.printf "Sending note_on and note_off signals for i = %d\n%!" i;

  (* Send the note_on signal *)
  Midi.(write_output dev [ message_on ~note:(char_of_int (i*note)) ~timestamp:0l ~volume:(char_of_int (volume - 5*i)) ~channel () ]);


  (* Sleep for 2 seconds  *)
  Unix.sleep 2;

  (* Send the note_off signal *)
  Midi.(write_output dev [ message_off ~note:(char_of_int (i*note)) ~timestamp:0l ~volume:(char_of_int (volume - 5*i)) ~channel () ]);

  done;
  (Midi.Device.shutdown dev) |> ignore;
  (* match res with
  | `Ok -> print_endline "Successfully shut down Midi device\n%!"
  | `Error e -> Printf.eprintf "Error shutting down Midi device: %s\n%!" e *)
  ()