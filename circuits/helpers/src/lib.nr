mod addressing;
mod permutation;
mod addressing_helper;

struct Status {
    C: u32, // Carry
    Z: u32, // Zero
    I: u32, // Disable Interrupt
    D: u32, // Decimal Mode
    B: u32, // Break
    U: u32, // Unused
    V: u32, // Overflow
    N: u32, // Negative
}

unconstrained pub fn convert_to_status(n: Field) -> Status {
    let number = n as u32;
    let status = Status {
        C: number & 1,
        Z: (number >> 1) & 1,
        I: (number >> 2) & 1,
        D: (number >> 3) & 1,
        B: (number >> 4) & 1,
        U: (number >> 5) & 1,
        V: (number >> 6) & 1,
        N: (number >> 7) & 1
    };
    status
}

#[test]
fn test_convert_to_status() {
    let sr = 0x26; // 0 0 1 0 0 1 1 0 -> 0 1 1 0 0 1 0 0 reversed

    let status = convert_to_status(sr);
    assert(status.C == 0);
    assert(status.Z == 1);
    assert(status.I == 1);
    assert(status.D == 0);
    assert(status.B == 0);
    assert(status.U == 1);
    assert(status.V == 0);
    assert(status.N == 0);
}

unconstrained pub fn status_to_num(status: Status) -> Field {
    let mut number = 0 as u32;
    number = number | status.C & 1;
    number = number | (status.Z << 1);
    number = number | (status.I  << 2);
    number = number | (status.D  << 3);
    number = number | (status.B  << 4);
    number = number | (status.U  << 5);
    number = number | (status.V  << 6);
    number = number | (status.N  << 7);
    number as Field
}

#[test]
fn test_status_to_num() {
    let status = Status { C: 0, Z: 1, I: 1, D: 0, B: 0, U: 1, V: 0, N: 1 };
    let num = status_to_num(status);

    assert(num == 0xa6); // 1 0 1 0 0 1 1 0 -> 0 1 1 0 0 1 0 1 reversed
}

pub fn compute_zn_status(number: Field, mut status: Status) -> Status {
    // let mut bits = 0 as u8;
    if (number == 0) {
        status.Z = 1;
        // bits = bits & 2;
    } else {
        status.Z = 0;
    }

    if (number as u8 > 127) {
        status.N = 1;
        // bits = bits & 128;
    } else {
        status.N = 0;
    }
    // bits
    status
}

#[test]
fn test_compute_sn_empty_status() {
    let status = Status { C: 0, Z: 0, I: 0, D: 0, B: 0, U: 0, V: 0, N: 0 };

    let computed_status = compute_zn_status(0, status);
    assert(computed_status.Z == 1);

    let computed_status = compute_zn_status(200, status);
    assert(computed_status.N == 1);
}

#[test]
fn test_compute_sn_non_empty_status() {
    let status = Status { C: 1, Z: 1, I: 1, D: 1, B: 1, U: 1, V: 1, N: 1 };

    // should reverse Z
    let computed_status = compute_zn_status(1, status);
    assert(computed_status.Z == 0);
    assert(computed_status.N == 0);
}

#[test]

fn test_changes_in_not_Power_of_two() {
    let status = Status { C: 0, Z: 1, I: 1, D: 0, B: 0, U: 1, V: 0, N: 1 };

    let num = status_to_num(status);

    assert(num == 0xa6); // 1 0 1 0 0 1 1 0 -> 0 1 1 0 0 1 0 1 reversed

    let mut new_status = status;

    new_status.D = 1;
    new_status.I = 0;

    let num2 = status_to_num(new_status);

    assert(num2 == 0xaa);
}

pub fn wrapping_add_u16(a: Field, b: Field) -> Field {
    addressing::wrapping_add_u16(a, b)
}

struct WrapResult {
    value: Field,
    wrapped: bool
}

pub fn wrapping_add_u8(a: Field, b: Field) -> WrapResult {
    let max = 255;
    let result = a + b;
    if (result as u32 > max) {
        WrapResult { value: 0, wrapped: true }
    } else {
        WrapResult { value: result, wrapped: false }
    }
}

