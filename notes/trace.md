# Execution Trace

Things we need to account for:
- Memory Mappers (aim to support #1 and #4 to start) ~512K max
- PPU writes/reads  
- Addressing Modes
- Mirroring
- Machine State (PC, registers, stack, status)
- Joypads
- Timing of CPU cycles
  

## Memory normalization
- de-duplication of the mirrors
- expansion of cartridge memory maps
- writes and reads to PPU and APU registers unconstrained on memory only (in the trace, we can precede every read with a dummy write)
- Joypad reads preceded by dummy writes


## Emulator behavior:

We want to sort the state of machine + RAM by opcodes, so the easiest way to do this is to track it in the emulator. When we write out the trace, we have sets of opcodes and indexed ranges into the trace for each set. This can be used by a separate program to format the input into our circuits.

To start, we stop the program execution every second, print out the trace, and then wait for a key command before continuing. 

In the future, we could simply serialize and push to a separate thread inbetween renders as the NES runs much slower than modern CPUs.

Address modes maybe can use a pure opcode execution trace as advice arguments?
The state machine operates only on memory, but uses the opcode execution trace to simplify the constraints?


## Possible trace format

Memory Trace: (step, addr, val, op_rw)

Step should be incremented every time there is a read or write operation

If there is a read or write to a mirror, we just change it to read/write from the source. This means memory space 0x0800 - 0x1FFF is effectively unused by the CPU. Why do we want unused memory space? It saves us on hashing page retrievals in the prover. If we can cluster the memory accesses, then we'll have less pages to retrieve and hash for the continuations.

0x0100-0x01FF is where the 256-bytes of stack exist

We do the same with NES PPU registers, it's simply the registers 0x2000-0x2007 and we fill these with dummy writes. Any reads/writes to the mirrors are rewritten in the trace. This makes 0x2008 - 0x3FFF unused — howver, we will now use 0x2008 - 0x200D for the registers. Those will be written to the trace using symbols which are then converted by a reformatting script (which feeds the trace into the prover).

We do the same with NES APU registers, 0x4000 - 0x4015 filled with dummy writes

The joypad registers 0x4016 and 0x4017 filled with dummy writes

0x4018 - 0x401F is unused

0x4020 - 0xFFFF PRG ROM

We expand out memory that is memory mapped by translating all the banks into a large memory space.

The CPU registers A, X, Y, Program Counter, Stack Pointer, and Status Register can occupy memory space in the unused portion 0x4018 - 0x401F

// these will be used often and should exist in commonly accessed "page"
//if we put it near the PPU registers, it should fit within one page for all the reads/writes to PPU during vblank/hblank
A = 0x2008
X = 0x2009
Y = 0x200A
PC = 0x200B
SP = 0x200C
SR = 0x200D

The program will output the memory trace during execution by cycle

The execution trace can simply be opcode (enum), addressing mode (enum), start, end range in the output memory trace


## Final Format

We should be able to use this information to create an address-cycle sorted list of tuples and an opcode cycle sorted and segmented list of tuples. These inputs are formatted from partitions of the original trace. A merkle tree hash of memory "pages" is computed for the beginning and end of each segment. We will also need to keep track of some "dirty" bits to know which pages have been written over and need to be recomputed.




