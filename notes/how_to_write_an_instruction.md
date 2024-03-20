# How to add an opcode

The key thing to writing an opcode is to understand the transcript output by the emulator during correct execution. We are simply verifying the boundary conditions and everything in between for all correct execution. However, at the moment, there's no functionality to generate test transcripts from the emulator so the next best thing is to step through the trace in your head by reading the emulator code. There are a three things to know about the trace which will help you to do this.

1. The trace is written out exclusively as memory reads and writes. The file [dappicom/emulator/src/bus.rs](/emulator/src/bus.rs) handles all reading and writing to memory, so this is also the same file where we manage the trace. Everytime there is a read or write in the bus, we will write it to the trace. You can check the file and verify it for yourself.
2. In the trace, the registers are represented as addressable memory cells. In the file [dappicom/emulator/src/cpu.rs](/emulator/src/cpu.rs) You can see getter and setter functions. In these functions you can see the trace is updated in each getter and setter function. This doesn't prevent any function from modifying the properties directly (and this does happen in certain places). You will have to understand that when the function is used, it updates the trace of the register, but when the property is accessed directly it does not update the trace.
3. The trace fed into each opcode circuit is a concatenated list of all the reads and writes of that instruction in order of the opcode execution. For each segment, if none of the instructions opcodes were executed or if there were less reads/writes than input size for the circuit, the trace will pad the end with a value to indicate that we should simply constrain a single constant value for those values (constrain to pad values).

