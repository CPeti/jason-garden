!start.

+!start : true
   <- .print("Started");
      .send(irrigator,tell,startVotingforIrrigation).

+percept(receiveVoteForIrrigation(Options)) : true
   <- .print("Vote casted on Irrigation:", Options[1]);
      .send(irrigator, tell, vote("I", 5, Options[1])).