//water(0).
counter1(0).

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
      

+vote("I",Weight,Option)  : counter1(A) & A=3
   <- countvoteIrrigation(Weight, Option);
	  -+counter1(A-3);
	  .abolish(vote("I",_,_)[source(_)]);
	  .send(fertilizer,tell,startVotingforFertilization).


@pb1[atomic]
+vote("I",Weight,Option)  : counter1(A) & A<3
   <- countvoteIrrigation(Weight, Option);
	  -+counter1(A+1).
	  
      

+voteForFertilization : true    
	<- .print("Vote casted onFertilization:", "no");
	   .send(fertilizer, tell, vote("F", 1000, "no1"));
	   .abolish(voteForFertilization).

+voteForSpraying : true    
	<- .print("Vote casted on Spraying:","no");
	   .send(pestcontrol, tell, vote("S", 100, "no"));
       .abolish(voteForSpraying).

      