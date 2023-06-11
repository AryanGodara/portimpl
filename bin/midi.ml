module Event = Portmidi.Portmidi_event

(* ? MODULE DEVICE *)
module Device = struct
  type t = { device_id : int; device : Portmidi.Output_stream.t }

  (* TODO: don't hardcode device_id. get it from the portmidi [get_device] *)
  let create device_id =
    match Portmidi.open_output ~device_id ~buffer_size:0l ~latency:1l with
    | Error _ ->
        Printf.eprintf "Can't find midi device with id: %i\nIs it connected?\n"
          device_id;
        exit 1
        (* let err = Printf.sprintf "Can't find midi device with id %i.Is it connected?" device_id in failwith err *)
    | Ok device -> { device; device_id }

  (* let turn_off_everything device_id =
    let device = create device_id in
    let* _ =
      Portmidi.write_output device.device
        [
          Event.create ~status:'\176' ~data1:'\123' ~data2:'\000' ~timestamp:0l;
        ]
    in
    Portmidi.close_output device.device

  let shutdown { device; device_id } =
    let* _ = Portmidi.close_output device in
    Unix.sleepf 0.5;
    turn_off_everything device_id *)
end



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

let message_off ~note ~timestamp ~volume ~channel () =
  let channel = 15 land channel in
  let status = char_of_int (128 lor channel) in
  Event.create ~status ~data1:note ~data2: volume ~timestamp



let handle_error = function Ok _ -> () | Error _ -> ()

let write_output {Device.device; Device.device_id} msg =
  Printf.printf "Creating device with id %s\n" (string_of_int device_id);
  Portmidi.write_output device msg |> handle_error
