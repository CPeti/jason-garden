//on simulate signal run an auction
+simulate
  <- .print("Starting auction for next action...");
     read_sensors;
     .broadcast(tell, auction(4)).

@pb1[atomic]
+place_bid(N,_)     // receives bids and checks for new winner
   :  .findall(b(V,A),place_bid(N,V)[source(A)],L) &
      .length(L,4)  // all 3 expected bids was received
   <- .max(L,b(V,W));
      .print("Winner is ",W," with ", V);
      .send(W,tell,do_action);
      .abolish(place_bid(_,_)).