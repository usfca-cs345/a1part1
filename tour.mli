val pi : float
val e : float
val x : int
val square : int -> int
val square' : int -> int
val hypotenuse : float -> float -> float
val relu : float -> float -> float
val fact : int -> int
val my_list : int list
val larger_list : int list
val every_other : 'a list -> 'a List.t
val every_nth : int -> 'a List.t -> 'a list
val is_prime : int -> bool
val every_other_prime : int list -> int List.t
val sum_abs_even : int list -> int
type album = { artist : string; year : int; title : string; }
val fmb : album
val other_kglw_albums_in_2017 : album list
type genre = Rock | Folk | HipHop | Classical | Metal of string | Pop
val maybe_subgenre : genre -> string option
val subgenre : genre -> string
type song = string * album * genre
val metal_songs : song list -> song list
val songs_by : string -> song list -> song list
val albums_containing_metal_songs_by :
  string -> song list -> album list
