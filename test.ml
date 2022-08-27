open Tour
open Alcotest

let blackstar = { title = "Blackstar"; year = 2016; artist = "David Bowie" }

let black_sabbath =
  { title = "Black Sabbath"; year = 1970; artist = "Black Sabbath" }

let paranoid = { title = "Paranoid"; year = 1970; artist = "Black Sabbath" }

let a_change_of_seasons =
  { title = "A Change of Seasons"; year = 1995; artist = "Dream Theater" }

let no_album artist year = { title = "no album"; year; artist }

let songs : song list =
  [
    (* bowie *)
    ("Blackstar", blackstar, Pop);
    (* sabbath *)
    ("Black Sabbath", black_sabbath, Metal "doom");
    ("Iron Man", paranoid, Metal "heavy");
    (* dream theater *)
    ("A Change of Seasons", a_change_of_seasons, Metal "progressive");
    ("Perfect Strangers", a_change_of_seasons, Rock);
    (* kglw *)
    ("Rattlesnake", fmb, Rock);
    (* woody guthrie *)
    ("This Land Is Your Land", no_album "Woody Guthrie" 1940, Folk);
  ]

let metal_songs : song list =
  [
    ("A Change of Seasons", a_change_of_seasons, Metal "progressive");
    ("Black Sabbath", black_sabbath, Metal "doom");
    ("Iron Man", paranoid, Metal "heavy");
  ]

let sabbath_songs : song list =
  [
    ("Black Sabbath", black_sabbath, Metal "doom");
    ("Iron Man", paranoid, Metal "heavy");
  ]

let string_of_album { artist; year; title } : string =
  Format.sprintf "artist = %s; year = %d; title = %s" artist year title

let talbum = testable (fun ppf a -> Fmt.pf ppf "%s" (string_of_album a)) ( = )

let tsong =
  testable
    (fun ppf (name, album, _) ->
      Fmt.pf ppf "%s by %s [%d]" name album.artist album.year)
    ( = )

let test_value name t actual expected =
  test_case name `Quick @@ fun () -> Alcotest.(check t) name expected actual

let test_x = test_value "x" int x 7

let test_relu (alpha, n, result) =
  test_case (Printf.sprintf "relu %f %f" alpha n) `Quick @@ fun () ->
  Alcotest.(check (float 0.0001)) "relu" (relu alpha n) result

