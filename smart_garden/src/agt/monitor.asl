!start.

//growth(0).

+!start : true
   <- .print("Started");
      .send(irrigator,tell,startVotingforIrrigation).

+voteForIrrigation(Options) : true
   <- .print("Vote casted on Irrigation:", Options[1]);
      .send(irrigator, tell, vote("I", 5, Options[1])).

+voteForFertilization(Options) : true    
	<- .print("Vote casted on Fertilization:", Options[1]);
		.send(fertilizer, tell, vote("F", 100, Options[1])).

+voteForSpraying(Options) : true    
	<- .print("Vote casted on Spraying:", Options[1]);
		.send(pestcontrol, tell, vote("S", 100, Options[1])).