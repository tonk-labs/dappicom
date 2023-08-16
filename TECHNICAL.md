# DAPPICOM TECHNICAL ROADMAP

## Foundation (v0) [WE ARE HERE]

Foundational work means we put the basic pieces together to make this thing baseline functional (even if impractical). There are a list of issues tracked in this project referenced as "core" work which essentially are necessary to move from the "Foundation" stage to the "CCI Prototype" stage.

## CCI Prototype (alpha)

For context, you can see the [product notes](notes/product.md). In the short term (3-6 months) we are targeting a VERY SLOW zkvm. In practice this means we can't support "live play". Live play means the ability to free play NES games and then prove the play afterwards in a reasonable amount of time.

Since we are working with a VERY SLOW zkvm, the question becomes, "what kind of play does this support?" There is a model for this and it's called "Community Controlled Interfaces (or CCI)" — think "Twitch Plays Pokemon". 

In each round, there some bulk of deliberation or contribution of choice which are all summed together after a round time and used to synthesize one second of gameplay.

The transitions of the machine state each second are "effectively run on chain" through zk proofs.

There is the possibility of launching a several week demo to celebrate.

## Early Product Preview (beta)

How possible is "live play" then? In the [product notes](notes/product.md) there are some back of the napkin sketches on how we might achieve this given the expected gains in performance on proof systems and on this architecture.

If we want to move from the "CCI Prototype" stage to this stage, we are going to need those performance enhancements. This likey will include a great deal of work on the Noir side.

Once we have a reasonably performant Dappicom, we can mark the "early preview" of the final vision as realised. 

Just as before, we can launch a several week demo to celebrate the achievement.

## Release 

This is the mature state of this project. It's when extensions of functionality come into play. There are thoughts around different types of "gameplay" which could be added. Rather than just proving transitions (state a) -> (state b) how could prove fine grained achievements? 

What kind of "meta games" could be composed on top of dappicom? Something like "H-O-R-S-E" in basketball, where someone records a particular playthrough and another person should play within those parameters. 

<br/>
<br/>
<br/>

# Proposed Program Flow

## Emulator
### 1. Player runs the emulator and plays their ROM

This works exactly like normal emulation. However, a proving server will need to know the full state of the machine to prove the play was done correctly. Unfortunately, even for a simply console like the NES this is a lot to send over the wire and the trace can grow quite large.

Instead of directly sending the state of the machine to the proof server, we send a compressed form of a "player input transcript" synced to the clock cycles of the NES machine. 

A player could optionally decide to send this or not (free to play, but pay to prove)

## Engine
### 2. Proving server receives the input transcript and replays the game to generate machine transcript

When the proving server receives a player input transcript, it can queue up a task to prove this transcript. It does that by "replaying" the game locally and generating the full machine transcript.

Running a headless emulator at maximal speed should mean the replay and transcript generation of full state machine will be bottlenecked by disk IO. 

### 3. Proving server transforms the generated machine transcript and feeds it into Noir

The full transcript of this machine is translated into the format required for proof generation. For rough notes on the trace format you can refer to [trace.md](notes/trace.md).

Furthermore, there are multiple starting points in the proof tree, since proving will be done in a kind of "MapReduce" fashion. Some of these proofs require different inputs. 

Some will also require "advice arguments" which are precomputed "answers" to certain computations and used to improve the performance of circuits by simply "constraining the answer" rather than computing the answer fully.

## Engine / Circuits
### 4. Proving server executes the recursive proving tree.

Proofs are run in parallel and then aggregated up the tree into one final proof across the entire transcript. You can see the rough notes on these procedures in the [recursion.md](notes/recursion.md) document.

There is also the question of some "external" state which needs to be tracked and updated. That is, roots of the merkelized memory. We use these roots to track consistency of memory read/writes across transcript boundaries (for transcripts which are very long). In risc zero these are called "continuations", but essentially it allows you to pause/resume proofs across various segments of the full transcript. 

The dumbest way to handle this is to simply update state transitions on chain per segment (rather than bundling the segments together into one even bigger proof)

## Engine / Smart Contracts
### 5. Proving server sends the proof to smart contract verifier

Once we have the final aggregated proof and all public inputs, we can make the transaction to send this on to the verifier on-chain. This part of the program flow has had very little thought put into it, mostly because it's the most well trodden part of the program flow.

The only somewhat tricky bit is (as I see it) is how to efficiently fingerprint machine state in the public inputs so that we can match them to achievements or outcomes on-chain. 

There is also the question of signing or tracking the players wallet and fee structures. I think a lot of these details should be really more specific to the dapp deploying dappicom.

## Emulator / Smart Contracts
### 6. (Optionally) Emulator hydrates machine state based on external data (either in IPFS or onchain)

There is the option of hydrating emulator state from somewhere else. This could be interesting for the progressive reveal of levels in homebrew games custom built for dappicom. 

It could also be used to share state between players (making the game multiplayer somehow).

This particular point in the program lifecycle is very interesting and warrants more thought since we are effectively changing the flow from being one of a a terminal endpoint to that of a feedback loop.