use dep::constants::{PC_ADDR, A_ADDR, X_ADDR, Y_ADDR, SR_ADDR};
use dep::helpers;
use dep::std;

pub fn OPCODE_VALUE() -> Field {
    136
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

    // we perform a read of y
    assert(op_sorted_addr[5] == Y_ADDR());
    assert(op_sorted_op_rw[5] == 0);
    let value = op_sorted_val[5];

    // we then perform a write of x - 1
    assert(op_sorted_addr[6] == Y_ADDR());
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
        [221224, 221225, 221226, 221227, 221228, 221229, 221230, 221231, 221232],
        [PC_ADDR(), 58, PC_ADDR(), PC_ADDR(), 59, Y_ADDR(), Y_ADDR(), SR_ADDR(), SR_ADDR()],
        [49210, 136, 49211, 49211, 208, 15, 14, 38, 36],
        [0, 0, 1, 0, 0, 0, 1, 0, 1]
    )
}
#[test]
fn test_1() -> Field {
    main(
        1,
        [229946, 229947, 229948, 229949, 229950, 229951, 229952, 229953, 229954],
        [PC_ADDR(), 58, PC_ADDR(), PC_ADDR(), 59, Y_ADDR(), Y_ADDR(), SR_ADDR(), SR_ADDR()],
        [49210, 136, 49211, 49211, 208, 14, 13, 38, 36],
        [0, 0, 1, 0, 0, 0, 1, 0, 1]
    )
}
#[test]
fn test_2() -> Field {
    main(
        1,
        [238668, 238669, 238670, 238671, 238672, 238673, 238674, 238675, 238676],
        [PC_ADDR(), 58, PC_ADDR(), PC_ADDR(), 59, Y_ADDR(), Y_ADDR(), SR_ADDR(), SR_ADDR()],
        [49210, 136, 49211, 49211, 208, 13, 12, 38, 36],
        [0, 0, 1, 0, 0, 0, 1, 0, 1]
    )
}
#[test]
fn test_3() -> Field {
    main(
        1,
        [247390, 247391, 247392, 247393, 247394, 247395, 247396, 247397, 247398],
        [PC_ADDR(), 58, PC_ADDR(), PC_ADDR(), 59, Y_ADDR(), Y_ADDR(), SR_ADDR(), SR_ADDR()],
        [49210, 136, 49211, 49211, 208, 12, 11, 38, 36],
        [0, 0, 1, 0, 0, 0, 1, 0, 1]
    )
}
#[test]
fn test_4() -> Field {
    main(
        1,
        [256112, 256113, 256114, 256115, 256116, 256117, 256118, 256119, 256120],
        [PC_ADDR(), 58, PC_ADDR(), PC_ADDR(), 59, Y_ADDR(), Y_ADDR(), SR_ADDR(), SR_ADDR()],
        [49210, 136, 49211, 49211, 208, 11, 10, 38, 36],
        [0, 0, 1, 0, 0, 0, 1, 0, 1]
    )
}
#[test]
fn test_5() -> Field {
    main(
        1,
        [264834, 264835, 264836, 264837, 264838, 264839, 264840, 264841, 264842],
        [PC_ADDR(), 58, PC_ADDR(), PC_ADDR(), 59, Y_ADDR(), Y_ADDR(), SR_ADDR(), SR_ADDR()],
        [49210, 136, 49211, 49211, 208, 10, 9, 38, 36],
        [0, 0, 1, 0, 0, 0, 1, 0, 1]
    )
}