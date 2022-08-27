# Programming Assignment 1 Part 1

**See Canvas for the due date**

In this assignment, you are going to go through a tour of OCaml and implement
several functions with a focus on list manipulation. The only file you need to
edit is `tour.ml`, I will ignore changes to any other files when grading your
assignment.

## Structure of the project

- `test.ml` contains the test suite.
- `tour.ml` is where you are going to make changes.
- `tour.mli` contains the type declarations for these functions, so the compiler
  will infer and check the correct type for you.
- `util.ml` contains utility functions (only the placeholder `todo` function for
  this assignment).

## What you need to implement

You need to "fill in the blanks" in the `tour.ml` file. Specifically, you need
to replace each instance of `todo` or `todo ()`. Overall, you need to implement
the following variables/functions:

- `x`
- `every_other`
- `every_nth`
- `every_other_prime`
- `sum_abs_even`
- `other_kglw_albums_in_2017`
- `subgenre`
- `metal_songs`
- `songs_by`
- `albums_containing_metal_songs_by`

Here are some important notes:

- Some of the functions are declared with `let`, you can convert it to `let rec`.
- If you see `todo ()` you need to replace it. If you see a `todo` without the
  parentheses, then you need to replace only the `todo`.
- The latter half of the assignment relies on records and variants, we will
  cover these topics on Tuesday, but the assignment has explanations to get you
  started with these parts as well.
- The functions returning songs/albums can have duplicates or items out of
  order. The tester ignores the duplicates and sorts the result of these
  functions.

## How to test your implementation

`test.ml` contains the test suite. You can run `dune test` to run the whole test
suite. However there are two big caveats:

- **You have to implement `x` before you will be able to run the test suite.**
- **If you haven't implemented everything (i.e., there is a `todo` in the
code). The tester will stop when it attempts the first `todo`.**

You can still test a single function. For example, if you want to run the tests for the function `foo`, you can do so by running

```
dune exec -- ./test.exe test "^foo"
```

Which will run only the tests for `foo` and _skip_ other tests.

### Errors related to `tour.mli`

Sometimes type inference leads to type errors in unexpected places. In order to
curb that, you are given an interface file `tour.mli` that describes the
expected type of every declaration in `tour.ml`. If your implementation of a
function has a type other than what is expected in `tour.mli`, you will get an
error like:

```
File "tour.ml", line 1:
Error: The implementation tour.ml
       does not match the interface .tour.objs/byte/tour.cmi:
       Values do not match: val pi : int is not included in val pi : float
       The type int is not compatible with the type float
       File "tour.mli", line 1, characters 0-14: Expected declaration
       File "tour.ml", line 18, characters 4-6: Actual declaration
```

Here, the important bit is `Values do not match: val pi : int is not included in
val pi : float`. So, in this case, `pi` is declared to be a `float` in
`tour.mli` but defined as an `int` in `tour.ml`. The last line gives you the
location of the definition in `tour.ml`.

### Why am I seeing all these warnings?

The template code has a lot of unused parameters (because your implementation
will use them). As you implement the functions, you will use these parameters
and the warnings will go away (except for the one saying the `Util` module is
not used).

### How do I figure out which test is failing?

Say, you run the tests for `every_nth` and you see the following output:

```
emre@wintermute 1part1 % dune exec -- ./test.exe test "every_other"
Testing `tour'.
This run has ID `XLRE3P0L'.

  [SKIP]        value of x                                0   x.
  [SKIP]        relu                                      0   relu -1.000000 0.000000.
  [SKIP]        relu                                      1   relu 1.000000 0.000000.
  [SKIP]        relu                                      2   relu 1.000000 5.000000.
  [SKIP]        relu                                      3   relu 8.000000 5.000000.
  [SKIP]        relu                                      4   relu -6.000000 5.000000.
  [SKIP]        relu                                      5   relu 8.000000 -5.000000.
  [SKIP]        relu                                      6   relu 0.000000 5.000000.
> [FAIL]        every_other                               0   every_other.
  [OK]          every_other                               1   every_other.
  [FAIL]        every_other                               2   every_other.
  [FAIL]        every_other                               3   every_other.
...
FAIL every_other

   Expected: `["a"; "c"; "e"]'
   Received: `["e"]'
```

This means that the first, third, and the fourth tests for `every_other` have
failed (you can see the 0-based indices of the failed test: 0, 2, 3). If you look at `test.ml` file, there is a section for testing `every_other`:

```
    "every_other", [
        test_every_other Alcotest.string ["a"; "b"; "c"; "d"; "e"] ["a"; "c"; "e"];
        test_every_other Alcotest.int [] [];
        test_every_other Alcotest.int [1; 2; 4; 8; 4; 2; 1] [1; 4; 4; 1];
        test_every_other Alcotest.int [1; 5; 4; 3] [1; 4];
      ];
```

Here the format of the tests is the function being tested, extra arguments, some
type information, and the expected input and output for the test. So, the first test that failed is test #0, which is:

```
        test_every_other Alcotest.string ["a"; "b"; "c"; "d"; "e"] ["a"; "c"; "e"];
```

Meaning that `every_other` did not produce `["a"; "c"; "e"]` when the tester
gave it the input `["a"; "b"; "c"; "d"; "e"]`. For this first test, the tester
also gave us more useful information at the bottom:

```
FAIL every_other

   Expected: `["a"; "c"; "e"]'
   Received: `["e"]'
```

So, `every_other` returned `["e"]` rather than `["a"; "c"; "e"]` in this case.

### Debugging your implementation with `utop`

If you run `dune utop`, then you will have access to the `Tour` module (the
stuff implemented in `tour.ml`). Then, you can run functions from that module,
like so:

```
emre@wintermute 1part1 % dune utop
────────┬──────────────────────────────────────────────────────────────┬────────
        │ Welcome to utop version 2.10.0 (using OCaml version 4.14.0)! │
        └──────────────────────────────────────────────────────────────┘

Type #utop_help for help about using utop.

─( 21:34:54 )─< command 0 >──────────────────────────────────────{ counter: 0 }─
utop # Tour.is_prime 4 ;;
- : bool = false
─( 21:34:54 )─< command 1 >──────────────────────────────────────{ counter: 0 }─
utop # Tour.is_prime 7 ;;
- : bool = true
```

Typing `Tour.` every time is cumbersome, so you can use `open Tour` to open
(import) the `Tour` module, so that you can directly access the values defined
in it:

```
utop # open Tour;;
─( 21:37:04 )─< command 1 >──────────────────────────────────────{ counter: 0 }─
utop # Tour.is_prime ;;
- : int -> bool = <fun>
```

## Grading

- Your grade is the total number of tests you pass for each function/variable
(see the section above for how to run the tester for each function).
- If you just copy over the tests and add conditionals to match them, you will
get 0 for the assignment.
- If `tour.ml` does not compile with the original files from this repository,
  then you get 0 for the assignment.
- If you see `Test Successful in ... 51 tests run.` at the end of `dune test`,
  you are done with the assignment.
