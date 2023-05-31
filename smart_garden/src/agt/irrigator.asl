//water(0).
counter1(0).

//+water(N) : true
//	<- -+water(N).

+startVotingforIrrigation : water(N) & N < 0.35
	<- .print("Irrigation Voting started!");
       .broadcast(tell, voteForIrrigation);
       .print("Vote casted on Irrigation:", "high");
       .send(irrigator, tell, vote("I", 100, high)).

+startVotingforIrrigation : water(N) & N > 0.7
	<- .print("Irrigation Voting started!");
       .broadcast(tell, voteForIrrigation);
	   .print("Vote casted on Irrigation:", "no");
       .send(irrigator, tell, vote("I", 500,no)).

+startVotingforIrrigation : water(N) & N >= 0.35 & N <= 0.70 
	<- .print("Irrigation Voting started!");
       .broadcast(tell, voteForIrrigation);
	   .print("Vote casted on Irrigation:", "no");
       .send(irrigator, tell, vote("I", 500, no)).
      

+vote("I",Weight,Option)  : counter1(A) & A=3
   <- countvoteIrrigation(Weight, Option);
	  -+counter1(A-3);
	  .abolish(vote("I",_,_)[source(_)]);
	  .send(fertilizer,tell,startVotingforFertilization).


@pb1[atomic]
+vote("I",Weight,Option)  : counter1(A) & A<3
   <- countvoteIrrigation(Weight, Option);
	  -+counter1(A+1).
	  
      

+voteForFertilization :   water(N) & N < 0.35   
	<- .print("Vote casted onFertilization:", "no");
	   .send(fertilizer, tell, vote("F", 2, normal));
	   .abolish(voteForFertilization).

+voteForFertilization : water(N) & N > 0.7     
	<- .print("Vote casted onFertilization:", "no");
	   .send(fertilizer, tell, vote("F", 10, high));
	   .abolish(voteForFertilization).

+voteForFertilization : water(N) & N >= 0.35 & N <= 0.70     
	<- .print("Vote casted onFertilization:", "no");
	   .send(fertilizer, tell, vote("F", 10, normal));
	   .abolish(voteForFertilization).


+voteForSpraying : water(N) & N > 0.7    
	<- .print("Vote casted on Spraying:","no");
	   .send(pestcontrol, tell, vote("S", 10, no));
       .abolish(voteForSpraying).

+voteForSpraying :water(N) & N <= 0.7   
	<- .print("Vote casted on Spraying:","no");
	   .send(pestcontrol, tell, vote("S", 10, no));
       .abolish(voteForSpraying).


      