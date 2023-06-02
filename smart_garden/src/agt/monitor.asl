//!start.

//growth(0).

+!start : true
   <- .print("Started");
      .send(irrigator,tell,startVotingforIrrigation).
      

+voteForIrrigation : growth(N) & N< 0.2
   <- .print("Vote casted on Irrigation:", "high");
      .send(irrigator, tell, vote("I", 12, high));
      .abolish(voteForIrrigation).

+voteForIrrigation : growth(N) & N>= 0.2 & N <= 0.7
   <- .print("Vote casted on Irrigation:", "normal");
      .send(irrigator, tell, vote("I", 10, high));
      .abolish(voteForIrrigation).

+voteForIrrigation : growth(N) & N > 0.7
   <- .print("Vote casted on Irrigation:", "no");
      .send(irrigator, tell, vote("I", 10, normal));
      .abolish(voteForIrrigation).
      

+voteForFertilization : growth(N) & N< 0.2
	<- .print("Vote casted on Fertilization:", "high");
		.send(fertilizer, tell, vote("F", 12, high));
      .abolish(voteForFertilization).

+voteForFertilization :  growth(N) & N>= 0.2 & N <= 0.6    
	<- .print("Vote casted on Fertilization:", "high");
		.send(fertilizer, tell, vote("F", 12, high));
      .abolish(voteForFertilization).

+voteForFertilization : growth(N) & N > 0.6    
	<- .print("Vote casted on Fertilization:", "normal");
		.send(fertilizer, tell, vote("F", 4, normal));
      .abolish(voteForFertilization).

+voteForSpraying : growth(N) & N< 0.2    
	<- .print("Vote casted on Spraying:","no");
		.send(pestcontrol, tell, vote("S", 1, no));
      .abolish(voteForSpraying).
      
+voteForSpraying :  growth(N) & N>= 0.2 & N <= 0.6    
	<- .print("Vote casted on Spraying:","high");
		.send(pestcontrol, tell, vote("S", 5, no));
      .abolish(voteForSpraying).

+voteForSpraying : growth(N) & N > 0.6   
	<- .print("Vote casted on Spraying:","normal");
		.send(pestcontrol, tell, vote("S", 10, no));
      .abolish(voteForSpraying).