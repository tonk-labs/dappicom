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
          (op_sorted_val[1] == 36) //zero page
        | (op_sorted_val[1] == 44) //absolute
        
    );
    assert(op_sorted_op_rw[1] == 0);
    let opcode = op_sorted_val[1];

    //update the PC
    assert(op_sorted_addr[2] == 8203);
    assert(op_sorted_op_rw[2] == 1);
    assert(op_sorted_val[2] == pc + 1);

    let mut sub_arr_addr: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
    let mut sub_arr_val: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
    let mut sub_arr_op_rw: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
    let offset = 3;

    for i in 0..8 {
        sub_arr_addr[i] = op_sorted_addr[offset + i];
        sub_arr_val[i] = op_sorted_val[offset + i];
        sub_arr_op_rw[i] = op_sorted_op_rw[offset + i];
    }

    helpers::addressing_helpers(opcode, 0, sub_arr_addr, sub_arr_val, sub_arr_op_rw);

    // read from memory 
    assert(op_sorted_addr[11] == 8204);
    assert(op_sorted_op_rw[11] == 0);
    let mem_val = op_sorted_val[11];

    // read from accumulator
    assert(op_sorted_addr[12] == 8204);
    assert(op_sorted_op_rw[12] == 0);
    let acc_val = op_sorted_val[12];

    let res = helpers::wrapping_AND(mem_val,acc_val);

    //read status register 
    assert(op_sorted_addr[13] == 8205);
    assert(op_sorted_op_rw[13] == 0);
    let sr = op_sorted_val[13];

    let mut status = helpers::convert_to_status(sr);
    status = helpers::compute_ZNV_status(res.value, status , mem_val);
    let comp_status = helpers::status_to_num(status);

    // write to status register
    assert(op_sorted_addr[14] == 8205);
    assert(op_sorted_op_rw[14] == 1);
    assert(op_sorted_val[14] == comp_status);

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
        [8203, 79, 8203,0,0,0,0,0,8203,49232,8203 ,8204,8204,8205,8205],
        [49231, 36, 49232,0,0,0,0,0,49232,13,49233,14,14,36,36],
        [0, 0, 1,0,0,0,0,0,0,0,1,0,0,0,1 ]
    )
}

#[test]
fn test_1() -> Field {
    main(
        1,
        [
        343492, 343493, 343494, 343495, 343496, 343497, 343498, 343499, 343500, 343501, 343502, 343503, 343504, 343505, 343506
    ], 
        [8203, 79, 8203,0,0,0,0,0,8203,49232,8203 ,8204,8204,8205,8205],
        [49231, 36, 49232,0,0,0,0,0,49232,13,49233,0,14,36,38],
        [0, 0, 1,0,0,0,0,0,0,0,1,0,0,0,1 ]
    )
}

#[test]
fn test_2() -> Field {
    main(
        1,
        [
        343552, 343553, 343554, 343555, 343556, 343557, 343558, 343559, 343560, 343561, 343562, 343563, 343564, 343565, 343566
    ],
        [8203, 79, 8203,0,0,8203,49232,8203,8203,49233,8203,8204,8204,8205,8205],
        [49231, 44, 49232,0,0,49232,1,49233,49233,2,49234,14,14,36,36],
        [0, 0, 1,0,0,0,0,1,0,0,1,0,0,0,1]
    )
}

#[test]
fn test_3() -> Field {
    main(
        1,
        [
        343552, 343553, 343554, 343555, 343556, 343557, 343558, 343559, 343560, 343561, 343562, 343563, 343564, 343565, 343566
    ],
        [8203, 79, 8203,0,0,8203,49232,8203,8203,49233,8203,8204,8204,8205,8205],
        [49231, 44, 49232,0,0,49232,1,49233,49233,2,49234,0,14,36,38],
        [0, 0, 1,0,0,0,0,1,0,0,1,0,0,0,1]
    )
}

