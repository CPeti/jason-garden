@lbid
+auction(N)[source(S)] : true
   <- ?water(W);
      .send(S, tell, place_bid(N,W));
      .abolish(auction(_)).

+do_action
    <- water;
    .abolish(do_action).