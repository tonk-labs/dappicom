//As far as I see it there are two ways to handle addressing modes in the NES circuits

//The first way is to simply include a sub-circuit library which essentially proves the address mode is reading memory correctly and then return the relevant information to the main circuit
//The second way is to outright ignore it and only log the opcode operations following the computation of the address
//The third way is to consider addressing as its own "opcode", and we can do this if we read and write the address and fetched data into new made up registers on the NES

//Now, it would seem to me there is a danger here in the second way as addressing modes do have an intermediary effect on the PC and will also perform some computation based off the state of RAM, registers. 
//Therefore the second way would make CPU underconstrained —perhaps there is some clever approach I'm missing 

//MODES
// 0 = Skip
// 1 = Accumulator
// 2 = Implied
// 3 = Immediate
// 4 = Zero Page
// 5 = Zero Page, X
// 6 = Zero Page, Y
// 7 = Relative
// 8 = Absolute
// 9 Absolute, X
// 10 = Absolute, Y
// 11 = Indirect (JMP)
// 12 = Indirect, X
// 13 = Indirect, Y

//PC = 8203
//X = 8201
//Y = 8202
//A = 8200

// Please see cpu/instr.rs in tetanes/ for reference
fn run(
    mode: Field,
    op_sorted_step: [Field; 7],
    op_sorted_addr: [Field; 7],
    op_sorted_val: [Field; 7],
    op_sorted_op_rw: [Field; 7],
// Returns (Address, Value — for ABY,ABX, and IDY)
) -> (Field, Field) {
    if mode == 0 {
        (0,0)

    } else if mode == 1 { // ACC
        // also kind of a do nothing mode
        // PC is read, 
        // value at PC is read and thrown away
        (0,0)

    } else if mode == 2 { // IMP
        //kind of a do nothing mode
        // PC is read, 
        // value at PC is read and thrown away
        (0,0)

    } else if mode == 3 { //  IMM
        // read pc and set as address
        // pc is set to PC + 1 

    } else if mode == 4 { // ZP0
        // read PC
        // read value from PC
        // set PC to PC + 1
        // value is returned as Addr

    } else if mode == 5 { // ZPX
        // read PC
        // read value from PC
        // set PC to PC + 1
        // read addr at value (is thrown away)
        // read from x
        // add x to value
        //result is returned as Addr

    } else if mode == 6 { // ZPY
        // read PC
        // read value from PC
        // set PC to PC + 1
        // read addr at value (is thrown away)
        // read from y
        // add y to value
        //result is returned as Addr

    } else if mode == 7 { // REL
        // read PC
        // read value from PC
        // set PC to PC + 1
        // value is returned as Addr

    } else if mode == 8 { // ABS
        // read PC
        // read value into lo 
        // set PC to PC + 1
        // read PC
        // read value into hi
        // set PC to PC + 1
        // return hi << 8 | lo
§
    } else if mode == 9 { // ABX
        // read PC
        // read value into lo 
        // set PC to PC + 1
        // read PC
        // read value into hi
        // set PC to PC + 1
        // calculate addr as hi << 8 | lo
        // read value of x
        // add value of x to addr
        // value of Addr is addr + x
        // read addr & 0xFF00 | Addr & 0x00FF and return as Value
        // return Addr, Value

    } else if mode == 10 { // ABY
        // read PC
        // read value into lo 
        // set PC to PC + 1
        // read PC
        // read value into hi
        // set PC to PC + 1
        // calculate addr as hi << 8 | lo
        // read value of y
        // add value of y to addr
        // value of Addr is addr + y
        // read addr & 0xFF00 | Addr & 0x00FF and return as Value
        // return Addr, Value


    } else if mode == 11 { // IND (JMP)
        // read PC
        // read value into lo 
        // set PC to PC + 1
        // read PC
        // read value into hi
        // set PC to PC + 1
        // addr is hi << 8 | lo
        // if addr & 0xFF  == 0xFF
        // read value from addr lo byte
        // read value from addr hi byte
        // return value from hi << 8 | value from lo as Addr
        // else
        // read value from addr and set to lo
        // read value from addr + 1 and set to hi
        // return hi << 8 | lo from Addr

    } else if mode == 12 { // IDX 
        // read PC
        // read value from PC
        // set PC to PC + 1
        // read from addr and throw away value
        // read x value
        // add x value to addr
        // read addr and set to lo
        // add 1 to addr and set to hi
        // return Addr as hi << 8 | lo

    } else if mode == 13 { // IDY
        // read PC
        // read value from PC
        // set PC to PC + 1
        // read addr at value and set to lo
        // add 1 to value and read addr and set to hi
        // Read y value
        // set Addr to (addr << 8 | lo) + y
        // read addr & 0xFF00 | Addr & 0x00FF and return as Value
        // return Addr, Value

    } else {
        //something horrible has happened
    }

}