+!startLoop
   <- .print("Loop started!");
      !executeLoop.

+!executeLoop
   <- .print("Loop execution...");
        .send(pestcontrol, tell, growth);
      .wait(5000);  // Wait for 5000 milliseconds (5 seconds)
      !executeLoop.


+percept(recieveVoteForIrrigation(Options)): true
   <- .print("Vote casted on Irrigation:", Option);
      sendMessage(irrigation, percept(voteFromAgentB(weight, Chosen))).