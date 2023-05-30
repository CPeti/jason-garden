+!startLoop
   <- .print("Loop started!");
      !executeLoop.

+!executeLoop
   <- .print("Loop execution...");
      .wait(5000);  // Wait for 5000 milliseconds (5 seconds)
      !executeLoop.

+!startVotingforIrrigation : true
   <- .print("Irrigation Voting started!");
      .broadcast(percept(IrrigationvotingOptions(["no", "normal","high"]))).
      !castVoteforIrrigation(weight, Option).
      broadcast(percept(voteForIrrigation(weight, Option)))
      
      

+percept(IrrigationvotingOptions(Options))
   : true <- .print("Received voting options:", Options).

+!castVoteforIrrigation(Option) : true
   <- .print("Agent Irrigation casting vote for option:", Option);
      .addVote(weight, Option)


