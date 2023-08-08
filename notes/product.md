## Client operation

The NES processor ran at a freq of ~1.7Mhz, if we assume average of 3 cycles/instruction and about ~75B added to the trace / instruction then we will have to deal with 37.5MB/s in I/O — obviously way too heavy for the client. What instead we can do is record user input in a compressed way and sync it to the clock cycles of the emulator. Then we feed that user input back to a headless emulator "re-running" the game. This means the emulator would also need to download the ROM somehow. Perhaps the user could reference a shared ROM at some location (in the example of free homebrew games).

## Code Structure

That means in addition to the prover (circuits) and the emulator (tetanes) we will also need a client/server library. I leave this here as a marker of that work to be done.


