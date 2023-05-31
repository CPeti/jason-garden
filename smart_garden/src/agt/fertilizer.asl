+auction(N)[source(S)] : true
   <- ?nutrients(Nt);
      .send(S, tell, place_bid(N,Nt));
      .abolish(auction(_)).

+do_action
    <- fertilize;
    .abolish(do_action).