Knowing this information you can then take a look at the [dappicom/emulator/src/cpu/instr.rs](/emulator/src/cpu/instr.rs) file as a jumping off point to understand how each instruction is being executed. At the top, you can see
```
    #[rustfmt::skip]
    pub const INSTRUCTIONS: [Instr; 256] = [
        Instr(0x00, IMM, BRK, 7), Instr(0x01, IDX, ORA, 6), Instr(0x02, IMP, XXX, 2), Instr(0x03, IDX, SLO, 8), Instr(0x04, ZP0, NOP, 3), Instr(0x05, ZP0, ORA, 3), Instr(0x06, ZP0, ASL, 5), Instr(0x07, ZP0, SLO, 5), Instr(0x08, IMP, PHP, 3), Instr(0x09, IMM, ORA, 2), Instr(0x0A, ACC, ASL, 2), Instr(0x0B, IMM, ANC, 2), Instr(0x0C, ABS, NOP, 4), Instr(0x0D, ABS, ORA, 4), Instr(0x0E, ABS, ASL, 6), Instr(0x0F, ABS, SLO, 6),
        Instr(0x10, REL, BPL, 2), Instr(0x11, IDY, ORA, 5), Instr(0x12, IMP, XXX, 2), Instr(0x13, IDY, SLO, 8), Instr(0x14, ZPX, NOP, 4), Instr(0x15, ZPX, ORA, 4), Instr(0x16, ZPX, ASL, 6), Instr(0x17, ZPX, SLO, 6), Instr(0x18, IMP, CLC, 2), Instr(0x19, ABY, ORA, 4), Instr(0x1A, IMP, NOP, 2), Instr(0x1B, ABY, SLO, 7), Instr(0x1C, ABX, IGN, 4), Instr(0x1D, ABX, ORA, 4), Instr(0x1E, ABX, ASL, 7), Instr(0x1F, ABX, SLO, 7),
        Instr(0x20, ABS, JSR, 6), Instr(0x21, IDX, AND, 6), Instr(0x22, IMP, XXX, 2), Instr(0x23, IDX, RLA, 8), Instr(0x24, ZP0, BIT, 3), Instr(0x25, ZP0, AND, 3), Instr(0x26, ZP0, ROL, 5), Instr(0x27, ZP0, RLA, 5), Instr(0x28, IMP, PLP, 4), Instr(0x29, IMM, AND, 2), Instr(0x2A, ACC, ROL, 2), Instr(0x2B, IMM, ANC, 2), Instr(0x2C, ABS, BIT, 4), Instr(0x2D, ABS, AND, 4), Instr(0x2E, ABS, ROL, 6), Instr(0x2F, ABS, RLA, 6),
        Instr(0x30, REL, BMI, 2), Instr(0x31, IDY, AND, 5), Instr(0x32, IMP, XXX, 2), Instr(0x33, IDY, RLA, 8), Instr(0x34, ZPX, NOP, 4), Instr(0x35, ZPX, AND, 4), Instr(0x36, ZPX, ROL, 6), Instr(0x37, ZPX, RLA, 6), Instr(0x38, IMP, SEC, 2), Instr(0x39, ABY, AND, 4), Instr(0x3A, IMP, NOP, 2), Instr(0x3B, ABY, RLA, 7), Instr(0x3C, ABX, IGN, 4), Instr(0x3D, ABX, AND, 4), Instr(0x3E, ABX, ROL, 7), Instr(0x3F, ABX, RLA, 7),
        Instr(0x40, IMP, RTI, 6), Instr(0x41, IDX, EOR, 6), Instr(0x42, IMP, XXX, 2), Instr(0x43, IDX, SRE, 8), Instr(0x44, ZP0, NOP, 3), Instr(0x45, ZP0, EOR, 3), Instr(0x46, ZP0, LSR, 5), Instr(0x47, ZP0, SRE, 5), Instr(0x48, IMP, PHA, 3), Instr(0x49, IMM, EOR, 2), Instr(0x4A, ACC, LSR, 2), Instr(0x4B, IMM, ALR, 2), Instr(0x4C, ABS, JMP, 3), Instr(0x4D, ABS, EOR, 4), Instr(0x4E, ABS, LSR, 6), Instr(0x4F, ABS, SRE, 6),
        Instr(0x50, REL, BVC, 2), Instr(0x51, IDY, EOR, 5), Instr(0x52, IMP, XXX, 2), Instr(0x53, IDY, SRE, 8), Instr(0x54, ZPX, NOP, 4), Instr(0x55, ZPX, EOR, 4), Instr(0x56, ZPX, LSR, 6), Instr(0x57, ZPX, SRE, 6), Instr(0x58, IMP, CLI, 2), Instr(0x59, ABY, EOR, 4), Instr(0x5A, IMP, NOP, 2), Instr(0x5B, ABY, SRE, 7), Instr(0x5C, ABX, IGN, 4), Instr(0x5D, ABX, EOR, 4), Instr(0x5E, ABX, LSR, 7), Instr(0x5F, ABX, SRE, 7),
        Instr(0x60, IMP, RTS, 6), Instr(0x61, IDX, ADC, 6), Instr(0x62, IMP, XXX, 2), Instr(0x63, IDX, RRA, 8), Instr(0x64, ZP0, NOP, 3), Instr(0x65, ZP0, ADC, 3), Instr(0x66, ZP0, ROR, 5), Instr(0x67, ZP0, RRA, 5), Instr(0x68, IMP, PLA, 4), Instr(0x69, IMM, ADC, 2), Instr(0x6A, ACC, ROR, 2), Instr(0x6B, IMM, ARR, 2), Instr(0x6C, IND, JMP, 5), Instr(0x6D, ABS, ADC, 4), Instr(0x6E, ABS, ROR, 6), Instr(0x6F, ABS, RRA, 6),
        Instr(0x70, REL, BVS, 2), Instr(0x71, IDY, ADC, 5), Instr(0x72, IMP, XXX, 2), Instr(0x73, IDY, RRA, 8), Instr(0x74, ZPX, NOP, 4), Instr(0x75, ZPX, ADC, 4), Instr(0x76, ZPX, ROR, 6), Instr(0x77, ZPX, RRA, 6), Instr(0x78, IMP, SEI, 2), Instr(0x79, ABY, ADC, 4), Instr(0x7A, IMP, NOP, 2), Instr(0x7B, ABY, RRA, 7), Instr(0x7C, ABX, IGN, 4), Instr(0x7D, ABX, ADC, 4), Instr(0x7E, ABX, ROR, 7), Instr(0x7F, ABX, RRA, 7),
        Instr(0x80, IMM, SKB, 2), Instr(0x81, IDX, STA, 6), Instr(0x82, IMM, SKB, 2), Instr(0x83, IDX, SAX, 6), Instr(0x84, ZP0, STY, 3), Instr(0x85, ZP0, STA, 3), Instr(0x86, ZP0, STX, 3), Instr(0x87, ZP0, SAX, 3), Instr(0x88, IMP, DEY, 2), Instr(0x89, IMM, SKB, 2), Instr(0x8A, IMP, TXA, 2), Instr(0x8B, IMM, XAA, 2), Instr(0x8C, ABS, STY, 4), Instr(0x8D, ABS, STA, 4), Instr(0x8E, ABS, STX, 4), Instr(0x8F, ABS, SAX, 4),
        Instr(0x90, REL, BCC, 2), Instr(0x91, IDY, STA, 6), Instr(0x92, IMP, XXX, 2), Instr(0x93, IDY, AHX, 6), Instr(0x94, ZPX, STY, 4), Instr(0x95, ZPX, STA, 4), Instr(0x96, ZPY, STX, 4), Instr(0x97, ZPY, SAX, 4), Instr(0x98, IMP, TYA, 2), Instr(0x99, ABY, STA, 5), Instr(0x9A, IMP, TXS, 2), Instr(0x9B, ABY, TAS, 5), Instr(0x9C, ABX, SYA, 5), Instr(0x9D, ABX, STA, 5), Instr(0x9E, ABY, SXA, 5), Instr(0x9F, ABY, AHX, 5),
        Instr(0xA0, IMM, LDY, 2), Instr(0xA1, IDX, LDA, 6), Instr(0xA2, IMM, LDX, 2), Instr(0xA3, IDX, LAX, 6), Instr(0xA4, ZP0, LDY, 3), Instr(0xA5, ZP0, LDA, 3), Instr(0xA6, ZP0, LDX, 3), Instr(0xA7, ZP0, LAX, 3), Instr(0xA8, IMP, TAY, 2), Instr(0xA9, IMM, LDA, 2), Instr(0xAA, IMP, TAX, 2), Instr(0xAB, IMM, LAX, 2), Instr(0xAC, ABS, LDY, 4), Instr(0xAD, ABS, LDA, 4), Instr(0xAE, ABS, LDX, 4), Instr(0xAF, ABS, LAX, 4),
        Instr(0xB0, REL, BCS, 2), Instr(0xB1, IDY, LDA, 5), Instr(0xB2, IMP, XXX, 2), Instr(0xB3, IDY, LAX, 5), Instr(0xB4, ZPX, LDY, 4), Instr(0xB5, ZPX, LDA, 4), Instr(0xB6, ZPY, LDX, 4), Instr(0xB7, ZPY, LAX, 4), Instr(0xB8, IMP, CLV, 2), Instr(0xB9, ABY, LDA, 4), Instr(0xBA, IMP, TSX, 2), Instr(0xBB, ABY, LAS, 4), Instr(0xBC, ABX, LDY, 4), Instr(0xBD, ABX, LDA, 4), Instr(0xBE, ABY, LDX, 4), Instr(0xBF, ABY, LAX, 4),
        Instr(0xC0, IMM, CPY, 2), Instr(0xC1, IDX, CMP, 6), Instr(0xC2, IMM, SKB, 2), Instr(0xC3, IDX, DCP, 8), Instr(0xC4, ZP0, CPY, 3), Instr(0xC5, ZP0, CMP, 3), Instr(0xC6, ZP0, DEC, 5), Instr(0xC7, ZP0, DCP, 5), Instr(0xC8, IMP, INY, 2), Instr(0xC9, IMM, CMP, 2), Instr(0xCA, IMP, DEX, 2), Instr(0xCB, IMM, AXS, 2), Instr(0xCC, ABS, CPY, 4), Instr(0xCD, ABS, CMP, 4), Instr(0xCE, ABS, DEC, 6), Instr(0xCF, ABS, DCP, 6),
        Instr(0xD0, REL, BNE, 2), Instr(0xD1, IDY, CMP, 5), Instr(0xD2, IMP, XXX, 2), Instr(0xD3, IDY, DCP, 8), Instr(0xD4, ZPX, NOP, 4), Instr(0xD5, ZPX, CMP, 4), Instr(0xD6, ZPX, DEC, 6), Instr(0xD7, ZPX, DCP, 6), Instr(0xD8, IMP, CLD, 2), Instr(0xD9, ABY, CMP, 4), Instr(0xDA, IMP, NOP, 2), Instr(0xDB, ABY, DCP, 7), Instr(0xDC, ABX, IGN, 4), Instr(0xDD, ABX, CMP, 4), Instr(0xDE, ABX, DEC, 7), Instr(0xDF, ABX, DCP, 7),
        Instr(0xE0, IMM, CPX, 2), Instr(0xE1, IDX, SBC, 6), Instr(0xE2, IMM, SKB, 2), Instr(0xE3, IDX, ISB, 8), Instr(0xE4, ZP0, CPX, 3), Instr(0xE5, ZP0, SBC, 3), Instr(0xE6, ZP0, INC, 5), Instr(0xE7, ZP0, ISB, 5), Instr(0xE8, IMP, INX, 2), Instr(0xE9, IMM, SBC, 2), Instr(0xEA, IMP, NOP, 2), Instr(0xEB, IMM, SBC, 2), Instr(0xEC, ABS, CPX, 4), Instr(0xED, ABS, SBC, 4), Instr(0xEE, ABS, INC, 6), Instr(0xEF, ABS, ISB, 6),
        Instr(0xF0, REL, BEQ, 2), Instr(0xF1, IDY, SBC, 5), Instr(0xF2, IMP, XXX, 2), Instr(0xF3, IDY, ISB, 8), Instr(0xF4, ZPX, NOP, 4), Instr(0xF5, ZPX, SBC, 4), Instr(0xF6, ZPX, INC, 6), Instr(0xF7, ZPX, ISB, 6), Instr(0xF8, IMP, SED, 2), Instr(0xF9, ABY, SBC, 4), Instr(0xFA, IMP, NOP, 2), Instr(0xFB, ABY, ISB, 7), Instr(0xFC, ABX, IGN, 4), Instr(0xFD, ABX, SBC, 4), Instr(0xFE, ABX, INC, 7), Instr(0xFF, ABX, ISB, 7),
    ];
```

