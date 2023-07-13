mod permcheck;
use dep::opcodes;

// Our illustrative MOS 6502 emulator only supports 3 opcodes
// LDX, STX, and INX (load X, store X, and increment X);
// there is only a program counter, an X register, and a set of flags (which atm are unconstrainted)

// this function is used only for illustrative purposes, so we will configure from the outside some knowledge about which opcode to use
// OPCODE_NUM: 0 = LDX, 1 = STX, 2 = INX

// ideally what we would have is proofs aggregated from the outside to create a verified claim of MOS_6502_COMPUTER(machine_i, transcript) => machine_i+1 
fn main(
    opcode_num: Field,
    addr_sorted_rw: [Field; 10],
    addr_sorted_addr: [Field; 10],
    addr_sorted_value: [Field; 10],
    addr_sorted_time: [Field; 10],
    addr_sorted_clk: [Field; 10],
    op_sorted_rw: [Field; 10],
    op_sorted_addr: [Field; 10],
    op_sorted_value: [Field; 10],
    op_sorted_time: [Field; 10],
    op_sorted_clk: [Field; 10],
    zero_flag: Field,
    negative_flag: Field,
) {

    permcheck::permutation_check(
        addr_sorted_rw,
        addr_sorted_addr,
        addr_sorted_value,
        addr_sorted_time,
        addr_sorted_clk,
        op_sorted_rw,
        op_sorted_addr,
        op_sorted_value,
        op_sorted_time,
        op_sorted_clk,
    );

    if opcode_num == 0 {
        opcodes::op_ldx(
            op_sorted_addr,
            op_sorted_value,
            op_sorted_time,
            op_sorted_clk,
            op_sorted_rw,
            zero_flag,
            negative_flag 
        )
    } else if opcode_num == 1 {
        opcodes::op_stx(
            op_sorted_addr,
            op_sorted_value,
            op_sorted_time,
            op_sorted_clk,
            op_sorted_rw,
            zero_flag,
            negative_flag 
        )
    } else {
        opcodes::op_inx(
            op_sorted_addr,
            op_sorted_value,
            op_sorted_time,
            op_sorted_clk,
            op_sorted_rw,
            zero_flag,
            negative_flag 
        )
    }
}


#[test]
fn test_main_ldx() {
    main(
        0,
        [0,      0,     0,      1,       0,       1,       1, 0, 0, 0],
        [1337, 1338, 1048560, 1048560, 1048560, 1048560, 1048561, 1048575, 1048575, 1048575],
        [162,   255,   1337,    1338,   1338,  1340,  255,   0, 0, 0],
        [1,  4,  0,  2,  3, 6, 5, 0, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 0, 0, 0],
        [0,         0,     1,      0,       0,       1,       1, 0, 0, 0],
        [1048560, 1337, 1048560, 1048560, 1338, 1048561, 1048560, 1048575, 1048575, 1048575],
        [1337,    162,   1338,    1338,    255,    255,     1340, 0, 0, 0],
        [0, 1, 2, 3, 4, 5, 6, 0, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 0, 0, 0],
        0,
        1
    )
}