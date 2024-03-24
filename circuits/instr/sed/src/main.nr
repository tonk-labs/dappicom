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
    op_sorted_step: [Field; 7],
    op_sorted_addr: [Field; 7],
    op_sorted_val: [Field; 7],
    op_sorted_op_rw: [Field; 7]
) -> pub Field {

  //check the program counter
    assert(op_sorted_addr[0] == 8203);
    assert(op_sorted_op_rw[0] == 0);
    let pc = op_sorted_val[0];

    //check the opcode 
    assert(op_sorted_val[1] == 248);  //0xF8
    assert(op_sorted_op_rw[1] == 0); 
    
    //update the PC
    assert(op_sorted_addr[2] == 8203);
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

    //read status register
    assert(op_sorted_addr[5] == 8205);
    assert(op_sorted_op_rw[5] == 0);
    let sr = op_sorted_val[5];

    let mut status = helpers::convert_to_status(sr);
    
    //set the decimal bit
    status = helpers::set_decimal_bit(status);
    let comp_status = helpers::status_to_num(status);

    //write on status register 
    assert(op_sorted_addr[6] == 8205);
    assert(op_sorted_op_rw[6] == 1);
    assert(op_sorted_val[6] == comp_status);

    helpers::compute_permutation_7(
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
        [343432, 343433, 343434, 343435, 343436, 343437, 343438],
        [8203, 79, 8203, 8203, 80, 8205, 8205],
        [49231, 248, 49232, 49232, 224, 38, 46],
        [0, 0, 1, 0, 0, 0, 1]
    )
}
#[test]
fn test_1() -> Field {
    main(
        1,
        [343492, 343493, 343494, 343495, 343496, 343497, 343498],
        [8203, 79, 8203, 8203, 80, 8205, 8205],
        [49231, 248, 49232, 49232, 224, 1, 9],
        [0, 0, 1, 0, 0, 0, 1]
    )
}
#[test]
fn test_2() -> Field {
    main(
        1,
        [343552, 343553, 343554, 343555, 343556, 343557, 343558],
        [8203, 79, 8203, 8203, 80, 8205, 8205],
        [49231, 248, 49232, 49232, 224, 255, 255],
        [0, 0, 1, 0, 0, 0, 1]
    )
}
#[test]
fn test_3() -> Field {
    main(
        1,
        [343612, 343613, 343614, 343615, 343616, 343617, 343618],
        [8203, 79, 8203, 8203, 80, 8205, 8205],
        [49231, 248, 49232, 49232, 224, 123, 131],
        [0, 0, 1, 0, 0, 0, 1]
    )
}
#[test]
fn test_4() -> Field {
    main(
        1,
        [343672, 343673, 343674, 343675, 343676, 343677, 343678],
        [8203, 79, 8203, 8203, 80, 8205, 8205],
        [49231, 248, 49232, 49232, 224, 0, 8],
        [0, 0, 1, 0, 0, 0, 1]
    )
}
#[test]
fn test_5() -> Field {
    main(
        1,
        [343732, 343733, 343734, 343735, 343736, 343737, 343738],
        [8203, 79, 8203, 8203, 80, 8205, 8205],
        [49231, 248, 49232, 49232, 224, 36, 44],
        [0, 0, 1, 0, 0, 0, 1]
    )
}


