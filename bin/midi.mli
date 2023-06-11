module Event = Portmidi.Portmidi_event

val error_to_string : Portmidi.Portmidi_error.t -> string

val message_on : 
  note:char -> timestamp:int32 -> volume:char -> channel:int -> unit -> Event.t
val message_off : 
  note:char -> timestamp:int32 -> volume:char -> channel:int -> unit -> Event.t

module Device : sig
  type t

  val create : int -> t
  val shutdown : t -> (unit, Portmidi.Portmidi_error.t) result
  val turn_off_everything : int -> (unit, Portmidi.Portmidi_error.t) result
end

type note_data = { note : char; volume : char}

val write_output : Device.t -> Portmidi.Portmidi_event.t list -> unit