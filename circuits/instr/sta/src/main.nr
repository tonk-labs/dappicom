use dep::helpers;
use dep::std;

//PC = 8203
//X = 8201
//Y = 8202
//A = 8200
//SR = 8205
//M = 8204

fn main(
    r: Field,
    op_sorted_step: [Field; 15],
    op_sorted_addr: [Field; 15],
    op_sorted_val: [Field; 15],
    op_sorted_op_rw: [Field; 15]
) -> pub Field {
    //check the program counter
    assert(op_sorted_addr[0] == 8203);
    assert(op_sorted_op_rw[0] == 0);
    let pc = op_sorted_val[0];

    //check the opcode
    assert(
          (op_sorted_val[1] == 133) // zero page
        | (op_sorted_val[1] == 149) // zero page x
        | (op_sorted_val[1] == 141) // absolute
        | (op_sorted_val[1] == 157) // absolute X
        | (op_sorted_val[1] == 153) // absolute Y
        | (op_sorted_val[1] == 129) // indirect X
        | (op_sorted_val[1] == 145) // indirect Y  
    );
    assert(op_sorted_op_rw[1] == 0);
    let opcode = op_sorted_val[1];

    //update the PC
    assert(op_sorted_addr[2] == 8203);
    assert(op_sorted_op_rw[2] == 1);
    assert(op_sorted_val[2] == pc + 1);

    //check the mode
    assert(op_sorted_addr[3] == 8203);
    assert(op_sorted_op_rw[3] == 0);
    let mode = op_sorted_val[3];

    //update the PC
    assert(op_sorted_addr[4] == 8203);
    assert(op_sorted_op_rw[4] == 1);
    assert(op_sorted_val[4] == pc + 2);

    let mut sub_arr_addr: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
    let mut sub_arr_val: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
    let mut sub_arr_op_rw: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
    let offset = 5;

    for i in 0..8 {
        sub_arr_addr[i] = op_sorted_addr[offset + i];
        sub_arr_val[i] = op_sorted_val[offset + i];
        sub_arr_op_rw[i] = op_sorted_op_rw[offset + i];
    }

    helpers::addressing_helpers(opcode, mode, sub_arr_addr, sub_arr_val, sub_arr_op_rw);

    // read from accumulaor
    assert(op_sorted_addr[13] == 8200);
    assert(op_sorted_op_rw[13] == 0);
    let a = op_sorted_val[13];

    // write to memory
    assert(op_sorted_addr[14] == 8204);
    assert(op_sorted_op_rw[14] == 1);
    assert(op_sorted_val[14] == a);

    helpers::compute_permutation_15(
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
        343432, 343433, 343434, 343435, 343436, 343437, 343438, 343439, 343440, 343441, 343442, 343443, 343444, 343445, 343446
    ],
        [8203, 79, 8203,8203,8203, 0, 0, 0,0,0,8203,49233,8203,8200,8204],
        [49231, 133, 49232, 1, 49233,0, 0, 0,0,0, 49233,69,49234,567,567],
        [0, 0, 1, 0, 1, 0, 0, 0, 0, 0,0,0,1,0,1]
    )
}

#[test]
fn test_1() -> Field {
    main(
        1,
        [
        343492, 343493, 343494, 343495, 343496, 343497, 343498, 343499, 343500, 343501, 343502, 343503, 343504, 343505, 343506
    ],
        [8203, 79, 8203,8203,8203,0,0,0,8203,49233,8203,13,8202,8200,8204],
        [49231, 149 , 49232, 1, 49233,0,0,0,49233,13,49234,0,69,567,567],
        [0, 0, 1, 0, 1,0,0,0,0,0,1,0,0,0,1]
    )
}

#[test]
fn test_2() -> Field {
    main(
        1,
        [
        343552, 343553, 343554, 343555, 343556, 343557, 343558, 343559, 343560, 343561, 343562, 343563, 343564, 343565, 343566
    ],
        [8203, 79, 8203,8203,8203,0,0,8203,49233,8203,8203,49234, 8203,8200,8204],
        [49231, 141, 49232, 1, 49233,0,0,49233,1,49234,49234,2,49235,567,567],
        [0, 0, 1, 0, 1,0,0,0,0,1,0,0,1,0,1]
    )
}

#[test]
fn test_3() -> Field {
    main(
        1,
        [
        343612, 343613, 343614, 343615, 343616, 343617, 343618, 343619, 343620, 343621, 343622, 343623, 343624, 343625, 343626
    ],
        [8203, 79, 8203,8203,8203,8203, 49233, 8203, 8203, 49234, 8203, 8201, 582, 8200,8204],
        [49231, 157, 49232, 0, 49233,49233, 1, 49234, 49234, 2, 49235, 69, 80,567,567],
        [0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0,1]
    )
}

#[test]
fn test_4() -> Field {
    main(
        1,
        [
        343712, 343713, 343714, 343715, 343716, 343717, 343718, 343719, 343720, 343721, 343722, 343723, 343724, 343725, 343726 
    ],
        [8203,79,8203,8203,8203,8203, 49233, 8203, 8203, 49234, 8203, 8202, 582, 8200,8204],
        [49231,153, 49232,1,49233,49233, 1, 49234, 49234, 2, 49235, 69, 80,567,567],
        [0, 0, 1, 0, 1,  0, 0, 1, 0, 0, 1, 0, 0, 0,1]
    )
}

#[test]
fn test_5() -> Field {
    main(
        1,
        [
        343812, 343813, 343814, 343815, 343816, 343817, 343818, 343819, 343820, 343821, 343822, 343823, 343824, 343825, 343826
    ],
        [8203,79,8203,8203,8203,0,8203,49233,8203,5675,8201,5688,5689,8200,8204 ],
        [49231,129, 49232,1,49233,0,49233,5675,5676,69,13,1,2,567,567 ],
        [0, 0, 1, 0, 1, 0,0,0,1,0,0,0,0,0,1 ]
    )
}

#[test]
fn test_6() -> Field {
    main(
        1,
        [
        343912, 343913, 343914, 343915, 343916, 343917, 343918, 343919, 343920, 343921, 343922, 343923, 343924, 343925, 343926 
    ],
        [8203,79,8203,8203,8203,0,8203,49233,8203,5675,5676,8202,582,8200,8204 ],
        [49231,145, 49232,0,49233,0,49233,5675,5676,1,2,69,112,567,567 ],
        [0, 0, 1, 0, 1,0,0,0,1,0,0,0,0,0,1]
    )
}

