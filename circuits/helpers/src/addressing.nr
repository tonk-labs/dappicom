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

fn wrapping_add_u16(a: Field, b: Field) -> Field {
    let max = 65535;

    if ((value as u16) + (b as u16)) > 65535 {
        (value + b) - 65535
    } else {
        value + b
    }

}

// Please see cpu/instr.rs in tetanes/ for reference
// Note:
// This function may be used as a helper, but it's probably not very efficient, because many opcodes use only a subset of addressing modes
// perhaps it's better to copy paste this function into each opcode and then just eliminate the addressing modes which aren't used
fn run(
    mode: Field,
    op_sorted_addr: [Field; 8],
    op_sorted_val: [Field; 8],
    op_sorted_op_rw: [Field; 8],
// Returns (Address, Value, Offset — for ABY,ABX, and IDY)
) -> [Field; 3] {
    if mode == 0 {
        [0,0]

    } else if mode == 1 { // ACC
        // also kind of a do nothing mode
        // PC is read, 
        assert(op_sorted_addr[0] == 8203);
        assert(op_sorted_op_rw[0] == 0);
        // value at PC is read and thrown away
        [0,0,1]
    } else if mode == 2 { // IMP
        //kind of a do nothing mode
        // PC is read, 
        assert(op_sorted_addr[0] == 8203);
        assert(op_sorted_op_rw[0] == 0);
        // value at PC is read and thrown away
        [0,0,1]

    } else if mode == 3 { //  IMM
        // read pc and set as address
        assert(op_sorted_addr[0] == 8203);
        assert(op_sorted_op_rw[0] == 0);
        let address = op_sorted_val[0];

        // pc is set to PC + 1 
        assert(op_sorted_addr[1] == 8203);
        assert(op_sorted_op_rw[1] == 1);
        assert(op_sorted_val[1] == wrapping_add_u16(address, 1));
        // the value is read later
        [address, 0, 2]
    } else if mode == 4 { // ZP0
        // read PC
        assert(op_sorted_addr[0] == 8203);
        assert(op_sorted_op_rw[0] == 0);
        let address = op_sorted_val[0];
        // read value from PC
        assert(op_sorted_addr[1] == address);
        assert(op_sorted_op_rw[1] == 0);
        let value = op_sorted_val[1];
        // set PC to PC + 1
        assert(op_sorted_addr[2] == 8203);
        assert(op_sorted_op_rw[2] == 1);
        assert(op_sorted_val[2] == wrapping_add_u16(address, 1));
        // value is returned as Addr
        [value, 0, 3]

    } else if (mode == 5) | (mode == 6) { // ZPX && ZPY
        // read PC
        assert(op_sorted_addr[0] == 8203);
        assert(op_sorted_op_rw[0] == 0);
        let address = op_sorted_val[0];
        // read value from PC
        assert(op_sorted_addr[1] == address);
        assert(op_sorted_op_rw[1] == 0);
        let value = op_sorted_val[1];
        // set PC to PC + 1
        assert(op_sorted_addr[2] == 8203);
        assert(op_sorted_op_rw[2] == 1);
        assert(op_sorted_val[2] == wrapping_add_u16(address, 1));
        // read addr at value (is thrown away)
        assert(op_sorted_addr[3] == value);
        assert(op_sorted_op_rw[3] == 0);
        // read from x or y
        if mode == 5 {
            //ZPX
            assert(op_sorted_addr[4] == 8201);
        } else {
            //ZPY
            assert(op_sorted_addr[4] == 8202);
        }
        assert(op_sorted_op_rw[4] == 0);
        let indexValue = op_sorted_val[4];
        // add x or y to value
        //result is returned as Addr
        [wrapping_add_u16(value + indexValue), 0, 5]

    } else if mode == 7 { // REL
        // read PC
        assert(op_sorted_addr[0] == 8203);
        assert(op_sorted_op_rw[0] == 0);
        let address = op_sorted_val[0];
        // read value from PC
        assert(op_sorted_addr[1] == address);
        assert(op_sorted_op_rw[1] == 0);
        let value = op_sorted_val[1];
        // set PC to PC + 1
        assert(op_sorted_addr[2] == 8203);
        assert(op_sorted_op_rw[2] == 1);
        assert(op_sorted_val[2] == wrapping_add_u16(address, 1));
        // value is returned as Addr
        [value, 0, 3]

    } else if mode == 8 { // ABS
        // read PC
        assert(op_sorted_addr[0] == 8203);
        assert(op_sorted_op_rw[0] == 0);
        let address = op_sorted_val[0];
        // read value into lo 
        assert(op_sorted_addr[1] == address);
        assert(op_sorted_op_rw[1] == 0);
        let lo = op_sorted_val[1];
        // set PC to PC + 1
        assert(op_sorted_addr[2] == 8203);
        assert(op_sorted_op_rw[2] == 1);
        assert(op_sorted_val[2] == wrapping_add_u16(address, 1));
        // read PC
        assert(op_sorted_addr[3] == 8203);
        assert(op_sorted_op_rw[3] == 0);
        address = op_sorted_val[3];
        // read value into hi
        assert(op_sorted_addr[4] == address);
        assert(op_sorted_op_rw[4] == 0);
        let hi = op_sorted_val[4];
        // set PC to PC + 1
        assert(op_sorted_addr[5] == 8203);
        assert(op_sorted_op_rw[5] == 1);
        assert(op_sorted_val[5] == wrapping_add_u16(address, 1));
        // return hi << 8 | lo
        let abs = (hi as u8) << 8 | (lo as u8);
        [abs, 0, 6]

    } else if (mode == 9) | (mode == 10) { // ABX && ABY
        // read PC
        assert(op_sorted_addr[0] == 8203);
        assert(op_sorted_op_rw[0] == 0);
        let address = op_sorted_val[0];
        // read value into lo 
        assert(op_sorted_addr[1] == address);
        assert(op_sorted_op_rw[1] == 0);
        let lo = op_sorted_val[1];
        // set PC to PC + 1
        assert(op_sorted_addr[2] == 8203);
        assert(op_sorted_op_rw[2] == 1);
        assert(op_sorted_val[2] == wrapping_add_u16(address, 1));
        // read PC
        assert(op_sorted_addr[3] == 8203);
        assert(op_sorted_op_rw[3] == 0);
        address = op_sorted_val[3];
        // read value into hi
        assert(op_sorted_addr[4] == address);
        assert(op_sorted_op_rw[4] == 0);
        let hi = op_sorted_val[4];
        // set PC to PC + 1
        assert(op_sorted_addr[5] == 8203);
        assert(op_sorted_op_rw[5] == 1);
        assert(op_sorted_val[5] == wrapping_add_u16(address, 1));
        
        // calculate joint value
        let joint = (hi as u8) << 8 | (lo as u8);

        // read value of x
        if (mode == 9) {
            // ABX
            assert(op_sorted_addr[6] == 8201);
        } else {
            // ABY
            assert(op_sorted_addr[6] == 8202);
        }
        assert(op_sorted_op_rw[6] == 0);
        let index = op_sorted_val[6];
        // add value of x or y to addr
        let abs_addr = wrapping_add_u16(joint, index);
        // value of Addr is addr + x or y
        let data_addr = ((joint as u16) & 65280) | ((abs_addr as u16) & 255);
        // read addr & 0xFF00 | Addr & 0x00FF and return as Value
        assert(op_sorted_addr[7] == data_addr);
        assert(op_sorted_op_rw[7] == 0);
        // return Addr, Value
        [abs_addr, op_sorted_val[7], 8]

    } else if mode == 11 { // IND (JMP)
        // read PC
        assert(op_sorted_addr[0] == 8203);
        assert(op_sorted_op_rw[0] == 0);
        let address = op_sorted_val[0];
        // read value into lo 
        assert(op_sorted_addr[1] == address);
        assert(op_sorted_op_rw[1] == 0);
        let lo = op_sorted_val[1];
        // set PC to PC + 1
        assert(op_sorted_addr[2] == 8203);
        assert(op_sorted_op_rw[2] == 1);
        assert(op_sorted_val[2] == wrapping_add_u16(address, 1));
        // read PC
        assert(op_sorted_addr[3] == 8203);
        assert(op_sorted_op_rw[3] == 0);
        address = op_sorted_val[3];
        // read value into hi
        assert(op_sorted_addr[4] == address);
        assert(op_sorted_op_rw[4] == 0);
        let hi = op_sorted_val[4];
        // set PC to PC + 1
        assert(op_sorted_addr[5] == 8203);
        assert(op_sorted_op_rw[5] == 1);
        assert(op_sorted_val[5] == wrapping_add_u16(address, 1));
        // addr is hi << 8 | lo
        let joint_addr = (hi as u8) << 8 | (lo as u8);
        // if addr & 0xFF  == 0xFF
        if ((joint_addr as u16) & 255) == 255 {
            // read value from addr lo byte
            // read value from addr hi byte
            // return value from hi << 8 | value from lo as Addr
            assert(op_sorted_addr[6] == joint_addr);
            assert(op_sorted_op_rw[6] == 0);
            lo = op_sorted_val[6];

            assert(op_sorted_addr[7] == ((joint_addr as u16) & 65280));
            assert(op_sorted_op_rw[7] == 0);
            hi = op_sorted_val[7];

            [(hi as u8) << 8 | (lo as u8), 0, 8]

        } else {
            // read value from addr and set to lo
            // read value from addr + 1 and set to hi
            // return hi << 8 | lo from Addr
            assert(op_sorted_addr[6] == joint_addr);
            assert(op_sorted_op_rw[6] == 0);
            lo = op_sorted_val[6];

            assert(op_sorted_addr[7] == wrapping_add_u16(joint_addr, 1));
            assert(op_sorted_op_rw[7] == 0);
            hi = op_sorted_val[7];

            [(hi as u8) << 8 | (lo as u8), 0, 8]
        }
    } else if mode == 12 { // IDX 
        // read PC
        assert(op_sorted_addr[0] == 8203);
        assert(op_sorted_op_rw[0] == 0);
        let pc_address = op_sorted_val[0];
        // read value from PC
        assert(op_sorted_addr[1] == pc_address);
        assert(op_sorted_op_rw[1] == 0);
        let addr = op_sorted_val[1];
        // set PC to PC + 1
        assert(op_sorted_addr[2] == 8203);
        assert(op_sorted_op_rw[2] == 1);
        assert(op_sorted_val[2] == wrapping_add_u16(address, 1));
        // read addr at value (is thrown away)
        assert(op_sorted_addr[3] == value);
        assert(op_sorted_op_rw[3] == 0);
        // read x value
        assert(op_sorted_addr[4] == 8201);
        assert(op_sorted_op_rw[4] == 0);
        let xvalue = op_sorted_val[4];
        // add x value to addr
        addr = wrapping_add_u16(addr, xvalue);
        // read addr and set to lo
        assert(op_sorted_addr[5] == addr);
        assert(op_sorted_op_rw[5] == 0);
        let lo = op_sorted_val[5];
        // add 1 to addr and set to hi
        assert(op_sorted_addr[5] == wrapping_add_u16(addr, 1));
        assert(op_sorted_op_rw[5] == 0);
        let hi = op_sorted_val[6];
        // return Addr as hi << 8 | lo
        [(hi as u16) << 8 | (lo as u16), 0, 7]


    } else if mode == 13 { // IDY
        // read PC
        assert(op_sorted_addr[0] == 8203);
        assert(op_sorted_op_rw[0] == 0);
        let pc_address = op_sorted_val[0];
        // read value from PC
        assert(op_sorted_addr[1] == pc_address);
        assert(op_sorted_op_rw[1] == 0);
        let addr = op_sorted_val[1];
        // set PC to PC + 1
        assert(op_sorted_addr[2] == 8203);
        assert(op_sorted_op_rw[2] == 1);
        // read addr at value and set to lo
        assert(op_sorted_addr[3] == addr);
        assert(op_sorted_op_rw[3] == 0);
        let lo = op_sorted_val[3];
        // add 1 to value and read addr and set to hi
        assert(op_sorted_addr[4] == wrapping_add_u16(addr, 1));
        assert(op_sorted_op_rw[4] == 0);
        let hi = op_sorted_val[4];
        addr = (hi as u16) << 8 | lo;
        // Read y value
        assert(op_sorted_addr[5] == 8202);
        assert(op_sorted_op_rw[5] == 0);
        let yvalue = op_sorted_val[5];
        // set Addr to (addr << 8 | lo) + y
        let abs_addr = wrapping_add_u16(addr + yvalue);
        // read addr & 0xFF00 | Addr & 0x00FF and return as Value
        let data_addr = ((joint as u16) & 65280) | ((abs_addr as u16) & 255);
        assert(op_sorted_addr[6] == data_addr);
        assert(op_sorted_op_rw[6] == 0);
        let data_value = op_sorted_val[6];
        // return Addr, Value
        [abs_addr, data_value, 7]

    } else {
        //something horrible has happened
    }

}