pub fn wrapping_dec_u8(a: Field, b: Field) -> WrapResult {
    let result = a - b;

    if (result as i32 < 0) {
        WrapResult { value: 255, wrapped: true }
    } else {
        WrapResult { value: result, wrapped: false }
    }
}

pub fn clear_interrupt_bit(mut status: Status) -> Status {
    status.I = 0;

    status
}

pub fn clear_overflow_bit(mut status: Status) -> Status {
    status.V = 0;

    status
}

pub fn clear_carry_bit(mut status: Status) -> Status {
    status.C = 0;

    status
}

pub fn clear_decimal_bit(mut status: Status) -> Status {
    status.D = 0;

    status
}

pub fn set_carry_bit(mut status: Status) -> Status {
    if (status.C == 0) {
        status.C = 1;
    }

    status
}

pub fn set_decimal_bit(mut status: Status) -> Status {
    if (status.D == 0) {
        status.D = 1;
    }

    status
}

pub fn set_interrupt_bit(mut status: Status) -> Status {
    if (status.I == 0) {
        status.I = 1;
    }

    status
}

pub fn acc(op_sorted_addr: [Field; 1], op_sorted_val: [Field; 1], op_sorted_op_rw: [Field; 1]) {
    addressing::acc(op_sorted_addr, op_sorted_val, op_sorted_op_rw)
}
pub fn imp(op_sorted_addr: [Field; 2], op_sorted_val: [Field; 2], op_sorted_op_rw: [Field; 2]) {
    addressing::imp(op_sorted_addr, op_sorted_val, op_sorted_op_rw)
}
pub fn imm(op_sorted_addr: [Field; 2], op_sorted_val: [Field; 2], op_sorted_op_rw: [Field; 2]) -> Field {
    addressing::imm(op_sorted_addr, op_sorted_val, op_sorted_op_rw)
}
pub fn zpo(op_sorted_addr: [Field; 3], op_sorted_val: [Field; 3], op_sorted_op_rw: [Field; 3]) -> Field {
    addressing::zpo(op_sorted_addr, op_sorted_val, op_sorted_op_rw)
}
pub fn zpx_zpy(
    mode: Field,
    op_sorted_addr: [Field; 5],
    op_sorted_val: [Field; 5],
    op_sorted_op_rw: [Field; 5]
) -> Field {
    addressing::zpx_zpy(mode, op_sorted_addr, op_sorted_val, op_sorted_op_rw)
}
pub fn rel(op_sorted_addr: [Field; 3], op_sorted_val: [Field; 3], op_sorted_op_rw: [Field; 3]) -> Field {
    addressing::rel(op_sorted_addr, op_sorted_val, op_sorted_op_rw)
}
pub fn abs(op_sorted_addr: [Field; 6], op_sorted_val: [Field; 6], op_sorted_op_rw: [Field; 6]) -> Field {
    addressing::abs(op_sorted_addr, op_sorted_val, op_sorted_op_rw)
}
pub fn abx_aby(
    mode: Field,
    op_sorted_addr: [Field; 8],
    op_sorted_val: [Field; 8],
    op_sorted_op_rw: [Field; 8]
) -> [Field; 2] {
    addressing::abx_aby(mode, op_sorted_addr, op_sorted_val, op_sorted_op_rw)
}
pub fn ind(op_sorted_addr: [Field; 8], op_sorted_val: [Field; 8], op_sorted_op_rw: [Field; 8]) -> Field {
    addressing::ind(op_sorted_addr, op_sorted_val, op_sorted_op_rw)
}
pub fn idx(op_sorted_addr: [Field; 7], op_sorted_val: [Field; 7], op_sorted_op_rw: [Field; 7]) -> Field {
    addressing::idx(op_sorted_addr, op_sorted_val, op_sorted_op_rw)
}
pub fn idy(
    op_sorted_addr: [Field; 7],
    op_sorted_val: [Field; 7],
    op_sorted_op_rw: [Field; 7]
) -> [Field; 2] {
    addressing::idy(op_sorted_addr, op_sorted_val, op_sorted_op_rw)
}

