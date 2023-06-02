counter(0).


      

+voteForIrrigation : pests(N) & N=0
   <- .print("Vote casted on Irrigation:", "normal");
      .send(irrigator, tell, vote("I", 13, high));
      .abolish(voteForIrrigation).

+voteForIrrigation : pests(N) & N=1
   <- .print("Vote casted on Irrigation:", "no");
      .send(irrigator, tell, vote("I", 40, no));
      .abolish(voteForIrrigation).

+voteForIrrigation : pests(N) & N=2
   <- .print("Vote casted on Irrigation:", "normal");
      .send(irrigator, tell, vote("I", 3, normal));
      .abolish(voteForIrrigation).

+voteForIrrigation : pests(N) & N=3
   <- .print("Vote casted on Irrigation:", "high");
      .send(irrigator, tell, vote("I", 30, high));
      .abolish(voteForIrrigation).


+startVotingforSpraying : pests(N) & N=0
	<- .print("Spaying Voting started!");
      .broadcast(tell, voteForSpraying);
      .print("Vote casted on Spraying:", "no");
      .send(pestcontrol, tell, vote("S", 15, no));
      .abolish(startVotingforSpraying).

+startVotingforSpraying : pests(N) & N=1
	<- .print("Spaying Voting started!");
      .broadcast(tell, voteForSpraying);
      .print("Vote casted on Spraying:", "pest1");
      .send(pestcontrol, tell, vote("S", 50, pest1));
      .abolish(startVotingforSpraying).

+startVotingforSpraying : pests(N) & N=2
	<- .print("Spaying Voting started!");
      .broadcast(tell, voteForSpraying);
      .print("Vote casted on Spraying:", "pest1");
      .send(pestcontrol, tell, vote("S", 50, pest2));
      .abolish(startVotingforSpraying).

+startVotingforSpraying : pests(N) & N=3
	<- .print("Spaying Voting started!");
      .broadcast(tell, voteForSpraying);
      .print("Vote casted on Spraying:", "pest2");
      .send(pestcontrol, tell, vote("S", 50, pest2));
      .abolish(startVotingforSpraying).

+vote("S",Weight,Option)  : counter(A) & A=3
   <- countvoteSpraying(Weight, Option);
		-+counter(A-3);
		.abolish(vote("S",_,_)[source(_)]).


+voteForFertilization : pests(N) & N=0    
	<- .print("Vote casted onFertilization:", "normal");
	   .send(fertilizer, tell, vote("F", 2, normal));
	   .abolish(voteForFertilization).

+voteForFertilization : pests(N) & N=1    
	<- .print("Vote casted onFertilization:", "normal");
	   .send(fertilizer, tell, vote("F", 2, normal));
	   .abolish(voteForFertilization).

+voteForFertilization : pests(N) & N=2    
	<- .print("Vote casted onFertilization:", "no");
	   .send(fertilizer, tell, vote("F", 40, no));
	   .abolish(voteForFertilization).

+voteForFertilization : pests(N) & N=3
	<- .print("Vote casted onFertilization:", "normal");
	   .send(fertilizer, tell, vote("F", 13, normal));
	   .abolish(voteForFertilization).

@pb1[atomic]
+vote("S",Weight,Option)  : counter(A) & A<3
   <- countvoteSpraying(Weight, Option);
		-+counter(A+1).