//fertilizer(0).
counter2(0).

+voteForIrrigation : fertilizer(N) & N < 0.2
   <- .print("Vote casted on Irrigation:", "no");
      .send(irrigator, tell, vote("I", 99, no));
      .abolish(voteForIrrigation).

+voteForIrrigation : fertilizer(N) & N <= 0.6 & N >= 0.2
   <- .print("Vote casted on Irrigation:", "no");
      .send(irrigator, tell, vote("I", 99, no));
      .abolish(voteForIrrigation).

+voteForIrrigation : fertilizer(N) & N > 0.6
   <- .print("Vote casted on Irrigation:", "no");
      .send(irrigator, tell, vote("I", 99, no));
      .abolish(voteForIrrigation).
      


+voteForSpraying : fertilizer(N)   & N<0.3
	<- .print("Vote casted on Spraying:","no");
	   .send(pestcontrol, tell, vote("S", 10, no));
      .abolish(voteForSpraying).

+voteForSpraying : fertilizer(N)   &  N > 0.3 & N < 0.67
	<- .print("Vote casted on Spraying:","no");
	   .send(pestcontrol, tell, vote("S", 10, no));
      .abolish(voteForSpraying).

+voteForSpraying : fertilizer(N)   &   N > 0.67 
	<- .print("Vote casted on Spraying:","no");
	   .send(pestcontrol, tell, vote("S", 10, no));
      .abolish(voteForSpraying).


+startVotingforFertilization : fertilizer(N)   & N < 0.3
	<- .print("Fertilization Voting started!");
      .broadcast(tell, voteForFertilization);
      .print("Vote casted on Fertil:", "no");
      .send(fertilizer, tell, vote("F", 5, no));
		.abolish(startVotingforFertilization).

+startVotingforFertilization : fertilizer(N)   & N > 0.3 & N < 0.67
	<- .print("Fertilization Voting started!");
      .broadcast(tell, voteForFertilization);
      .print("Vote casted on Fertil:", "no");
      .send(fertilizer, tell, vote("F", 5, no));
		.abolish(startVotingforFertilization).

+startVotingforFertilization : fertilizer(N) & N > 0.67
	<- .print("Fertilization Voting started!");
      .broadcast(tell, voteForFertilization);
      .print("Vote casted on Fertil:", "no");
      .send(fertilizer, tell, vote("F", 5, no));
		.abolish(startVotingforFertilization).

+vote("F",Weight,Option)  : counter2(A) & A=3
   <- countvoteFertilization(Weight, Option);
		-+counter2(A-3);
		.abolish(vote("F",_,_)[source(_)]);
		.send(pestcontrol,tell,startVotingforSpraying).


@pb1[atomic]
+vote("F",Weight,Option)  : counter2(A) & A<3
   <- countvoteFertilization(Weight, Option);
		-+counter2(A+1).


