use dep::constants::{PC_ADDR, A_ADDR, X_ADDR, Y_ADDR, SR_ADDR};
use dep::helpers;
use dep::std;

pub fn OPCODE_VALUE() -> Field {
    232
}

fn main(
    r: Field,
    op_sorted_step: [Field; 21],
    op_sorted_addr: [Field; 21],
    op_sorted_val: [Field; 21],
    op_sorted_op_rw: [Field; 21]
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
    let opcode = op_sorted_val[1];    

    //next update the PC
    assert(op_sorted_addr[2] == PC_ADDR());
    assert(op_sorted_op_rw[2] == 1);
    assert(op_sorted_val[2] == pc + 1);

    //check the mode
    assert(op_sorted_addr[3] == 8203);
    assert(op_sorted_op_rw[3] == 0);
    let _ = op_sorted_val[3];

    //update the PC
    assert(op_sorted_addr[4] == 8203);
    assert(op_sorted_op_rw[4] == 1);
    assert(op_sorted_val[4] == pc + 2);
    
    // addressing
    let mut sub_arr_addr: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
    let mut sub_arr_val: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
    let mut sub_arr_op_rw: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
    let offset = 5;

    for i in 0..8 {
        sub_arr_addr[i] = op_sorted_addr[offset + i];
        sub_arr_val[i] = op_sorted_val[offset + i];
        sub_arr_op_rw[i] = op_sorted_op_rw[offset + i];
    }

    helpers::addressing_helpers(opcode, 0, sub_arr_addr, sub_arr_val, sub_arr_op_rw);

    // we perform a read of x
    assert(op_sorted_addr[13] == X_ADDR());
    assert(op_sorted_op_rw[13] == 0);
    let value = op_sorted_val[13];

    // we then perform a write of x + 1
    assert(op_sorted_addr[14] == X_ADDR());
    assert(op_sorted_op_rw[14] == 1);
    let wadd = helpers::wrapping_add_u8(value, 1);
    assert(op_sorted_val[14] == wadd.value);

    // we then set a new status into the status register 

    // first there is a read from the status register
    assert(op_sorted_addr[15] == SR_ADDR());
    assert(op_sorted_op_rw[15] == 0);
    let sr = op_sorted_val[15];

    // std::println(wadd);
    let mut status = helpers::convert_to_status(sr);

    // next there is a write to the status register
    // we need to compute the zero and negative flag
    status = helpers::compute_zn_status(wadd.value, status);
    let comp_status = helpers::status_to_num(status);
    // std::println(status);
    assert(op_sorted_addr[16] == SR_ADDR());
    assert(op_sorted_op_rw[16] == 1);
    assert(op_sorted_val[16] == comp_status);

    for i in 17..21 {
        assert(op_sorted_addr[i] == 0);
        assert(op_sorted_op_rw[i] == 0);
        assert(op_sorted_val[i] == 0);
    }

    // Compute permutation and return it
    helpers::compute_permutation_21(
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
        [
        343432, 343433, 343434, 343435, 343436, 343437, 343438, 343439, 343440, 343441, 343442, 343443, 343444, 343445, 343446, 343447, 343448, 343449, 343450, 343451, 343452
    ],
        [8203, 79, 8203, 8203, 8203, 0, 0, 0, 0, 0, 0, 8203, 80,8201,8201, 8205, 8205, 0, 0, 0, 0],
        [49231, 232, 49232, 1, 49233, 0, 0, 0, 0, 0, 0, 49233, 224,0,1, 36, 36, 0, 0, 0, 0],
        [0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,0,1, 0, 1,  0, 0, 0, 0]
    )
}

#[test]
fn test_1() -> Field {
    main(
        1,
        [
        343432, 343433, 343434, 343435, 343436, 343437, 343438, 343439, 343440, 343441, 343442, 343443, 343444, 343445, 343446, 343447, 343448, 343449, 343450, 343451, 343452
    ],
        [8203, 79, 8203, 8203, 8203, 0, 0, 0, 0, 0, 0, 8203, 80,8201,8201, 8205, 8205, 0, 0, 0, 0],
        [49231, 232, 49232, 1, 49233, 0, 0, 0, 0, 0, 0, 49233, 224,1,2, 36, 36, 0, 0, 0, 0],
        [0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,0,1, 0, 1,  0, 0, 0, 0]
    )
}

#[test]
fn test_2() -> Field {
    main(
        1,
        [
        343432, 343433, 343434, 343435, 343436, 343437, 343438, 343439, 343440, 343441, 343442, 343443, 343444, 343445, 343446, 343447, 343448, 343449, 343450, 343451, 343452
    ],
        [8203, 79, 8203, 8203, 8203, 0, 0, 0, 0, 0, 0, 8203, 80,8201,8201, 8205, 8205, 0, 0, 0, 0],
        [49231, 232, 49232, 1, 49233, 0, 0, 0, 0, 0, 0, 49233, 224,2,3, 36, 36, 0, 0, 0, 0],
        [0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,0,1, 0, 1,  0, 0, 0, 0]
    )
}

#[test]
fn test_3() -> Field {
    main(
        1,
        [
        343432, 343433, 343434, 343435, 343436, 343437, 343438, 343439, 343440, 343441, 343442, 343443, 343444, 343445, 343446, 343447, 343448, 343449, 343450, 343451, 343452
    ],
        [8203, 79, 8203, 8203, 8203, 0, 0, 0, 0, 0, 0, 8203, 80,8201,8201, 8205, 8205, 0, 0, 0, 0],
        [49231, 232, 49232, 1, 49233, 0, 0, 0, 0, 0, 0, 49233, 224,3,4, 36, 36, 0, 0, 0, 0],
        [0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,0,1, 0, 1,  0, 0, 0, 0]
    )
}

#[test]
fn test_4() -> Field {
    main(
        1,
        [
        343432, 343433, 343434, 343435, 343436, 343437, 343438, 343439, 343440, 343441, 343442, 343443, 343444, 343445, 343446, 343447, 343448, 343449, 343450, 343451, 343452
    ],
        [8203, 79, 8203, 8203, 8203, 0, 0, 0, 0, 0, 0, 8203, 80,8201,8201, 8205, 8205, 0, 0, 0, 0],
        [49231, 232, 49232, 1, 49233, 0, 0, 0, 0, 0, 0, 49233, 224,4,5, 36, 36, 0, 0, 0, 0],
        [0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,0,1, 0, 1,  0, 0, 0, 0]
    )
}

#[test]
fn test_5() -> Field {
    main(
        1,
        [
        343432, 343433, 343434, 343435, 343436, 343437, 343438, 343439, 343440, 343441, 343442, 343443, 343444, 343445, 343446, 343447, 343448, 343449, 343450, 343451, 343452
    ],
        [8203, 79, 8203, 8203, 8203, 0, 0, 0, 0, 0, 0, 8203, 80,8201,8201, 8205, 8205, 0, 0, 0, 0],
        [49231, 232, 49232, 1, 49233, 0, 0, 0, 0, 0, 0, 49233, 224,5,6, 36, 36, 0, 0, 0, 0],
        [0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,0,1, 0, 1,  0, 0, 0, 0]
    )
}