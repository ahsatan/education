(* Shadowing *)

val a = 10;
(* a : int *)
(* a -> 10 *)

val b = a * 2;
(* a : int, b : int *)
(* a -> 10, b -> 20 *)

val a = 5;
(* a : int, b : int, a : int *)
(* a -> 10, b -> 20, a -> 5 *)

val c = b;
(* a : int, b : int, a: int, c : int *)
(* a -> 10, b -> 20, a -> 5, c -> 20 *)

val d = a;
(* a : int, b : int, a: int, c : int, d : int *)
(* a -> 10, b -> 20, a -> 5, c -> 20, d -> 5 *)

val a = a + 1;
(* a : int, b : int, a: int, c : int, d : int, a : int *)
(* a -> 10, b -> 20, a -> 5, c -> 20, d -> 5, a -> 6 *)

val f = a * 2;
(* a : int, b : int, a: int, c : int, d : int, a : int, f : int *)
(* a -> 10, b -> 20, a -> 5, c -> 20, d -> 5, a -> 6, f -> 12 *)
