use dep::helpers;


//PC = 8203
//X = 8201
//Y = 8202
//A = 8200
//SR = 8205
fn main(
    r: Field,
    op_sorted_step: [Field; 10],
    op_sorted_addr: [Field; 10],
    op_sorted_val: [Field; 10],
    op_sorted_op_rw: [Field; 10]
) -> pub Field {


    assert(op_sorted_addr[0] == 8203);
    // the value here should map to the addr of the next entry
    // but we need to implement "mapping" logic, and I don't
    // have good ideas on how to do that at present
    assert(op_sorted_op_rw[0] == 0);
    assert(op_sorted_op_rw[1] == 0);
    assert(op_sorted_val[1] == 232);

    let mut sub_arr_addr: [Field; 2] = [0,0];
    let mut sub_arr_val: [Field; 2] = [0,0];
    let mut sub_arr_op_rw: [Field; 2] = [0,0];
    for i in 2..3 {
        sub_arr_addr[i] = op_sorted_addr[i];
        sub_arr_val[i] = op_sorted_val[i];
        sub_arr_op_rw[i] = op_sorted_op_rw[i];
    }

    let address: Field = helpers::imm(
        sub_arr_addr,
        sub_arr_val,
        sub_arr_op_rw
    );

    // add the offset to the index
    index = index + address;

    // we perform a read of x
    assert(op_sorted_addr[index] == 8201);
    assert(op_sorted_op_rw[index] == 0);
    let value = op_sorted_val[index];
    index = index + 1;

    // we then perform a write of x + 1
    assert(op_sorted_addr[index] == 8201);
    assert(op_sorted_op_rw[index] == 1);
    let wadd = helpers::wrapping_add_u8(value, 1);
    assert(op_sorted_val[index] == wadd.value);
    index = index + 1;

    // we then set a new status into the status register 

    // first there is a read from the status register
    assert(op_sorted_addr[index] == 8205);
    assert(op_sorted_op_rw[index] == 0);
    let sr = op_sorted_val[index];
    index = index + 1;

    // next there is a write to the status register
    // we need to compute the zero and negative flag
    let zn = helpers::compute_zn_status(wadd.value);
    let srnew = helpers::update_status(sr, zn);
    assert(op_sorted_addr[index] == 8205);
    assert(op_sorted_op_rw[index] == 1);
    assert(op_sorted_val[index] == srnew);
    index = index + 1;

    // Compute permutation and return it
    helpers::compute_permutation(
        r,
        op_sorted_step,
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}

#[test]
fn test_0() {
    main(
        1,
        [405465, 405466, 405467, 405468, 405469, 405470, 405471, 405472, 405473, 405474, 405475],
        [8203, 79, 8205, 8203, 8203, 80, 8205, 8201, 8201, 8205, 8205],
        [49231, 232, 36, 49232, 49232, 224, 36, 0, 1, 36, 36],
        [0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1]
    )
}
#[test]
fn test_1() {
    main(
        1,
        [405540, 405541, 405542, 405543, 405544, 405545, 405546, 405547, 405548, 405549, 405550],
        [8203, 79, 8205, 8203, 8203, 80, 8205, 8201, 8201, 8205, 8205],
        [49231, 232, 36, 49232, 49232, 224, 36, 1, 2, 36, 36],
        [0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1]
    )
}
#[test]
fn test_2() {
    main(
        1,
        [405615, 405616, 405617, 405618, 405619, 405620, 405621, 405622, 405623, 405624, 405625],
        [8203, 79, 8205, 8203, 8203, 80, 8205, 8201, 8201, 8205, 8205],
        [49231, 232, 36, 49232, 49232, 224, 36, 2, 3, 36, 36],
        [0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1]
    )
}
#[test]
fn test_3() {
    main(
        1,
        [405690, 405691, 405692, 405693, 405694, 405695, 405696, 405697, 405698, 405699, 405700],
        [8203, 79, 8205, 8203, 8203, 80, 8205, 8201, 8201, 8205, 8205],
        [49231, 232, 36, 49232, 49232, 224, 36, 3, 4, 36, 36],
        [0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1]
    )
}
#[test]
fn test_4() {
    main(
        1,
        [405765, 405766, 405767, 405768, 405769, 405770, 405771, 405772, 405773, 405774, 405775],
        [8203, 79, 8205, 8203, 8203, 80, 8205, 8201, 8201, 8205, 8205],
        [49231, 232, 36, 49232, 49232, 224, 36, 4, 5, 36, 36],
        [0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1]
    )
}
#[test]
fn test_5() {
    main(
        1,
        [405840, 405841, 405842, 405843, 405844, 405845, 405846, 405847, 405848, 405849, 405850],
        [8203, 79, 8205, 8203, 8203, 80, 8205, 8201, 8201, 8205, 8205],
        [49231, 232, 36, 49232, 49232, 224, 36, 5, 6, 36, 36],
        [0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1]
    )
}