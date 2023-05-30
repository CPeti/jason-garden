

+voteForIrrigation(Options) : true
   <- .print("Vote casted on Irrigation:", Options[2]);
      .send(irrigator, tell, vote("I", 5, "no"));
      .abolish(voteForIrrigation).
      

+voteForIrrigation : true
   <- .print("Vote casted on Irrigation:", "no");
      .send(irrigator, tell, vote("I", 5, "no"));
      .abolish(voteForIrrigation).


+startVotingforSpraying : true
	<- .print("Spaying Voting started!");
      .broadcast(tell, voteForIrrigation(["none", "pest1","pest2","pest3"]));
      .print("Vote casted on Spraying:", "pest1");
      .send(pestcontrol, tell, vote("S", 5, "pest1")).

@pb1[atomic]
+vote("S",Weight,Option)  :true   // receives bids and checks for new winner
   <- countvoteSpraying(Weight, Option).