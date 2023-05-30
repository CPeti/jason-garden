+!start : true
   <- .print("Started");
      [startVotingforIrrigation].

+startVotingforIrrigation : true
   <- .print("Irrigation Voting started!");
      .broadcast(percept(voteForIrrigation(["no", "normal","high"]))).
      
      
+vote("I",Weight,Option)  :true   // receives bids and checks for new winner
   <- countvote(Weight,Option);
      .findall(A,vote("I",V,Opt)[source(A)],L) &
      .length(L,4); // all 4 expected bids was received
      [findWinner].
      



+percept(receiveVoteForIrrigation(Options)) : true
   <- .print("Vote casted on Irrigation:", Options[1]);
      .send(irrigator, tell, vote("I", 100, Options[1])).


+findWinner : true
   <- .findall(Num, vote_count(_, Num), Numlist) &
      .length(L,4);
      .max(Numlist, Max);
      ?vote_count(Option, Max);
      .println("Winner is ", Option);
      .abolish(vote_count(_,_));
      .abolish(vote("I",_,_)).
    

+countvote(Option, Weight) : true
   <- ?vote_count(Option, Count);
      NewCount = Count + Weight;
      -vote_count(Option, Count);
      +vote_count(Option, NewCount).

      