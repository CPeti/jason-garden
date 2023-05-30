//fertilizer(0).

+voteForIrrigation(Options) : true
   <- .print("Vote casted on Irrigation:", Options[1]);
      .send(irrigator, tell, vote("I", 5, "no")).


+voteForFertilization(Options) : true    
	<- .print("Vote casted on Fertilization:", Options[1]);
		.send(irrigator, tell, vote("F", 100, Options[1])).

+voteForSpraying(Options) : true    
	<- .print("Vote casted on Spraying:", Options[1]);
		.send(irrigator, tell, vote("S", 100, Options[1])).


+startVotingforFertilization : true
	<- .print("Fertilization Voting started!");
      .broadcast(tell, voteForIrrigation(["no", "normal","high"]));
      .print("Vote casted on Spraying:", Options[2]);
      .send(irrigator, tell, vote("S", 5, Options[2])).

@pb1[atomic]
+vote("F",Weight,Option)  :true   // receives bids and checks for new winner
   <- countvoteFertilization(Weight, Option).

