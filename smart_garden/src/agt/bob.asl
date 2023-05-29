// Agent bob in project smart_garden

/* Initial beliefs and rules */

/* Initial goals */

//!start.

/* Plans */

//+!start : true <- .print("hello world.").
+hello[source(A)]
  <- .print("I receive an hello from ",A);
     .send(A,tell,hello).
