//water(0).
counter(0).

//+water(N) : true
//	<- -+water(N).

+startVotingforIrrigation : water(N) & N < 0.5
	<- .print("Irrigation Voting started!");
      .broadcast(tell, voteForIrrigation);
      .print("Vote casted on Irrigation:", "high");
      .send(irrigator, tell, vote("I", 100, "high")).

+startVotingforIrrigation : water(N) & N > 0.5
	<- .print("Irrigation Voting started!");
      .broadcast(tell, voteForIrrigation);
		.print("Vote casted on Irrigation:", "no");
      .send(irrigator, tell, vote("I", 500, "no")).
      

+vote("I",Weight,Option)  : counter(A) & A=3
   <- countvoteIrrigation(Weight, Option);
		.print("Abolishing!!!!!!", Options[1]);
		-+counter(A-3);
		.abolish(vote("I",_,_)[source(_)]).


@pb1[atomic]
+vote("I",Weight,Option)  : counter(A) & A<3
   <- countvoteIrrigation(Weight, Option);
		-+counter(A+1).
	  
      

+voteForFertilization(Options) : true    
	<- .print("Vote casted onFertilization:", Options[1]);
		.send(fertilizer, tell, vote("F", 100, Options[1])).

+voteForSpraying(Options) : true    
	<- .print("Vote casted on Spraying:", Options[1]);
		.send(pestcontrol, tell, vote("S", 100, Options[1])).

      