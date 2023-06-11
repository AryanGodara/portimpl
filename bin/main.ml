let main () =
  let handle_result = function Ok _ -> () | Error _ -> () in


  (* Send the note_on signal *)
  let dev = Midi.Device.create 0 in
  let channel = 0 in
  let note = char_of_int 60 in
  let volume = char_of_int 100 in

  Midi.(
    write_output dev [ message_on ~note ~timestamp:0l ~volume ~channel () ];

    Unix.sleep 5;

    write_output dev [ message_off ~note ~timestamp:0l ~volume ~channel () ];

    Device.turn_off_everything 0 |> handle_result;
    Device.shutdown dev |> handle_result;
    )

let () = main ()