# Dappicom — NES Emulation in Noir

Dappicom is a provable Nintendo Entertainment System emulator written in Noir and Rust. Practically, this is a zkvm which supports the MOS 6502 instruction set. The zkvm is built in Noir (we heard you liked zkvms, so we put a zkvm in your zkvm).

This project is in its early stages. The architecture is likely to change somewhat and is presently meant to be illustrative of what the eventual architecture may look like moving forward.

## What does that mean?
Hopefully, it means you can play NES ROMs on your local machine and then prove outcomes of that gameplay onchain to trigger downstream rewards/consequences. That's the end goal.

Furthermore, your gameplay will be proven in zero-knowledge. In essence, you can prove that you achieved a particular in-game milestone, without revealing exactly how you did so.

##  Why are you doing this?
1. Because it's fun!
2. This is a great way to make discoveries about performant zkvm design, especially in the context of onchain games. Good zkvm design is important both for twitchy gamefeel for fully onchain games, and also to facilitate hidden information. Neither of these are trivially possible within a vanilla blockchain execution environment.
3. The MOS 6502 processor is beautiful and historically significant. While this project aims to emulate the NES, one can adapt it to play games from other computer systems which used the MOS 6502 (Commodore 64, Apple II etcetera). 
4. There is a homebrew community which still writes programs for these systems. We are interested to see what happens when you blend retro gaming with onchain "metagame" affordances. 


## How does it work?

All gameplay happens as it would in a normal emulator. The emulation is performed locally on your machine and simulates the behavior of the MOS 6502 processor. What is different about this emulator compared to the others is that it will record a transcript of its execution. This transcript of execution will then be sent to a proving service to determine if the machine executed correctly.

At the moment, we have some examples to illustrate what that might look like in Noir.

- [permcheck](circuits/cpu/src/permcheck.nr)
- [opcodes](circuits/opcodes/src)

In our emulator, we need to ensure that the reads and writes to memory are consistent across the entire transcript. How might we do this? Well, it's simple. We just sort the memory by address and linearly run through each address to make sure all writes are preceded by matching reads. However, we still need memory sorted by time to check the transitions of the machine state. This means we have two tasks — check transitions of machine state by looking at the original transcript (time ordered) and check the memory consistency of the machine state by looking at a modified transcript (address ordered). The remaining problem is proving that these two transcripts are the same.

To do this, we are considering permutation checks — these just check if two sets of different order have the same elements. Permcheck.nr is an example of a multiset equality check procedure described in Justin Thaler's ProofsArgsAndZK. This probabilistic procedure is a modification of Reed-Solomon fingerprinting which is indifferent to the ordering of the elements in the vector. 

However, the NES emulator's CPU runs at ~1.7 Mhz and may address 64KB of memory. This presents a challenge, namely, that our transcript is generates millions of reads and writes every second. Running a permutation check inside Noir for the entire transcript, at once, is infeasible.

Furthermore, the permutation check requires a random challenge. Since we do not want the proving to be interactive, we need to compute a random challenge using Fiat-Shamir — that is, the challenge is computed from a hash of the elements. 

We need to leverage recursion. 

Ideally, we would be able to create a recursive tree where the transcript is segmented. Each segment is proven and then recursively combined into a single proof.

The motivation behind the permutation check is the fact that it is trivially parallelizable - as it's simply the product of each element, minus the random challenge. However, computing the random challenge in a recursive manner is less straightforward. My first thought is that it may be possible to rollup segmented runs of hashing up to the root as a k-ary merkle tree in order to recursively compute the random challenge. This root will be the random challenge. We will first compute the random challenge outside of Noir and then simply verify that it was correctly computed at the final recursive step. This recursive structure more-or-less fits that of the permutation check.

Finally, this only proves 1s of gameplay. If we want to allow for unbounded gameplay we will need to snapshot memory somehow and ensure its consistency across each transcript output each second. It's essentially the same problem, but if we use the same techniques our permutation checks and merkle tree will grow too big.

My initial thought was to simply modify the transcript to include a separate "cross transcript" memory consistency check, where the processor outputs a memory dump at the beginning and end of each transcript. We can hash this memory dump and compare it with a value saved somewhere in the smart contract (for example). I don't really like this (it seems a bit hacky).

Understanding that we are already using merkle trees to fingerprint the memory across discrete transcripts, this bears similarity to Risc Zero's "continuations" and I am interested to adapt those techniques to perhaps simplify the construction here.

As I've said, this project is largely illustrative as the eventual architecture remains open.

## How to run

The NES emulator is written in Rust. At the moment it's only emulating the MOS 6502 instruction set. You can test a simple game of snake by running the following inside the [/com](/com) folder.
```
cargo build
cargo run
```

The Noir circuits have tests written for them, that you can run by [installing Noir](https://noir-lang.org/getting_started/nargo_installation) and then in the [/circuits/cpu](/circuits/cpu/) or [/circuits/opcodes](/circuits/opcodes/) folder running
```
nargo test
```

## Credits

I want to thank bugzmanov for their wonderful [write-up](https://bugzmanov.github.io/nes_ebook/index.html) on NES emulation in Rust and provided example code. 

This project is funded by an Aztec grant. Without them it wouldn't happen :)
