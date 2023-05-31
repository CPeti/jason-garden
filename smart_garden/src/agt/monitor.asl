+auction(N)[source(S)] : true
   <- ?growth(G);
      .send(S, tell, place_bid(N,G));
      .abolish(auction(_)).

+do_action
    <- harvest;
    .abolish(do_action).
