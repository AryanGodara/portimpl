
(* open Cmdliner

(* Command Line interface *)
let _ = "Note_on, wait 5 seconds, then Note_5"

let () = print_endline "write the rest of the program" *)
(* open Portmidi *)

let main () =
  let handle_result = function Ok _ -> () | Error _ -> () in
  (* initialize Portmidi *)
  (* let midi = Portmidi.initialize () in *)

  (* Open an output device *)
  (* let output = Portmidi.open_output ~device_id:0 ~buffer_size:0l ~latency:1l in *)

  (* Send the note_on signal *)
  let dev = Midi.Device.create 0 in
  let channel = 0 in
  let note = char_of_int 60 in
  let volume = char_of_int 100 in
  (* let channel = 15 land channel in
  let status = char_of_int (128 lor channel) in
  let message = Portmidi.write_output *)
  (* let event = Midi.message_on ~note ~timestamp:0l ~volume ~channel () in *)
  Midi.(
    write_output dev [ message_on ~note ~timestamp:0l ~volume ~channel () ];

    Unix.sleep 5;

    write_output dev [ message_off ~note ~timestamp:0l ~volume ~channel () ];

    Device.turn_off_everything 0 |> handle_result;
    Device.shutdown dev |> handle_result;
    )

let () = main ()