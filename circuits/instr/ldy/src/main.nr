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
    op_sorted_step: [Field; 21],
    op_sorted_addr: [Field; 21],
    op_sorted_val: [Field; 21],
    op_sorted_op_rw: [Field; 21]
) -> pub Field {
    //check the program counter
    assert(op_sorted_addr[0] == 8203);
    assert(op_sorted_op_rw[0] == 0);
    let pc = op_sorted_val[0];

    //check the opcode
    assert(
        (op_sorted_val[1] == 160) // immediate
        | (op_sorted_val[1] == 164) // zero page
        | (op_sorted_val[1] == 180) // zero page x
        | (op_sorted_val[1] == 172) // absolute
        | (op_sorted_val[1] == 188) // absolute X
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

    // read from memory
    assert(op_sorted_addr[13] == 8204);
    assert(op_sorted_op_rw[13] == 0);
    let mem_val = op_sorted_val[13];

    // write to Y
    assert(op_sorted_addr[14] == 8202);
    assert(op_sorted_op_rw[14] == 1);
    assert(op_sorted_val[14] == mem_val);

    // read from status register
    assert(op_sorted_addr[15] == 8205);
    assert(op_sorted_op_rw[15] == 0);
    let sr = op_sorted_val[15];

    let mut status = helpers::convert_to_status(sr);
    status = helpers::compute_zn_status(mem_val, status);
    let comp_status = helpers::status_to_num(status);

    // update the status register
    assert(op_sorted_addr[16] == 8205);
    assert(op_sorted_op_rw[16] == 1);
    assert(op_sorted_val[16] == comp_status);
    
    for i in 17..21 {
        assert(op_sorted_addr[i] == 0);
        assert(op_sorted_val[i] == 0);
        assert(op_sorted_op_rw[i] == 0);
    }

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
        343432, 343433, 343434, 343435, 343436, 343437, 343438, 343439, 343440, 343441, 343442, 343443, 343444, 343445, 343446,343447, 343448 , 343449, 343450, 343451, 343452
    ],
        [8203, 79, 8203,8203,8203, 0, 0, 0, 0, 0,0,8203,8203,8204,8202,8205,8205,0,0,0,0],
        [49231, 160, 49232, 1, 49233, 0, 0, 0, 0, 0,0,49233,49234,34,34,36,36,0,0,0,0],
        [0, 0, 1, 0, 1, 0, 0, 0, 0, 0,0,0,1,0,1,0,1,0,0,0,0]
    )
}

#[test]
fn test_1() -> Field {
    main(
        1,
        [
        343492, 343493, 343494, 343495, 343496, 343497, 343498, 343499, 343500, 343501, 343502, 343503, 343504, 343505, 343506, 343507, 343508 , 343509, 343510, 343511, 343512
    ],
        [8203, 79, 8203,8203,8203, 0, 0, 0,0,0,8203,49233,8203 ,8204,8202,8205,8205,0,0,0,0],
        [49231, 164 , 49232, 1, 49233, 0, 0, 0,0,0, 49233,69,49234,34,34,36,36,0,0,0,0],
        [0, 0, 1, 0, 1, 0, 0, 0,0,0,0,0,1,0,1,0,1,0,0,0,0]
    )
}

#[test]
fn test_2() -> Field {
    main(
        1,
        [
        343552, 343553, 343554, 343555, 343556, 343557, 343558, 343559, 343560, 343561, 343562, 343563, 343564, 343565, 343566, 343567, 343568 , 343569, 343570, 343571, 343572
    ],
        [8203, 79, 8203,8203,8203,0,0,0,8203,49233,8203,13,8202,8204,8202,8205,8205,0,0,0,0],
        [49231, 180, 49232, 1, 49233,0,0,0,49233,13,49234,0,69,34,34,36,36,0,0,0,0],
        [0, 0, 1, 0, 1,0,0,0,0,0,1,0,0,0,1,0,1,0,0,0,0]
    )
}

#[test]
fn test_3() -> Field {
    main(
        1,
        [
        343612, 343613, 343614, 343615, 343616, 343617, 343618, 343619, 343620, 343621, 343622, 343623, 343624, 343625, 343626, 343627, 343628 , 343629, 343630, 343631, 343632
    ],
        [8203, 79, 8203,8203,8203,0,0,8203,49233,8203,8203,49234, 8203,8204,8202,8205,8205,0,0,0,0],
        [49231, 172, 49232, 1, 49233,0,0,49233,1,49234,49234,2,49235,34,34,36,36,0,0,0,0],
        [0, 0, 1, 0, 1,0,0,0,0,1,0,0,1,0,1,0,1,0,0,0,0]
    )
}

#[test]
fn test_4() -> Field {
    main(
        1,
        [
        343712, 343713, 343714, 343715, 343716, 343717, 343718, 343719, 343720, 343721, 343722, 343723, 343724, 343725, 343726, 343727, 343728 , 343729, 343730, 343731, 343732
    ],
        [8203,79,8203,8203,8203,8203, 49233, 8203, 8203, 49234, 8203, 8201, 582,8204,8202,8205,8205,0,0,0,0],
        [49231,188, 49232,0,49233,49233, 1, 49234, 49234, 2, 49235, 69, 80,34,34,36,36,0,0,0,0],
        [0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0,0,1,0,1,0,0,0,0]
    )
}


