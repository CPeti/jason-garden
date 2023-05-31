//!start.

//growth(0).

+!start : true
   <- .print("Started");
      .send(irrigator,tell,startVotingforIrrigation).
      

+voteForIrrigation : true
   <- .print("Vote casted on Irrigation:", "no");
      .send(irrigator, tell, vote("I", 50, "no"));
      .abolish(voteForIrrigation).
      

+voteForFertilization : true    
	<- .print("Vote casted on Fertilization:", "no");
		.send(fertilizer, tell, vote("F", 100, "no"));
      .abolish(voteForFertilization).

+voteForSpraying : true    
	<- .print("Vote casted on Spraying:","no");
		.send(pestcontrol, tell, vote("S", 100, "no"));
      .abolish(voteForSpraying).