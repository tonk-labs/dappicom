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

Address modes maybe can use a pure opcode execution trace as advice arguments?
The state machine operates only on memory, but uses the opcode execution trace to simplify the constraints?


## Possible trace format

Memory trace
0x0000
