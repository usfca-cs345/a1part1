(* This is a comment, comments in OCaml are like block comments in Java but with
   parentheses rather than slashes.

   Your homework is fill in the blanks, i.e. to replace each instance of `todo
   ()` with the appropriate expression.
*)

(* `open Mod` opens the module Mod (defined in mod.ml), i.e. it imports the
   definitions from that module. It is equivalent to `from Mod import *` in Python *)
open Util

(* This is how we define a variable in the global scope (pi will be available for
   the rest of the program.

   Also note that we don't need `;;` between two instances of `let` because
   there is no ambiguity about where each expression begins/ends.
*)
let pi = 3.14159

(* We can also specify the type of the variable we are declaring, like so *)
let e : float = 2.718

(* Define a variable x of type int with value 7 below *)
let x = 7 ;;

(* We can create a function like so: *)
fun x -> x * x

(* We can also assign it to a variable in order to call it: *)
let square x = x * x

(* Because "let f = fun x ->" is pretty long, there is a shorthand for it: *)
let square' x = x * x

(* This is like an equation! We effectively tell OCaml to replace each instance
   of `square' x` with `x * x`.

   Note that ' is a valid character in a variable name.
*)

(* We can define local variables in a definition: *)
let hypotenuse a b =
  (* squaref is the square function for floats *)
  let squaref x = x *. x in
  Float.sqrt (squaref a +. squaref b)
;;

(* We use the syntax

   if <condition> then <true branch> else <false branch>

   for conditionals:
*)

if x > 0 then x else -1

(* should evaluate to 7 once you define x above *)

(* Define the rectified linear unit function given by the formula:

   relu(α, x) = 0 when x < 0
   relu(α, x) = αx when x ≥ 0

   Note that we gave the types of the arguments and the return type. You can
   omit any number of these, and the type checker will infer the most general
   type applicable.
*)

let relu (alpha : float) (x : float) : float = if x < 0. then 0. else alpha *. x

(* We need the `rec` keyword to define recursive functions. It enables the name
   of the function to be used in the definition of the function.

   Here is factorial:
*)

let rec fact n = if n = 0 then 1 else n * fact (n - 1)

(* We define an empty list using [], and we prepend an element x to a list l
   using `x :: l`. This does not change the original list, but creates a node
   that points to it (recall that we don't have mutation).

   So, my_list never changes in the example below.
*)

let my_list = [ 1; 2 ]

(* this is same as [1; 2] *)

let larger_list = 4 :: my_list

(* larger_list = [4; 1; 2] *)

(* :: only creates a new linked list node, so it can only prepend an element. If
   we want to concatenate/append two lists, we need to create a copy of the
   first one because there is no mutation. The @ operator does this.

   Example: ([1; 2] @ [4; 6]) = [1; 2; 4; 6]

   This operation takes O(N) time.

   We also used List.hd and List.tl to get the first element and the rest of the list:

   List.hd larger_list = 4
   List.tl larger_list = my_list

   We can open the List module if we don't want to type `List.` every single
   time:
*)

open List

(* now hd, tl, nth, map, fold_left, filter, etc. are all available.

   Here is a link to the List module if you want to explore what functions are
   available to you:

   https://v2.ocaml.org/api/List.html

   `nth l n` returns the nth element of l (0-indexed). It throws an error if n
   >= length l.

   Example:

   nth ["foo"; "bar"] 0 = "foo"
   nth ["foo"; "bar"] 1 = "bar"
   nth ["foo"; "bar"] 2 = <error: out of bounds>

   Because lists are linked lists, this operation takes O(n) time.
*)

(* Implement a function that returns every other element in the list.

   every_other ["a"; "b"; "c"; "d"; "e"] = ["a"; "c"; "e"]
   every_other [] = []
   every_other [1; 2; 4; 8; 4; 2; 1] = [1; 4; 4; 1]

   You can implement it using recursion, a recursive helper, of fold_left. All
   are valid solutions.

   Note on the type signature: 'a is a type variable. So, 'a list is a
   polymorphic/generic type (it is equivalent to List<A> in Java).
*)

(* NOTE: "function" is a short hand to create a function that does pattern
   matching on its argument. So, the following are equivalent (but there is no
   name for the argument x for the first function):

   let f = function
    | case1 -> ...
    | case2 -> ...

   
   let f x = match x with
    | case1 -> ...
    | case2 -> ...
*)
let rec every_other = function
  | [] -> []
  | first :: _ :: rest -> first :: every_other rest
  | xs -> xs (* this case is guaranteed to be a 1-element list *)

(* Generalize the function above to return every nth element. So, it takes the
   first element, skips the next n-1 elements (if there are <n-1 elements left
   then it skips all of them), then repeats this process.

   You may want to implement a helper function to skip the elements, then build
   every_nth using that helper.

   Examples:

   every_nth 2 = every_other
   every_nth 2 ["a"; "b"; "c"; "d"; "e"] = ["a"; "c"; "e"]
   every_nth 3 ["a"; "b"; "c"; "d"; "e"] = ["a"; "d"]
   every_nth 3 ["a"; "b"; "c"; "d"; "e"; "f"] = ["a"; "d"]
   every_nth 1 xs = xs (* so, every_nth 1 is identity *)
   every_nth 100 [1; 4; 9; 16] = [1]
*)
let rec every_nth (n : int) (xs : 'a list) : 'a list =
  (* helper that drops the first k elements of the given list *)
  let rec drop k = function
    | _ :: xs when k > 0 -> drop (k - 1) xs
    | xs -> xs (* the case for k = 0 or the list is empty *)
  in match xs with
  | [] -> []
  | first :: _ -> first :: every_nth n (drop n xs)

(* You can chain functions using two alternative notations in OCaml. Using
   either, or whether to use them at all is up to you. Their main purpose is to
   clarify the intent of the program.

   The first is the "@@" operator, which expects the function on the left, and
   the argument on the right. You can pronounce it as "of" or "applied to":

   f @@ g @@ h x = f (g (h x))

   The main purpose of @@ is to reduce parentheses and make code more
   readable. For example, if we want to take the first 5 odd numbers in a list
   l, we can write:

   take 5 (only_odds l)

   or, we can write:

   take 5 @@ only_odds l

   The second is the "|>" operator, which works in the opposite direction
   (argument on the left, result on the right). You can pronounce it as "then":

   x |> f |> g |> h = h (g (f x))

   It is useful for building "pipelines" by composing functions, and it is
   similar to the pipe operator "|" in shell scripts. For example, we can
   express the computation "from the list of students, pick only the ones in the
   first section, get their email addresses, and send them the welcome email"
   like so:

   students |> filter (fun s -> s.section = 1)
            |> map (fun s -> s.email)
            |> map (send_email "Welcome to CS 345")

   Note that the only side effect in the pipeline above is sending the emails,
   we are just applying one function after another. Also, it is arguably more
   clear than just writing the function calls:

   map (send_email "Welcome to CS 345")
     (map (fun s -> s.email)
        (filter (fun s -> s.section = 1) students))
*)

(* The function below checks if a number is prime using a semi-naive method, it
   is a helper function for the next problem. *)
let is_prime n =
  (* check if a divides b *)
  let rec divides a b = b mod a = 0
  (* the maximum value to try *)
  and max_value = int_of_float @@ Float.sqrt @@ float_of_int n
  (* a function that tries only values of the form 6k ± 1 *)
  and check_possible_divisors k =
    if 6 * k > max_value then true
    else if divides ((6 * k) - 1) n || divides ((6 * k) + 1) n then false
    else check_possible_divisors (k + 1)
  in
  if n < 6 then n = 2 || n = 3 || n = 5
  else
    (* now, we need to check if n is divided by 2, 3, or any number ≤ sqrt(n) of
       the form 6k ± 1. if none of those divide n, then it is prime *)
    (not (divides 2 n)) && (not (divides 3 n)) && check_possible_divisors 1

(* The function below returns a list of every other prime number in a given
   list.

   Example:

   every_other_prime [1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11] = [2; 5; 11]

   Try implementing it using the every_other function above and higher-order
   functions (map, filter, etc.) and if possible by building a pipeline of
   functions (defining or using small helpers then chaining them together).
*)
let every_other_prime xs = every_other @@ filter is_prime xs

(* The function below computes the sum of absolute values of even numbers in a
   list.

   Example:

   sum_abs_even [1; -2; 3; 4; -6; 8] = 2 + 4 + 6 + 8 = 20

   Try implementing it using higher-order functions (map, fold_left, filter,
   etc.) and if possible by building a pipeline of functions (defining small
   helpers then chaining them together).

   There is already the `abs` function in the standard library, you can use it
   to calculate the absolute value of an integer.
*)
let sum_abs_even xs =
  let sum = fold_left (+) 0
  and is_even x = x mod 2 = 0
  in sum @@ map abs @@ filter is_even xs

(* We can define new types using `type` keyword. The following defines a new
   record type (similar to a struct/class in C/Java/Python) album with fields
   artist, year, title:
*)
type album = { artist : string; year : int; title : string }

(* Then, we can create a record, and access the fields of a record like in
   Python and Java. However there is a caveat: we don't use the name of the
   record itself when creating it. OCaml infers the correct record type from the
   fields.

   N.B. OCaml has _mutable_ record fields but we won't use them in this
   class. They are verboten.
*)
let fmb =
  {
    artist = "King Gizzard and the Lizard Wizard";
    year = 2017;
    title = "Flying Microtonal Banana";
  }

(* We can "update" a record (create a new record with only some fields changed)
   using the syntax

   { original_record with field1 = newValue1; field2 = newValue2; ... }

   King Gizzard and the Lizard Wizard (KGLW) is a prolific band. They released 5
   songs in 2017, so we can reuse most of the data in the fmb variable above to
   define their other songs in 2017 in alphabetical order:

   - Murder of the Universe
   - Sketches of Brunswick East
   - Polygondwanaland
   - Gumboot Soup

   Fill the list below with copies of fmb updated using the record update syntax
   to produce the list above.

   If you are up for a challenge, you can define an update function that changes
   only the title, then use List.map to convert a list of titles (strings) to
   a list of KGLW albums released in 2017.
*)
let other_kglw_albums_in_2017 : album list =
  [
   { fmb with title = "Murder of the Universe" };
   { fmb with title = "Sketches of Brunswick East" };
   { fmb with title = "Polygondwanaland" };
   { fmb with title = "Gumboot Soup" };
  ]

(* We can also define variants (a type with many alternatives). Variants are
   also called tagged unions. They are similar to unions in C, but they are safe
   unlike C. For example, we can define genres like so:
*)

type genre = Rock | Folk | HipHop | Classical | Metal of string | Pop

(* A value of type `genre` can be only one of these 5 cases.  In the last case,
   we keep a string inside as well to represent all the subgenres of metal. The
   following are all values of the `genre` type:

   Rock
   Folk
   Metal "heavy"
   Metal "progressive"

   Each alternative here is called a "constructor" because it constructs a
   value. OCaml has a restriction for constructor names: Constructors have to
   start with a capital letter whereas variables (and functions) have to start
   with a lowercase letter or underscore.

   Note that not all variants have a string inside, so we need to use pattern
   matching to get the string:
*)

(* Returns the subgenre if there is any *)
let maybe_subgenre g =
  match g with Metal subgenre -> Some subgenre | _ -> None

(* Define a function that returns the subgenre of a genre. If it is not a metal
   song, then it does not have a subgenre, so the function should return the
   string "not metal enough" instead.
 *)
let subgenre = function
  | Metal subgenre -> subgenre
  | _ -> "not metal enough"

(* Now, we can also define a type for songs. This time, we will use only tuples
   (product types) rather than records.

   The choice between tuples and records is a pragmatic one:

   - In some cases, we'd want to access particular fields (e.g., through
   x.field). Using records is more useful in these cases.

   - Sometimes, we would deconstruct a small type frequently (e.g., using
   pattern matching) or the names for the fields are not convenient or clear. In
   these cases, tuples are more appropriate.

   So, a song is a triple consisting of its name, the album it belongs to, and
   the genre it is in.
*)
type song = string * album * genre

(* Define a function that returns all metal songs in a list. See the tests for
   examples.
*)
let metal_songs =
  (* a helper that checks if a song is a metal song using pattern matching *)
  let is_metal = function
    | (_, _, Metal _) -> true
    | _ -> false
  in filter is_metal

(* Define a function that returns all songs by a given artist. See the tests for
   examples. *)
let songs_by artist =
  (* the same idea as metal_songs above *)
  filter (fun (_, album, _) -> album.artist = artist)

(* Now, let's fuse these two selection functions, and add a transformation.

   Define a function that returns the albums of all metal songs by the given artist.
   Repetitions are okay. *)
let albums_containing_metal_songs_by artist songs =
  songs_by artist songs
  |> metal_songs
  |> map (fun (_, album, _) -> album)
