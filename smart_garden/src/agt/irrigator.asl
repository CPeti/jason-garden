//water(0).
counter1(0).

//+water(N) : true
//	<- -+water(N).

+startVotingforIrrigation : water(N) & N < 0.35
	<- .print("Irrigation Voting started!");
       .broadcast(tell, voteForIrrigation);
       .print("Vote casted on Irrigation:", "high");
       .send(irrigator, tell, vote("I", 10, high)).

+startVotingforIrrigation : water(N) & N > 0.7
	<- .print("Irrigation Voting started!");
       .broadcast(tell, voteForIrrigation);
	   .print("Vote casted on Irrigation:", "no");
       .send(irrigator, tell, vote("I", 13,no)).

+startVotingforIrrigation : water(N) & N >= 0.35 & N <= 0.70 
	<- .print("Irrigation Voting started!");
       .broadcast(tell, voteForIrrigation);
	   .print("Vote casted on Irrigation:", "normal");
       .send(irrigator, tell, vote("I", 10, normal)).
      

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
	<- .print("Vote casted onFertilization:", "high");
	   .send(fertilizer, tell, vote("F", 7, high));
	   .abolish(voteForFertilization).

+voteForFertilization : water(N) & N > 0.7     
	<- .print("Vote casted onFertilization:", "no");
	   .send(fertilizer, tell, vote("F", 7, no));
	   .abolish(voteForFertilization).

+voteForFertilization : water(N) & N >= 0.35 & N <= 0.70     
	<- .print("Vote casted onFertilization:", "normal");
	   .send(fertilizer, tell, vote("F", 4, normal));
	   .abolish(voteForFertilization).


+voteForSpraying : water(N) & N > 0.7    
	<- .print("Vote casted on Spraying:","no");
	   .send(pestcontrol, tell, vote("S", 10, no));
       .abolish(voteForSpraying).

+voteForSpraying :water(N) & N <= 0.7   
	<- .print("Vote casted on Spraying:","no");
	   .send(pestcontrol, tell, vote("S", 10, no));
       .abolish(voteForSpraying).


      