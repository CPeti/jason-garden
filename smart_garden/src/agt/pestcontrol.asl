counter(0).


      

+voteForIrrigation : true
   <- .print("Vote casted on Irrigation:", "no");
      .send(irrigator, tell, vote("I", 5, "no"));
      .abolish(voteForIrrigation).


+startVotingforSpraying : true
	<- .print("Spaying Voting started!");
      .broadcast(tell, voteForSpraying);
      .print("Vote casted on Spraying:", "pest1");
      .send(pestcontrol, tell, vote("S", 5, "pest1"));
      .abolish(startVotingforSpraying).

+vote("S",Weight,Option)  : counter(A) & A=3
   <- countvoteSpraying(Weight, Option);
		-+counter(A-3);
		.abolish(vote("S",_,_)[source(_)]).


+voteForFertilization : true    
	<- .print("Vote casted onFertilization:", "no");
	   .send(fertilizer, tell, vote("F", 100, "no"));
	   .abolish(voteForFertilization).

@pb1[atomic]
+vote("S",Weight,Option)  : counter(A) & A<3
   <- countvoteSpraying(Weight, Option);
		-+counter(A+1).