let main () =
  let _x = List_devices.list_devices () in

  let dev = Midi.Device.create 1 in
  let channel = 0 in
  let note = char_of_int 100 in
  let volume = char_of_int 125 in

  Midi.(
  (* Initialize Portmidi *)
    Printf.printf "Calling init";
    init ();
  
  (* Initialize Logs *)
    init_logs ();

  (* Send the note_on signal *)
    write_output dev [ message_on ~note ~timestamp:0l ~volume ~channel () ];

  (* Sleep for 5 seconds  *)
    Unix.sleep 5;

  (* Send the note_off signal *)
    write_output dev [ message_off ~note ~timestamp:0l ~volume ~channel () ];

    Device.shutdown dev |> Midi.handle_error;
    )

let () = main ()