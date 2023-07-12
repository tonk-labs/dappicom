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
fn test_ldx() {
}

#[test]
fn test_stx() {
}

#[test]
fn test_inx() {
}