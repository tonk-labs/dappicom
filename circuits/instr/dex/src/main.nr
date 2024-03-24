use dep::constants::{PC_ADDR, A_ADDR, X_ADDR, Y_ADDR, SR_ADDR};
use dep::helpers;
use dep::std;

pub fn OPCODE_VALUE() -> Field {
    202
}

fn main(
    r: Field,
    op_sorted_step: [Field; 9],
    op_sorted_addr: [Field; 9],
    op_sorted_val: [Field; 9],
    op_sorted_op_rw: [Field; 9]
) -> pub Field {
    assert(op_sorted_addr[0] == PC_ADDR());
    assert(op_sorted_op_rw[0] == 0);
    let pc = op_sorted_val[0];

    // this the address read value should be the opcode
    assert(op_sorted_val[1] == OPCODE_VALUE());
    assert(op_sorted_op_rw[1] == 0);

    //next update the PC
    assert(op_sorted_addr[2] == PC_ADDR());
    assert(op_sorted_op_rw[2] == 1);
    assert(op_sorted_val[2] == pc + 1);

    let mut sub_arr_addr: [Field; 2] = [0, 0];
    let mut sub_arr_val: [Field; 2] = [0, 0];
    let mut sub_arr_op_rw: [Field; 2] = [0, 0];
    let offset = 3;
    for i in 0..2 {
        sub_arr_addr[i] = op_sorted_addr[offset + i];
        sub_arr_val[i] = op_sorted_val[offset + i];
        sub_arr_op_rw[i] = op_sorted_op_rw[offset + i];
    }

    helpers::imp(sub_arr_addr, sub_arr_val, sub_arr_op_rw);

    // we perform a read of x
    assert(op_sorted_addr[5] == X_ADDR());
    assert(op_sorted_op_rw[5] == 0);
    let value = op_sorted_val[5];

    // we then perform a write of x - 1
    assert(op_sorted_addr[6] == X_ADDR());
    assert(op_sorted_op_rw[6] == 1);

    let wdec = helpers::wrapping_dec_u8(value, 1);
    assert(op_sorted_val[6] == wdec.value);

    // we then set a new status into the status register 

    // first there is a read from the status register
    assert(op_sorted_addr[7] == SR_ADDR());
    assert(op_sorted_op_rw[7] == 0);
    let sr = op_sorted_val[7];

    let mut status = helpers::convert_to_status(sr);

    // next there is a write to the status register
    // we need to compute the zero and negative flag
    status = helpers::compute_zn_status(wdec.value, status);
    let comp_status = helpers::status_to_num(status); // 0x26

    assert(op_sorted_addr[8] == SR_ADDR());
    assert(op_sorted_op_rw[8] == 1);
    assert(op_sorted_val[8] == comp_status);

    // Compute permutation and return it
    helpers::compute_permutation_9(
        r,
        op_sorted_step,
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}

#[test]
fn test_0() -> Field {
    main(
        1,
        [212536, 212537, 212538, 212539, 212540, 212541, 212542, 212543, 212544],
        [PC_ADDR(), 55, PC_ADDR(), PC_ADDR(), 56, X_ADDR(), X_ADDR(), SR_ADDR(), SR_ADDR()],
        [49207, OPCODE_VALUE(), 49208, 49208, 208, 0, 255, 38, 164],
        [0, 0, 1, 0, 0, 0, 1, 0, 1]
    )
}
#[test]
fn test_1() -> Field {
    main(
        1,
        [212570, 212571, 212572, 212573, 212574, 212575, 212576, 212577, 212578],
        [PC_ADDR(), 55, PC_ADDR(), PC_ADDR(), 56, X_ADDR(), X_ADDR(), SR_ADDR(), SR_ADDR()],
        [49207, 202, 49208, 49208, 208, 255, 254, 164, 164],
        [0, 0, 1, 0, 0, 0, 1, 0, 1]
    )
}
#[test]
fn test_2() -> Field {
    main(
        1,
        [212604, 212605, 212606, 212607, 212608, 212609, 212610, 212611, 212612],
        [PC_ADDR(), 55, PC_ADDR(), PC_ADDR(), 56, X_ADDR(), X_ADDR(), SR_ADDR(), SR_ADDR()],
        [49207, 202, 49208, 49208, 208, 254, 253, 164, 164],
        [0, 0, 1, 0, 0, 0, 1, 0, 1]
    )
}
#[test]
fn test_3() -> Field {
    main(
        1,
        [212638, 212639, 212640, 212641, 212642, 212643, 212644, 212645, 212646],
        [PC_ADDR(), 55, PC_ADDR(), PC_ADDR(), 56, X_ADDR(), X_ADDR(), SR_ADDR(), SR_ADDR()],
        [49207, 202, 49208, 49208, 208, 253, 252, 164, 164],
        [0, 0, 1, 0, 0, 0, 1, 0, 1]
    )
}
#[test]
fn test_4() -> Field {
    main(
        1,
        [212672, 212673, 212674, 212675, 212676, 212677, 212678, 212679, 212680],
        [PC_ADDR(), 55, PC_ADDR(), PC_ADDR(), 56, X_ADDR(), X_ADDR(), SR_ADDR(), SR_ADDR()],
        [49207, 202, 49208, 49208, 208, 252, 251, 164, 164],
        [0, 0, 1, 0, 0, 0, 1, 0, 1]
    )
}
