+percept(receiveVoteForIrrigation(Options)) : true
   <- .print("Vote casted on Irrigation:", Options[2]);
      .send(irrigator, tell, vote("I", 5, Options[2])).