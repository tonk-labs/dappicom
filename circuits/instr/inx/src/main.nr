use dep::constants::{PC_ADDR, A_ADDR, X_ADDR, Y_ADDR, SR_ADDR};
use dep::helpers;
use dep::std;

pub fn OPCODE_VALUE() -> Field {
    232
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

    // the value here should map to the addr of the next entry
    // but we need to implement "mapping" logic, and I don't
    // have good ideas on how to do that at present
    // this is especially annoying because mappers are stateful
    // so it's going to be unconstrained for now
    //assert(op_sorted_addr[1] == ??);

    // this the address read value should be the opcode
    assert(op_sorted_val[1] == OPCODE_VALUE()); 
    assert(op_sorted_op_rw[1] == 0);    

    //next update the PC
    assert(op_sorted_addr[2] == PC_ADDR());
    assert(op_sorted_op_rw[2] == 1);
    assert(op_sorted_val[2] == pc + 1);

    let mut sub_arr_addr: [Field; 2] = [0,0];
    let mut sub_arr_val: [Field; 2] = [0,0];
    let mut sub_arr_op_rw: [Field; 2] = [0,0];
    let offset = 3;
    for i in 0..2 {
        sub_arr_addr[i] = op_sorted_addr[offset + i];
        sub_arr_val[i] = op_sorted_val[offset + i];
        sub_arr_op_rw[i] = op_sorted_op_rw[offset + i];
    }

    helpers::imp(
        sub_arr_addr,
        sub_arr_val,
        sub_arr_op_rw
    );

    // we perform a read of x
    assert(op_sorted_addr[5] == X_ADDR());
    assert(op_sorted_op_rw[5] == 0);
    let value = op_sorted_val[5];

    // we then perform a write of x + 1
    assert(op_sorted_addr[6] == X_ADDR());
    assert(op_sorted_op_rw[6] == 1);
    let wadd = helpers::wrapping_add_u8(value, 1);
    assert(op_sorted_val[6] == wadd.value);

    // we then set a new status into the status register 

    // first there is a read from the status register
    assert(op_sorted_addr[7] == SR_ADDR());
    assert(op_sorted_op_rw[7] == 0);
    let sr = op_sorted_val[7];

    // std::println(wadd);
    let mut status = helpers::convert_to_status(sr);

    // next there is a write to the status register
    // we need to compute the zero and negative flag
    status = helpers::compute_zn_status(wadd.value, status);
    let comp_status = helpers::status_to_num(status);
    // std::println(status);
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
        [343432, 343433, 343434, 343435, 343436, 343437, 343438, 343439, 343440],
        [PC_ADDR(), 79, PC_ADDR(), PC_ADDR(), 80, X_ADDR(), X_ADDR(), SR_ADDR(), SR_ADDR()],
        [49231, OPCODE_VALUE(), 49232, OPCODE_VALUE(), 224, 0, 1, 36, 36],
        [0, 0, 1, 0, 0, 0, 1, 0, 1]
    )
}
#[test]
fn test_1() -> Field {
    main(
        1,
        [343492, 343493, 343494, 343495, 343496, 343497, 343498, 343499, 343500],
        [PC_ADDR(), 79, PC_ADDR(), PC_ADDR(), 80, X_ADDR(), X_ADDR(), SR_ADDR(), SR_ADDR()],
        [49231, OPCODE_VALUE(), 49232, 49232, 224, 1, 2, 36, 36],
        [0, 0, 1, 0, 0, 0, 1, 0, 1]
    )
}
#[test]
fn test_2() -> Field {
    main(
        1,
        [343552, 343553, 343554, 343555, 343556, 343557, 343558, 343559, 343560],
        [PC_ADDR(), 79, PC_ADDR(), PC_ADDR(), 80, X_ADDR(), X_ADDR(), SR_ADDR(), SR_ADDR()],
        [49231, OPCODE_VALUE(), 49232, 49232, 224, 2, 3, 36, 36],
        [0, 0, 1, 0, 0, 0, 1, 0, 1]
    )
}
#[test]
fn test_3() -> Field {
    main(
        1,
        [343612, 343613, 343614, 343615, 343616, 343617, 343618, 343619, 343620],
        [PC_ADDR(), 79, PC_ADDR(), PC_ADDR(), 80, X_ADDR(), X_ADDR(), SR_ADDR(), SR_ADDR()],
        [49231, OPCODE_VALUE(), 49232, 49232, 224, 3, 4, 36, 36],
        [0, 0, 1, 0, 0, 0, 1, 0, 1]
    )
}
#[test]
fn test_4() -> Field {
    main(
        1,
        [343672, 343673, 343674, 343675, 343676, 343677, 343678, 343679, 343680],
        [PC_ADDR(), 79, PC_ADDR(), PC_ADDR(), 80, X_ADDR(), X_ADDR(), SR_ADDR(), SR_ADDR()],
        [49231, OPCODE_VALUE(), 49232, 49232, 224, 4, 5, 36, 36],
        [0, 0, 1, 0, 0, 0, 1, 0, 1]
    )
}
#[test]
fn test_5() -> Field {
    main(
        1,
        [343732, 343733, 343734, 343735, 343736, 343737, 343738, 343739, 343740],
        [PC_ADDR(), 79, PC_ADDR(), PC_ADDR(), 80, X_ADDR(), X_ADDR(), SR_ADDR(), SR_ADDR()],
        [49231, OPCODE_VALUE(), 49232, 49232, 224, 5, 6, 36, 36],
        [0, 0, 1, 0, 0, 0, 1, 0, 1]
    )
}