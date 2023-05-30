//water(0).


//+water(N) : true
//	<- -+water(N).

+startVotingforIrrigation : water(N) & N < 0.5
	<- .print("Irrigation Voting started!");
      .broadcast(tell, voteForIrrigation(["no", "normal","high"]));
      .print("Vote casted on Irrigation:", "high");
      .send(irrigator, tell, vote("I", 100, "high")).

+startVotingforIrrigation : water(N) & N > 0.5
	<- .print("Irrigation Voting started!");
      .broadcast(tell, voteForIrrigation(["no", "normal","high"]));
      .send(irrigator,tell, voteForIrrigation(["no", "normal","high"]));
		.print("Vote casted on Irrigation:", "no");
      .send(irrigator, tell, vote("I", 500, "no")).
      
@pb1[atomic]
+vote("I",Weight,Option)  :true   // receives bids and checks for new winner
   <- countvoteIrrigation(Weight, Option).
      
      

+voteForFertilization(Options) : true    
	<- .print("Vote casted onFertilization:", Options[1]);
		.send(fertilizer, tell, vote("F", 100, Options[1])).

+voteForSpraying(Options) : true    
	<- .print("Vote casted on Spraying:", Options[1]);
		.send(pestcontrol, tell, vote("S", 100, Options[1])).

      