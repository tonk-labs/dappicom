mod addressing;

// addressing helper function to select the addressing based on the mode 
pub fn addressing_helper(
    opcode: Field,
    mode: Field,
    op_sorted_addr: [Field; 8],
    op_sorted_val: [Field; 8],
    op_sorted_op_rw: [Field; 8]
) {
    if is_acc(opcode) == true {
        // NOPs
        for i in 0..7 {
            let mut sub_arr_addr: [Field; 1] = [0];
            let mut sub_arr_val: [Field; 1] = [0];
            let mut sub_arr_op_rw: [Field; 1] = [0];

            sub_arr_addr[0] = op_sorted_addr[i];
            sub_arr_val[0] = op_sorted_val[i];
            sub_arr_op_rw[0] = op_sorted_op_rw[i];

            addressing::circuit_NOP(sub_arr_addr, sub_arr_val, sub_arr_op_rw);
        }

        let mut arr_addr: [Field; 1] = [0];
        let mut arr_val: [Field; 1] = [0];
        let mut arr_op_rw: [Field; 1] = [0];

        arr_addr[0] = op_sorted_addr[7];
        arr_val[0] = op_sorted_val[7];
        arr_op_rw[0] = op_sorted_op_rw[7];

        addressing::acc(arr_addr, arr_val, arr_op_rw);
    } else if is_imp(opcode) == true {
        // NOPs

        for i in 0..6 {
            let mut sub_arr_addr: [Field; 1] = [0];
            let mut sub_arr_val: [Field; 1] = [0];
            let mut sub_arr_op_rw: [Field; 1] = [0];

            sub_arr_addr[0] = op_sorted_addr[i];
            sub_arr_val[0] = op_sorted_val[i];
            sub_arr_op_rw[0] = op_sorted_op_rw[i];

            addressing::circuit_NOP(sub_arr_addr, sub_arr_val, sub_arr_op_rw);
        }

        let mut arr_addr: [Field; 2] = [0, 0];
        let mut arr_val: [Field; 2] = [0, 0];
        let mut arr_op_rw: [Field; 2] = [0, 0];

        for i in 6..8 {
            arr_addr[i-6] = op_sorted_addr[i];
            arr_val[i-6] = op_sorted_val[i];
            arr_op_rw[i-6] = op_sorted_op_rw[i];
        }

        addressing::imp(arr_addr, arr_val, arr_op_rw);
    } else if is_imm(opcode) == true {
        //NOPs
        for i in 0..6 {
            let mut sub_arr_addr: [Field; 1] = [0];
            let mut sub_arr_val: [Field; 1] = [0];
            let mut sub_arr_op_rw: [Field; 1] = [0];

            sub_arr_addr[0] = op_sorted_addr[i];
            sub_arr_val[0] = op_sorted_val[i];
            sub_arr_op_rw[0] = op_sorted_op_rw[i];

            addressing::circuit_NOP(sub_arr_addr, sub_arr_val, sub_arr_op_rw);
        }

        let mut arr_addr: [Field; 2] = [0, 0];
        let mut arr_val: [Field; 2] = [0, 0];
        let mut arr_op_rw: [Field; 2] = [0, 0];

        for i in 6..8 {
            arr_addr[i-6] = op_sorted_addr[i];
            arr_val[i-6] = op_sorted_val[i];
            arr_op_rw[i-6] = op_sorted_op_rw[i];
        }

        addressing::imm(arr_addr, arr_val, arr_op_rw);
    } else if is_zpo(opcode) == true {
        //NOPs
        for i in 0..5 {
            let mut sub_arr_addr: [Field; 1] = [0];
            let mut sub_arr_val: [Field; 1] = [0];
            let mut sub_arr_op_rw: [Field; 1] = [0];

            sub_arr_addr[0] = op_sorted_addr[i];
            sub_arr_val[0] = op_sorted_val[i];
            sub_arr_op_rw[0] = op_sorted_op_rw[i];

            addressing::circuit_NOP(sub_arr_addr, sub_arr_val, sub_arr_op_rw);
        }

        let mut arr_addr: [Field; 3] = [0, 0, 0];
        let mut arr_val: [Field; 3] = [0, 0, 0];
        let mut arr_op_rw: [Field; 3] = [0, 0, 0];

        for i in 5..8 {
            arr_addr[i-5] = op_sorted_addr[i];
            arr_val[i-5] = op_sorted_val[i];
            arr_op_rw[i-5] = op_sorted_op_rw[i];
        }

        addressing::zpo(arr_addr, arr_val, arr_op_rw);
    } else if is_rel(opcode) == true {
        //NOPs
        for i in 0..5 {
            let mut sub_arr_addr: [Field; 1] = [0];
            let mut sub_arr_val: [Field; 1] = [0];
            let mut sub_arr_op_rw: [Field; 1] = [0];

            sub_arr_addr[0] = op_sorted_addr[i];
            sub_arr_val[0] = op_sorted_val[i];
            sub_arr_op_rw[0] = op_sorted_op_rw[i];

            addressing::circuit_NOP(sub_arr_addr, sub_arr_val, sub_arr_op_rw);
        }

        let mut arr_addr: [Field; 3] = [0, 0, 0];
        let mut arr_val: [Field; 3] = [0, 0, 0];
        let mut arr_op_rw: [Field; 3] = [0, 0, 0];

        for i in 5..8 {
            arr_addr[i-5] = op_sorted_addr[i];
            arr_val[i-5] = op_sorted_val[i];
            arr_op_rw[i-5] = op_sorted_op_rw[i];
        }

        addressing::rel(arr_addr, arr_val, arr_op_rw);
    } else if is_zpx_zpy(opcode) == true {
        //NOPs
        for i in 0..3 {
            let mut sub_arr_addr: [Field; 1] = [0];
            let mut sub_arr_val: [Field; 1] = [0];
            let mut sub_arr_op_rw: [Field; 1] = [0];

            sub_arr_addr[0] = op_sorted_addr[i];
            sub_arr_val[0] = op_sorted_val[i];
            sub_arr_op_rw[0] = op_sorted_op_rw[i];

            addressing::circuit_NOP(sub_arr_addr, sub_arr_val, sub_arr_op_rw);
        }

        let mut arr_addr: [Field; 5] = [0, 0, 0, 0, 0];
        let mut arr_val: [Field; 5] = [0, 0, 0, 0, 0];
        let mut arr_op_rw: [Field; 5] = [0, 0, 0, 0, 0];

        for i in 3..8 {
            arr_addr[i-3] = op_sorted_addr[i];
            arr_val[i-3] = op_sorted_val[i];
            arr_op_rw[i-3] = op_sorted_op_rw[i];
        }

        addressing::zpx_zpy(mode, arr_addr, arr_val, arr_op_rw);
    } else if is_abs(opcode) {
        //NOPs
        for i in 0..2 {
            let mut sub_arr_addr: [Field; 1] = [0];
            let mut sub_arr_val: [Field; 1] = [0];
            let mut sub_arr_op_rw: [Field; 1] = [0];

            sub_arr_addr[0] = op_sorted_addr[i];
            sub_arr_val[0] = op_sorted_val[i];
            sub_arr_op_rw[0] = op_sorted_op_rw[i];

            addressing::circuit_NOP(sub_arr_addr, sub_arr_val, sub_arr_op_rw);
        }

        let mut arr_addr: [Field; 5] = [0, 0, 0, 0, 0];
        let mut arr_val: [Field; 5] = [0, 0, 0, 0, 0];
        let mut arr_op_rw: [Field; 5] = [0, 0, 0, 0, 0];

        for i in 2..8 {
            arr_addr[i-2] = op_sorted_addr[i];
            arr_val[i-2] = op_sorted_val[i];
            arr_op_rw[i-2] = op_sorted_op_rw[i];
        }

        addressing::abs(arr_addr, arr_val, arr_op_rw);
    } else if is_abx_aby(opcode) {
        let mut arr_addr: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
        let mut arr_val: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
        let mut arr_op_rw: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];

        for i in 0..8 {
            arr_addr[i] = op_sorted_addr[i];
            arr_val[i] = op_sorted_val[i];
            arr_op_rw[i] = op_sorted_op_rw[i];
        }

        addressing::abx_aby(mode, arr_addr, arr_val, arr_op_rw);
    } else if is_ind(opcode) {
        let mut arr_addr: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
        let mut arr_val: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
        let mut arr_op_rw: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];

        for i in 0..8 {
            arr_addr[i] = op_sorted_addr[i];
            arr_val[i] = op_sorted_val[i];
            arr_op_rw[i] = op_sorted_op_rw[i];
        }

        addressing::ind(arr_addr, arr_val, arr_op_rw);
    } else if is_idx(opcode) {
        //NOPs
        for i in 0..1 {
            let mut sub_arr_addr: [Field; 1] = [0];
            let mut sub_arr_val: [Field; 1] = [0];
            let mut sub_arr_op_rw: [Field; 1] = [0];

            sub_arr_addr[0] = op_sorted_addr[i];
            sub_arr_val[0] = op_sorted_val[i];
            sub_arr_op_rw[0] = op_sorted_op_rw[i];

            addressing::circuit_NOP(sub_arr_addr, sub_arr_val, sub_arr_op_rw);
        }

        let mut arr_addr: [Field; 7] = [0, 0, 0, 0, 0, 0, 0];
        let mut arr_val: [Field; 7] = [0, 0, 0, 0, 0, 0, 0];
        let mut arr_op_rw: [Field;7] = [0, 0, 0, 0, 0, 0, 0];

        for i in 1..8 {
            arr_addr[i-1] = op_sorted_addr[i];
            arr_val[i-1] = op_sorted_val[i];
            arr_op_rw[i-1] = op_sorted_op_rw[i];
        }

        addressing::idx(arr_addr, arr_val, arr_op_rw);
    } else {
        //NOPs
        for i in 0..1 {
            let mut sub_arr_addr: [Field; 1] = [0];
            let mut sub_arr_val: [Field; 1] = [0];
            let mut sub_arr_op_rw: [Field; 1] = [0];

            sub_arr_addr[0] = op_sorted_addr[i];
            sub_arr_val[0] = op_sorted_val[i];
            sub_arr_op_rw[0] = op_sorted_op_rw[i];

            addressing::circuit_NOP(sub_arr_addr, sub_arr_val, sub_arr_op_rw);
        }

        let mut arr_addr: [Field; 7] = [0, 0, 0, 0, 0, 0, 0];
        let mut arr_val: [Field; 7] = [0, 0, 0, 0, 0, 0, 0];
        let mut arr_op_rw: [Field;7] = [0, 0, 0, 0, 0, 0, 0];

        for i in 1..8 {
            arr_addr[i-1] = op_sorted_addr[i];
            arr_val[i-1] = op_sorted_val[i];
            arr_op_rw[i-1] = op_sorted_op_rw[i];
        }

        addressing::idy(arr_addr, arr_val, arr_op_rw);
    }
}

// checker functions 

pub fn is_acc(opcode: Field) -> bool {
    const opcode_vec 
    false
}
pub fn is_imp(opcode: Field) -> bool {
    const opcode_vec
    false
}
pub fn is_imm(opcode: Field) -> bool {
    const opcode_vec
    false
}
pub fn is_zpo(opcode: Field) -> bool {
    const opcode_vec
    false
}
pub fn is_rel(opcode: Field) -> bool {
    const opcode_vec
    false
}
pub fn is_zpx_zpy(opcode: Field) -> bool {
    const opcode_vec
    false
}
pub fn is_abs(opcode: Field) -> bool {
    const opcode_vec
    false
}
pub fn is_abx_aby(opcode: Field) -> bool {
    const opcode_vec
    false
}
pub fn is_ind(opcode: Field) -> bool {
    const opcode_vec
    false
}
pub fn is_idx(opcode: Field) -> bool {
    const opcode_vec
    false
}
pub fn is_idy(opcode: Field) -> bool {
    const opcode_vec
    false
}

