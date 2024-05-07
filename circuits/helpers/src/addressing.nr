//As far as I see it there are two ways to handle addressing modes in the NES circuits

//The first way is to simply include a sub-circuit library which essentially proves the address mode is reading memory correctly and then return the relevant information to the main circuit
//The second way is to outright ignore it and only log the opcode operations following the computation of the address
//The third way is to consider addressing as its own "opcode", and we can do this if we read and write the address and fetched data into new made up registers on the NES

//Now, it would seem to me there is a danger here in the second way as addressing modes do have an intermediary effect on the PC and will also perform some computation based off the state of RAM, registers. 
//Therefore the second way would make CPU underconstrained —perhaps there is some clever approach I'm missing 

//ADDRESSING MODES
// Accumulator
// Implied
// Immediate
// Zero Page
// Zero Page, X
// Zero Page, Y
// Relative
// Absolute
// Absolute, X
// Absolute, Y
// Indirect (JMP)
// Indirect, X
// Indirect, Y

//PC = 8203
//X = 8201
//Y = 8202
//A = 8200

// this isn't supported yet but it would be better to migrate to this method when it is 

// use dep::std::collections::map::HashMap;
// use dep::std::hash::BuildHasherDefault;
// use dep::std::hash::poseidon2::Poseidon2Hasher;
// use dep::std::cmp::Eq;

// global opcode_to_func_map : HashMap<Field, u32, 12, BuildHasherDefault<Poseidon2Hasher>> = ;

pub fn wrapping_add_u16(a: Field, b: Field) -> Field {
    let max = 65535;

    if ((a as u32) + (b as u32)) > max {
        (a + b) - 65535
    } else {
        a + b
    }
}

pub fn circuit_NOP(op_sorted_addr: [Field; 1], _op_sorted_val: [Field; 1], op_sorted_op_rw: [Field; 1]) {
    // read and do nothing     
    assert(op_sorted_addr[0] == 0);
    assert(op_sorted_op_rw[0] == 0);
}

pub fn acc(op_sorted_addr: [Field; 1], _op_sorted_val: [Field; 1], op_sorted_op_rw: [Field; 1]) {
    // also kind of a do nothing mode
    // PC is read, 
    assert(op_sorted_addr[0] == 8203);
    assert(op_sorted_op_rw[0] == 0);
    // value at PC is read and thrown away
}

pub fn imp(op_sorted_addr: [Field; 2], _op_sorted_val: [Field; 2], op_sorted_op_rw: [Field; 2]) {
    //kind of a do nothing mode
    // PC is read, 
    assert(op_sorted_addr[0] == 8203);
    assert(op_sorted_op_rw[0] == 0);

    // value at PC is read and thrown away
    assert(op_sorted_op_rw[1] == 0);
}

pub fn imm(op_sorted_addr: [Field; 2], op_sorted_val: [Field; 2], op_sorted_op_rw: [Field; 2]) -> Field {
    // read pc and set as address
    assert(op_sorted_addr[0] == 8203);
    assert(op_sorted_op_rw[0] == 0);
    let address = op_sorted_val[0];

    // pc is set to PC + 1 
    assert(op_sorted_addr[1] == 8203);
    assert(op_sorted_op_rw[1] == 1);
    assert(op_sorted_val[1] == wrapping_add_u16(address, 1));
    // the value is read later
    address
}

pub fn zpo(op_sorted_addr: [Field; 3], op_sorted_val: [Field; 3], op_sorted_op_rw: [Field; 3]) -> Field {
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
    value
}