// addressing helper function to select the addressing based on the mode 
pub fn addressing_helpers(
    opcode: Field,
    mode: Field,
    op_sorted_addr: [Field; 8],
    op_sorted_val: [Field; 8],
    op_sorted_op_rw: [Field; 8]
) {
    if addressing_helper::is_acc(opcode) == true {
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
    } else if addressing_helper::is_imp(opcode) == true {
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
    } else if addressing_helper::is_imm(opcode) == true {
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
    } else if addressing_helper::is_zpo(opcode) == true {
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
    } else if addressing_helper::is_rel(opcode) == true {
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
    } else if addressing_helper::is_zpx_zpy(opcode) == true {
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
    } else if addressing_helper::is_abs(opcode) {
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

        let mut arr_addr: [Field; 6] = [0, 0, 0, 0, 0, 0];
        let mut arr_val: [Field; 6] = [0, 0, 0, 0, 0, 0];
        let mut arr_op_rw: [Field; 6] = [0, 0, 0, 0, 0, 0];

        for i in 2..8 {
            arr_addr[i-2] = op_sorted_addr[i];
            arr_val[i-2] = op_sorted_val[i];
            arr_op_rw[i-2] = op_sorted_op_rw[i];
        }

        addressing::abs(arr_addr, arr_val, arr_op_rw);
    } else if addressing_helper::is_abx_aby(opcode) {
        let mut arr_addr: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
        let mut arr_val: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
        let mut arr_op_rw: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];

        for i in 0..8 {
            arr_addr[i] = op_sorted_addr[i];
            arr_val[i] = op_sorted_val[i];
            arr_op_rw[i] = op_sorted_op_rw[i];
        }

        addressing::abx_aby(mode, arr_addr, arr_val, arr_op_rw);
    } else if addressing_helper::is_ind(opcode) {
        let mut arr_addr: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
        let mut arr_val: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];
        let mut arr_op_rw: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];

        for i in 0..8 {
            arr_addr[i] = op_sorted_addr[i];
            arr_val[i] = op_sorted_val[i];
            arr_op_rw[i] = op_sorted_op_rw[i];
        }

        addressing::ind(arr_addr, arr_val, arr_op_rw);
    } else if addressing_helper::is_idx(opcode) {
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

pub fn compute_permutation_9(
    r: Field,
    op_sorted_step: [Field; 9],
    op_sorted_addr: [Field; 9],
    op_sorted_val: [Field; 9],
    op_sorted_op_rw: [Field; 9]
) -> Field {
    permutation::compute_9(
        r,
        op_sorted_step,
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}

pub fn compute_permutation_21(
    r: Field,
    op_sorted_step: [Field; 21],
    op_sorted_addr: [Field; 21],
    op_sorted_val: [Field; 21],
    op_sorted_op_rw: [Field; 21]
) -> Field {
    permutation::compute_21(
        r,
        op_sorted_step,
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}

pub fn compute_permutation_7(
    r: Field,
    op_sorted_step: [Field; 7],
    op_sorted_addr: [Field; 7],
    op_sorted_val: [Field; 7],
    op_sorted_op_rw: [Field; 7]
) -> Field {
    permutation::compute_7(
        r,
        op_sorted_step,
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}

pub fn compute_permutation_17(
    r: Field,
    op_sorted_step: [Field; 17],
    op_sorted_addr: [Field; 17],
    op_sorted_val: [Field; 17],
    op_sorted_op_rw: [Field; 17]
) -> Field {
    permutation::compute_17(
        r,
        op_sorted_step,
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}

pub fn compute_permutation_15(
    r: Field,
    op_sorted_step: [Field; 15],
    op_sorted_addr: [Field; 15],
    op_sorted_val: [Field; 15],
    op_sorted_op_rw: [Field; 15]
) -> Field {
    permutation::compute_15(
        r,
        op_sorted_step,
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}
