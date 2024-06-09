use dep::helpers;
use dep::std;


//PC = 8203
//X = 8201
//Y = 8202
//A = 8200
//SR = 8205

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
    assert(op_sorted_val[1] == 136);  //0x88
    assert(op_sorted_op_rw[1] == 0); 
    let opcode = op_sorted_val[1];
    
    //update the PC
    assert(op_sorted_addr[2] == 8203);
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
     
    // read y
    assert(op_sorted_addr[13] == 8202);
    assert(op_sorted_op_rw[13] == 0);
    let value = op_sorted_val[13];
    
    // write y
    assert(op_sorted_addr[14] == 8202);
    assert(op_sorted_op_rw[14] == 1);
    let wadd = helpers::wrapping_dec_u8(value, 1);
    assert(op_sorted_val[14] == wadd.value);

    //read status register
    assert(op_sorted_addr[15] == 8205);
    assert(op_sorted_op_rw[15] == 0);
    let sr = op_sorted_val[15];
    
    let mut status = helpers::convert_to_status(sr);
    
    //compute zero and negative flags
    status = helpers::compute_zn_status(wadd.value, status);
    let comp_status = helpers::status_to_num(status);

    //write on status register 
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
        343432, 343433, 343434, 343435, 343436, 343437, 343438, 343439, 343440, 343441, 343442, 343443, 343444, 343445, 343446, 343447, 343448, 343449, 343450, 343451, 343452
    ],
        [8203, 79, 8203, 8203, 8203, 0, 0, 0, 0, 0, 0, 8203, 80,8202,8202, 8205, 8205, 0, 0, 0, 0],
        [49231, 136, 49232, 1, 49233, 0, 0, 0, 0, 0, 0, 49233, 224,127,126, 36, 36, 0, 0, 0, 0],
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
        [8203, 79, 8203, 8203, 8203, 0, 0, 0, 0, 0, 0, 8203, 80,8202,8202, 8205, 8205, 0, 0, 0, 0],
        [49231, 136, 49232, 1, 49233, 0, 0, 0, 0, 0, 0, 49233, 224,126,125, 36, 36, 0, 0, 0, 0],
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
        [8203, 79, 8203, 8203, 8203, 0, 0, 0, 0, 0, 0, 8203, 80,8202,8202, 8205, 8205, 0, 0, 0, 0],
        [49231, 136, 49232, 1, 49233, 0, 0, 0, 0, 0, 0, 49233, 224,125,124, 36, 36, 0, 0, 0, 0],
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
        [8203, 79, 8203, 8203, 8203, 0, 0, 0, 0, 0, 0, 8203, 80,8202,8202, 8205, 8205, 0, 0, 0, 0],
        [49231, 136, 49232, 1, 49233, 0, 0, 0, 0, 0, 0, 49233, 224,124,123, 36, 36, 0, 0, 0, 0],
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
        [8203, 79, 8203, 8203, 8203, 0, 0, 0, 0, 0, 0, 8203, 80,8202,8202, 8205, 8205, 0, 0, 0, 0],
        [49231, 136, 49232, 1, 49233, 0, 0, 0, 0, 0, 0, 49233, 224,123,122, 36, 36, 0, 0, 0, 0],
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
        [8203, 79, 8203, 8203, 8203, 0, 0, 0, 0, 0, 0, 8203, 80,8202,8202, 8205, 8205, 0, 0, 0, 0],
        [49231, 136, 49232, 1, 49233, 0, 0, 0, 0, 0, 0, 49233, 224,122,121, 36, 36, 0, 0, 0, 0],
        [0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,0,1, 0, 1,  0, 0, 0, 0]
    )
}

