## Product definition as a function of its performance

### Short term
It's unclear how many opcodes we can process at a time, but let's assume one opcode is given 21 steps. The average opcode takes ~4 cycles. That's ~5 steps / cycle. That translates to about 8.5M steps/s (CPU is ~1.7 Mhz). If we're limited to ~128-256 steps/proof and the proof generation time is somewhere between 10-20seconds, then we are looking at days of time to prove a second.

Now, what we can do to try and speed this up is first assume there is work to be done to shave down constants (both on Noir side and on circuit FE). Let's say we get a 6x factor speedup with some gate golfing and Noir improvements. That's ~1000 steps/proof at 10-20s/proof. We also will be parallelizing this and by keeping each proof to smaller circuits, we can run them on many small machines. Assuming 80 machines @ 0.03$/hr AWS prices is ~2k/mo to run one game very slowly. 80 machines then split across opcodes and memory proving effectively means we get 2000-4000 steps/s (40k steps/10-20s). That translates to each 1s of gameplay taking about 30-60min to prove. 

This is a relatively conservative estimate, in my view. What this does, however, is allow us to run an experiment of an "onchain" NES game in the "twitch plays pokemon" style. Individuals can contribute 1s of gameplay using some type of "meta." We could leave this experiment running for 1 month @ 2k$. All seems perfectly feasible.

### Long term
As the NES processor ran at a freq of ~1.7Mhz, if we assume average of 4 cycles/instruction and about ~75B added to the trace / instruction then we will have to deal with ~32MB/s in I/O — obviously way too heavy for the client. What instead we can do is record user input in a compressed way and sync it to the clock cycles of the emulator. Then we feed that user input back to a headless emulator "re-running" the game. NOTE: this does mean the emulator would also need to download the ROM somehow. Perhaps the user could reference a shared ROM at some location (in the example of free homebrew games).

However, this bottleneck is all assuming we can get the proof times down on the backend. Now, I think in order to achieve this we really need to switch to a backend which can bring down constants heavily for each operation in the proof generation. That could be something Nova-based or more simply STARK based. This backend doesn't currently exist, so it would need to be implemented and that is a task in and of itself.

In addition, with the help of more eyeballs and some time testing, we may identify ways to save on constraints if we bypass the FE entirely for many operations using custom builtins.

Altogether, if we're optimistic and assume several orders of magnitude speedup, worst case 10k steps/s to best case 1M steps/s. That's just with one proof. If we parallelize to 80 machines we can then get somewhere in the ballpark of 800k steps/s to 80M steps/s. The median puts us in the range of realtime proving. Also considering Risc Zero recently boasted 2Mhz speed using 100 GPUs. We can say that with enough time and patience, we can get to nearly a 1-1 playtime / proving time. 

This obviously would cost $$$ for the time on the hardware. Why would you do this? Well, I can think of speedruns or special achievements which unlock other things of value. What's $10-30 to get a rare badge or to prove you are #1 on the speedrun leaderboard?

## Work currently not represented in this repositories code structure

**client-server library** —  in addition to the prover (circuits) and the emulator (tetanes) we will also need a client/server library to send down the moves of the player to the proving server

**custom backend** — A nova-based backend or STARK backend would need to be a separate project. For now we will focus on the short term goals of just getting the dang thing workin'.



