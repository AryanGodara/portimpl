let main () =

  (*TODO: Initialize Portmidi *)
  Printf.printf "Calling init";
  Midi.init ();

  (*TODO: List Devices  *)
  List_devices.list_devices () |> ignore;

  let dev = Midi.Device.create 1 in
  let channel = 0 in
  let note = 10 in
  let volume = 25 in

  for i = 1 to 5 do

  (* Send the note_on signal *)
  Midi.(write_output dev [ message_on ~note:(char_of_int (i*note)) ~timestamp:0l ~volume:(char_of_int (i*volume)) ~channel () ]);


  (* Sleep for 2 seconds  *)
  Unix.sleep 2;

  (* Send the note_off signal *)
  Midi.(write_output dev [ message_off ~note:(char_of_int (i*note)) ~timestamp:0l ~volume:(char_of_int (i*volume)) ~channel () ]);

  done

let () = main ()