This is a mapping of opcodes to (addressing mode, intruction) pair and will help you to use the correct addressing mode from the [helpers](/circuits/helpers/src/lib.nr) module. INX is already implemented and you can go to [dappicom/circuits/instr/inx/src/main.nr](/circuits/instr/inx/src/main.nr) to see how it was done. 

If we check the datasheet in `instr.rs`, we can see INX only has one addressing mode (implied addressing), so first we need to call that in the helper module.
Continuing on this example, let's take a look at the `inx` function in the `instr.rs`
```
 #[inline]
 pub(super) fn inx(&mut self) {
     self.set_x(self.x().wrapping_add(1));
     self.status();
     self.set_zn_status(self.x);
     self.set_status(self.status);
 }
```


1. First we get the register x using a getter function `[requires we verify trace read]`
2. Next we do a wrapping add (there is a function to help us in the helpers module)
3. Finally we set x using the setter function  `[requires we verify trace write]`
4. Now you can see there is an access to the status register with a getter function `[requires we verify trace read]`
5. If we look into the `set_zn_status` function, we see that the status register is set directly, so there is nothing to do here
6. Finally we take the new status (which is accessed directly) and set it using the setter function `[requires we verify trace write]`


Once we have constrained all the reads and writes we will need to generate the intermediary permutation product and return it which is used to verify correct execution along the recursion tree. All files will need this and it should be present in the stubbed code.

That's all there is to it!

## How to generate emulator trace for your instruction and use it for test cases

For example INSTR could be INX, ADC, etc.
```
cd emulator
cargo run --release test_roms/cpu/nestest.nes --trace --instr_name <INSTR>
```

--trace is a flag to turn on the trace feature in the emulator<br/>
--instr_name will filter a small subset of the instructions

When the emulator opens, hit enter to run all the tests and then hit CTRL + Q. The emulator will close and you will see a ```trace.json``` file output into the ```emulator/``` directory. This is a human readable format of the trace.

It's possible to generate tests for your INSTR from this trace by doing the following:

```
node ./circuits/scripts/convert_emulator_trace.js ./emulator/trace.json
```
