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
        (op_sorted_val[1] == 198)
        | (op_sorted_val[1] == 214)
        | (op_sorted_val[1] == 206)
        | (op_sorted_val[1] == 222)
    );
    assert(op_sorted_op_rw[1] == 0);
    let addressing_option = op_sorted_val[1];

    //update the PC
    assert(op_sorted_addr[2] == 8203);
    assert(op_sorted_op_rw[2] == 1);
    assert(op_sorted_val[2] == pc + 1);

    // check for addressing and do the operation
    if addressing_option == 198 { //zero page

        // 5 nops added 

        for i in 3..8 {
            assert(op_sorted_op_rw[i] == 0);
            assert(op_sorted_addr[i] == 0);
        }

        let mut sub_arr_addr: [Field; 3] = [0, 0, 0];
        let mut sub_arr_val: [Field; 3] = [0, 0, 0];
        let mut sub_arr_op_rw: [Field; 3] = [0, 0, 0];
        let offset = 8;

        for i in 0..3 {
            sub_arr_addr[i] = op_sorted_addr[offset + i];
            sub_arr_val[i] = op_sorted_val[offset + i];
            sub_arr_op_rw[i] = op_sorted_op_rw[offset + i];
        }

        helpers::zpo(sub_arr_addr, sub_arr_val, sub_arr_op_rw);
    } else if addressing_option == 214 { //zero page X

        //3 nops added

        for i in 3..6 {
            assert(op_sorted_op_rw[i] == 0);
            assert(op_sorted_addr[i] == 0);
        }

        let mut sub_arr_addr: [Field; 5] = [0, 0, 0, 0, 0];
        let mut sub_arr_val: [Field; 5] = [0, 0, 0, 0, 0];
        let mut sub_arr_op_rw: [Field; 5] = [0, 0, 0, 0, 0];
        let offset = 6;

        for i in 0..5 {
            sub_arr_addr[i] = op_sorted_addr[offset + i];
            sub_arr_val[i] = op_sorted_val[offset + i];
            sub_arr_op_rw[i] = op_sorted_op_rw[offset + i];
        }
        // pass 1 for y and 0 for x
        helpers::zpx_zpy(1, sub_arr_addr, sub_arr_val, sub_arr_op_rw);
    } else if addressing_option == 206 { //absolute

        //2 nops added 

        for i in 3..5 {
            assert(op_sorted_op_rw[i] == 0);
            assert(op_sorted_addr[i] == 0);
        }

        let mut sub_arr_addr: [Field; 6] = [0, 0, 0, 0, 0, 0];
        let mut sub_arr_val: [Field; 6] = [0, 0, 0, 0, 0, 0];
        let mut sub_arr_op_rw: [Field; 6] = [0, 0, 0, 0, 0, 0];
        let offset = 5;

        for i in 0..6 {
            sub_arr_addr[i] = op_sorted_addr[offset + i];
            sub_arr_val[i] = op_sorted_val[offset + i];
            sub_arr_op_rw[i] = op_sorted_op_rw[offset + i];
        }

        helpers::abs(sub_arr_addr, sub_arr_val, sub_arr_op_rw);
    } else { //absolute X

        let mut sub_arr_addr: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
        let mut sub_arr_val: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
        let mut sub_arr_op_rw: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
        let offset = 3;

        for i in 0..8 {
            sub_arr_addr[i] = op_sorted_addr[offset + i];
            sub_arr_val[i] = op_sorted_val[offset + i];
            sub_arr_op_rw[i] = op_sorted_op_rw[offset + i];
        }

        helpers::abx_aby(1, sub_arr_addr, sub_arr_val, sub_arr_op_rw); // here something is returning  know why ?
    }

    // read the value from the memory
    // read from memory
    assert(op_sorted_addr[11] == 8204);
    assert(op_sorted_op_rw[11] == 0);
    let mem_val = op_sorted_val[11];

    // write to memory
    assert(op_sorted_addr[12] == 8204);
    assert(op_sorted_op_rw[12] == 1);
    let new_mem = helpers::wrapping_dec_u8(mem_val, 1);
    assert(op_sorted_val[12] == new_mem.value);

    //read status register
    assert(op_sorted_addr[13] == 8205);
    assert(op_sorted_op_rw[13] == 0);
    let sr = op_sorted_val[13];

    let mut status = helpers::convert_to_status(sr);

    //compute zero and negative flags
    status = helpers::compute_zn_status(new_mem.value, status);
    let comp_status = helpers::status_to_num(status);

    //write status register
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
        [8203, 79, 8203, 0, 0, 0, 0, 0, 8203, 49232, 8203, 8204, 8204, 8205, 8205],
        [49231, 198, 49232, 0, 0, 0, 0, 0, 49232, 13, 49233, 1, 0, 36, 38],
        [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1]
    )
}
#[test]
fn test_1() -> Field {
    main(
        1,
        [
        343492, 343493, 343494, 343495, 343496, 343497, 343498, 343499, 343500, 343501, 343502, 343503, 343504, 343505, 343506
    ],
        [8203, 79, 8203, 0, 0, 0, 8203, 49232, 8203, 13, 8202, 8204, 8204, 8205, 8205],
        [49231, 214, 49232, 0, 0, 0, 49232, 13, 49233, 0, 100, 2, 1, 36, 36],
        [0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1]
    )
}

#[test]
fn test_2() -> Field {
    main(
        1,
        [
        343552, 343553, 343554, 343555, 343556, 343557, 343558, 343559, 343560, 343561, 343562, 343563, 343564, 343565, 343566
    ],
        [8203, 79, 8203, 0, 0, 8203, 49232, 8203, 8203, 49233, 8203, 8204, 8204, 8205, 8205],
        [49231, 206, 49232, 0, 0, 49232, 1, 49233, 49233, 2, 49234, 4, 3, 36, 36],
        [0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1]
    )
}

#[test]
fn test_3() -> Field {
    main(
        1,
        [
        343612, 343613, 343614, 343615, 343616, 343617, 343618, 343619, 343620, 343621, 343622, 343623, 343624, 343625, 343626
    ],
        [8203, 79, 8203, 8203, 49232, 8203, 8203, 49233, 8203, 8202, 582, 8204, 8204, 8205, 8205],
        [49231, 222, 49232, 49232, 1, 49233, 49233, 2, 49234, 69, 80, 5, 4, 36, 36],
        [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1]
    )
}

