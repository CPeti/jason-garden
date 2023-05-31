//!start.

//growth(0).

+!start : true
   <- .print("Started");
      .send(irrigator,tell,startVotingforIrrigation).
      

+voteForIrrigation : growth(N) & N< 0.2
   <- .print("Vote casted on Irrigation:", "no");
      .send(irrigator, tell, vote("I", 50, high));
      .abolish(voteForIrrigation).

+voteForIrrigation : growth(N) & N> 0.2 & N < 0.7
   <- .print("Vote casted on Irrigation:", "no");
      .send(irrigator, tell, vote("I", 50, normal));
      .abolish(voteForIrrigation).

+voteForIrrigation : growth(N) & N > 0.7
   <- .print("Vote casted on Irrigation:", "no");
      .send(irrigator, tell, vote("I", 50, no));
      .abolish(voteForIrrigation).
      

+voteForFertilization : growth(N) & N< 0.2
	<- .print("Vote casted on Fertilization:", "no");
		.send(fertilizer, tell, vote("F", 12, high));
      .abolish(voteForFertilization).

+voteForFertilization :  growth(N) & N> 0.2 & N < 0.6    
	<- .print("Vote casted on Fertilization:", "no");
		.send(fertilizer, tell, vote("F", 10, normal));
      .abolish(voteForFertilization).

+voteForFertilization : growth(N) & N > 0.6    
	<- .print("Vote casted on Fertilization:", "no");
		.send(fertilizer, tell, vote("F", 4, normal));
      .abolish(voteForFertilization).

+voteForSpraying : growth(N) & N< 0.2    
	<- .print("Vote casted on Spraying:","no");
		.send(pestcontrol, tell, vote("S", 1, no));
      .abolish(voteForSpraying).
      
+voteForSpraying :  growth(N) & N> 0.2 & N < 0.6    
	<- .print("Vote casted on Spraying:","high");
		.send(pestcontrol, tell, vote("S", 5, no));
      .abolish(voteForSpraying).

+voteForSpraying : growth(N) & N > 0.6   
	<- .print("Vote casted on Spraying:","normal");
		.send(pestcontrol, tell, vote("S", 10, no));
      .abolish(voteForSpraying).