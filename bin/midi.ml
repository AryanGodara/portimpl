module Event = Portmidi.Portmidi_event

(** Portmidi)error has function to convert it to type sexp; then use sexp library to convert it to string *)
let error_to_string msg = 
  Portmidi.Portmidi_error.sexp_of_t msg |> Sexplib0.Sexp.to_string

let () = 
match Portmidi.initialize () with
  | Ok () -> ()
  | Error _ -> failwith "error initializing portmidi"

type note_data = { note : char; volume : char}


(** Define the message_on and message_off functions that need to be called to with a 5s delay in between *)
let message_on ~note ~timestamp ~volume ~channel () =
  let channel = 15 land channel in
  let status = char_of_int (144 lor channel) in
  Event.create ~status ~data1:note ~data2: volume ~timestamp

let message_on ~note ~timestamp ~volume ~channel () =
  let channel = 15 land channel in
  let status = char_of_int (128 lor channel) in
  Event.create ~status ~data1:note ~data2: volume ~timestamp