pub fn zpx_zpy(
    mode: Field,
    op_sorted_addr: [Field; 5],
    op_sorted_val: [Field; 5],
    op_sorted_op_rw: [Field; 5]
) -> Field {
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
    if mode == 0 {
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
    wrapping_add_u16(value, indexValue)
}

pub fn rel(op_sorted_addr: [Field; 3], op_sorted_val: [Field; 3], op_sorted_op_rw: [Field; 3]) -> Field {
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
    value
}

pub fn abs(op_sorted_addr: [Field; 6], op_sorted_val: [Field; 6], op_sorted_op_rw: [Field; 6]) -> Field {
    assert(op_sorted_addr[0] == 8203);
    assert(op_sorted_op_rw[0] == 0);
    let mut address = op_sorted_val[0];
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
    ((hi as u32) << 8 | (lo as u32)) as Field
}

pub fn abx_aby(
    mode: Field,
    op_sorted_addr: [Field; 8],
    op_sorted_val: [Field; 8],
    op_sorted_op_rw: [Field; 8]
) -> [Field; 2] {
    // read PC
    assert(op_sorted_addr[0] == 8203);
    assert(op_sorted_op_rw[0] == 0);
    let mut address = op_sorted_val[0];
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
    let joint = (hi as u32) << 8 | (lo as u32);

    // read value of x
    if (mode == 0) {
        // ABX
        assert(op_sorted_addr[6] == 8201);
    } else {
        // ABY
        assert(op_sorted_addr[6] == 8202);
    }
    assert(op_sorted_op_rw[6] == 0);
    let index = op_sorted_val[6];
    // add value of x or y to addr
    let abs_addr = wrapping_add_u16(joint as Field, index);
    // value of Addr is addr + x or y
    let data_addr = ((joint as u32) & 65280) as u32 | ((abs_addr as u32) & 255) as u32;
    // read addr & 0xFF00 | Addr & 0x00FF and return as Value
    assert(op_sorted_addr[7] == data_addr as Field);
    assert(op_sorted_op_rw[7] == 0);
    // return Addr, Value
    [abs_addr, op_sorted_val[7]]
}

pub fn ind(op_sorted_addr: [Field; 8], op_sorted_val: [Field; 8], op_sorted_op_rw: [Field; 8]) -> Field {
    // read PC
    assert(op_sorted_addr[0] == 8203);
    assert(op_sorted_op_rw[0] == 0);
    let mut address = op_sorted_val[0];
    // read value into lo 
    assert(op_sorted_addr[1] == address);
    assert(op_sorted_op_rw[1] == 0);
    let mut lo = op_sorted_val[1];
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
    let mut hi = op_sorted_val[4];
    // set PC to PC + 1
    assert(op_sorted_addr[5] == 8203);
    assert(op_sorted_op_rw[5] == 1);
    assert(op_sorted_val[5] == wrapping_add_u16(address, 1));
    // addr is hi << 8 | lo
    let joint_addr = (hi as u32) << 8 | (lo as u32);
    // if addr & 0xFF  == 0xFF
    if ((joint_addr as u32) & 255) == 255 {
        // read value from addr lo byte
        // read value from addr hi byte
        // return value from hi << 8 | value from lo as Addr
        assert(op_sorted_addr[6] == joint_addr as Field);
        assert(op_sorted_op_rw[6] == 0);
        lo = op_sorted_val[6];

        assert(op_sorted_addr[7] == ((joint_addr as u32) & 65280) as Field);
        assert(op_sorted_op_rw[7] == 0);
        hi = op_sorted_val[7];

        ((hi as u32) << 8 | (lo as u32)) as Field
    } else {
        // read value from addr and set to lo
        // read value from addr + 1 and set to hi
        // return hi << 8 | lo from Addr
        assert(op_sorted_addr[6] == joint_addr as Field);
        assert(op_sorted_op_rw[6] == 0);
        lo = op_sorted_val[6];

        assert(op_sorted_addr[7] == wrapping_add_u16(joint_addr as Field, 1));
        assert(op_sorted_op_rw[7] == 0);
        hi = op_sorted_val[7];

        ((hi as u32) << 8 | (lo as u32)) as Field
    }
}

pub fn idx(op_sorted_addr: [Field; 7], op_sorted_val: [Field; 7], op_sorted_op_rw: [Field; 7]) -> Field {
    // read PC
    assert(op_sorted_addr[0] == 8203);
    assert(op_sorted_op_rw[0] == 0);
    let pc_address = op_sorted_val[0];
    // read value from PC
    assert(op_sorted_addr[1] == pc_address);
    assert(op_sorted_op_rw[1] == 0);
    let mut addr = op_sorted_val[1];
    // set PC to PC + 1
    assert(op_sorted_addr[2] == 8203);
    assert(op_sorted_op_rw[2] == 1);
    assert(op_sorted_val[2] == wrapping_add_u16(addr, 1));
    // read addr at value (is thrown away)
    assert(op_sorted_addr[3] == addr);
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
    ((hi as u32) << 8 | (lo as u32)) as Field
}

pub fn idy(
    op_sorted_addr: [Field; 7],
    op_sorted_val: [Field; 7],
    op_sorted_op_rw: [Field; 7]
) -> [Field; 2] {
    // read PC
    assert(op_sorted_addr[0] == 8203);
    assert(op_sorted_op_rw[0] == 0);
    let pc_address = op_sorted_val[0];
    // read value from PC
    assert(op_sorted_addr[1] == pc_address);
    assert(op_sorted_op_rw[1] == 0);
    let mut addr = op_sorted_val[1];
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
    addr = ((hi as u32) << 8 | lo as u32) as Field;
    // Read y value
    assert(op_sorted_addr[5] == 8202);
    assert(op_sorted_op_rw[5] == 0);
    let yvalue = op_sorted_val[5];
    // set Addr to (addr << 8 | lo) + y
    let abs_addr = wrapping_add_u16(addr, yvalue);
    // read addr & 0xFF00 | Addr & 0x00FF and return as Value
    let data_addr = ((addr as u32) & 65280) | ((abs_addr as u32) & 255);
    assert(op_sorted_addr[6] == data_addr as Field);
    assert(op_sorted_op_rw[6] == 0);
    let data_value = op_sorted_val[6];
    // return Addr, Value
    [abs_addr, data_value]
}