let test_fn (f : 'b -> 'a) name (ret_t : 'a testable) (input : 'b) (result : 'a)
    =
  test_case name `Quick @@ fun () ->
  (Alcotest.check @@ ret_t) name result (f input)

let test_fn_named (f : 'b -> 'a) name (ret_t : 'a testable) case_name
    (input : 'b) (result : 'a) =
  test_case name `Quick @@ fun () ->
  (Alcotest.check @@ ret_t) case_name result (f input)

let test_list_fn :
      'a 'b.
      ('b -> 'a list) ->
      string ->
      'a testable ->
      'b ->
      'a list ->
      unit test_case =
 fun f name elem_t -> test_fn f name (Alcotest.list elem_t)

let add_sort f x = List.sort_uniq compare (f x)

let test_every_other : 'a. 'a testable -> 'a list -> 'a list -> unit test_case =
 fun t -> test_list_fn every_other "every_other" t

let test_every_nth n = test_list_fn (every_nth n) "every_nth"

let test_every_other_prime =
  test_list_fn every_other_prime "every_other_prime" int

let test_sum_abs_even = test_fn sum_abs_even "sum_abs_even" int
let test_subgenre = test_fn_named subgenre "sub_genre" Alcotest.string

let test_metal_songs =
  test_list_fn (add_sort Tour.metal_songs) "metal_songs" tsong

let test_songs_by artist = test_list_fn (songs_by artist) "songs_by" tsong

let test_albums_containing_metal artist =
  test_list_fn
    (albums_containing_metal_songs_by artist)
    "albums_containing_metal_songs_by" talbum
;;

(* test suite *)

run "tour"
  [
    (* tests *)
    ("value of x", [ test_x (* the only test case *) ]);
    ( "relu",
      List.map test_relu
        [
          (* test cases

             alpha, n, relu alpha n
          *)
          (-1.0, 0.0, 0.0);
          (1.0, 0.0, 0.0);
          (1.0, 5.0, 5.0);
          (8.0, 5.0, 40.0);
          (-6.0, 5.0, -30.0);
          (8.0, -5.0, 0.0);
          (0.0, 5.0, 0.0);
        ] );
    ( "every_other",
      [
        test_every_other Alcotest.string
          [ "a"; "b"; "c"; "d"; "e" ]
          [ "a"; "c"; "e" ];
        test_every_other Alcotest.int [] [];
        test_every_other Alcotest.int [ 1; 2; 4; 8; 4; 2; 1 ] [ 1; 4; 4; 1 ];
        test_every_other Alcotest.int [ 1; 5; 4; 3 ] [ 1; 4 ];
      ] );
    ( "every_nth",
      [
        test_every_nth 2 Alcotest.int [] [];
        test_every_nth 2 Alcotest.string
          [ "a"; "b"; "c"; "d"; "e" ]
          [ "a"; "c"; "e" ];
        test_every_nth 2 Alcotest.int [ 1; 2; 4; 8; 4; 2; 1 ] [ 1; 4; 4; 1 ];
        test_every_nth 2 Alcotest.int [ 1; 5; 4; 3 ] [ 1; 4 ];
        test_every_nth 100 Alcotest.string [ "a"; "b"; "c"; "d"; "e" ] [ "a" ];
        test_every_nth 3 Alcotest.int [ 1; 2; 4; 8; 4; 2; 1 ] [ 1; 8; 1 ];
        test_every_nth 3 Alcotest.int [ 1; 5; 4; 3 ] [ 1; 3 ];
        test_every_nth 3 Alcotest.string
          [ "a"; "b"; "c"; "d"; "e"; "f" ]
          [ "a"; "d" ];
        test_every_nth 1 Alcotest.int [ 1; 2; 4; 8; 4; 2; 1 ]
          [ 1; 2; 4; 8; 4; 2; 1 ];
        test_every_nth 1 Alcotest.int [ 1; 5; 4; 3 ] [ 1; 5; 4; 3 ];
        test_every_nth 1 Alcotest.string
          [ "a"; "b"; "c"; "d"; "e"; "f" ]
          [ "a"; "b"; "c"; "d"; "e"; "f" ];
      ] );
    ( "every_other_prime",
      let test = test_every_other_prime in
      [
        test [ 1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11 ] [ 2; 5; 11 ];
        test [ 1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11; 13 ] [ 2; 5; 11 ];
        test
          (List.init 100 (fun x -> x))
          [ 2; 5; 11; 17; 23; 29; 35; 41; 47; 59; 67; 73; 83; 97 ];
        test
          (List.init 97 (fun x -> x))
          [ 2; 5; 11; 17; 23; 29; 35; 41; 47; 59; 67; 73; 83 ];
      ] );
    ( "sum_abs_even",
      [
        test_sum_abs_even [ 1; 2; 3; -4; 5 ] 6;
        test_sum_abs_even [] 0;
        test_sum_abs_even [ 1; -2; 3; 4; -6; 8 ] 20;
      ] );
    ( "other_kglw_albums_in_2017",
      let check_title title =
        List.exists (fun a -> a.title = title) other_kglw_albums_in_2017
      in
      let test_title title = test_value title bool (check_title title) true in
      [
        test_value "number of albums" int
          (List.length other_kglw_albums_in_2017)
          4;
        test_title "Murder of the Universe";
        test_title "Sketches of Brunswick East";
        test_title "Polygondwanaland";
        test_title "Gumboot Soup";
        test_value "release years" int
          (Option.value ~default:2017
          @@ List.find_map
               (fun a -> if a.year != 2017 then Some a.year else None)
               other_kglw_albums_in_2017)
          2017;
      ] );
    ( "subgenre",
      [
        test_subgenre "doom metal" (Metal "doom") "doom";
        test_subgenre "heavy metal" (Metal "heavy") "heavy";
        test_subgenre "rock" Rock "not metal enough";
        test_subgenre "classical" Classical "not metal enough";
      ] );
    ( "metal_songs",
      [
        test_metal_songs [] [];
        test_metal_songs songs metal_songs;
        test_metal_songs sabbath_songs sabbath_songs;
        test_metal_songs [ ("Rattlesnake", fmb, Rock) ] [];
      ] );
    ( "songs_by",
      [
        test_songs_by "Woody Guthrie" sabbath_songs [];
        test_songs_by "Black Sabbath" [] [];
        test_songs_by "Black Sabbath" songs sabbath_songs;
      ] );
    ( "albums_containing_metal_songs_by",
      [
        test_albums_containing_metal "Black Sabbath" [] [];
        test_albums_containing_metal "Black Sabbath" songs
          [ black_sabbath; paranoid ];
        test_albums_containing_metal "David Bowie" songs [];
        test_albums_containing_metal "Dream Theater" songs
          [ a_change_of_seasons ];
      ] );
  ]
