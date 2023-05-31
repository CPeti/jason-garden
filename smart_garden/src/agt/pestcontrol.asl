+auction(N)[source(S)] : true
   <- ?pests(P);
      .send(S, tell, place_bid(N,P));
      .abolish(auction(_)).

+do_action
    <- spray;
    .abolish(do_action).