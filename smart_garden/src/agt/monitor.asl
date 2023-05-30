+percept(receiveVoteForIrrigation(Options)) : true
   <- .print("Vote casted on Irrigation:", Options[1]);
      .send(irrigator, tell, vote("I", 5, Options[1])).