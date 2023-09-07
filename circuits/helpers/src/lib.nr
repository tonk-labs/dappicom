mod addressing;
mod permutation;

unconstrained fn compute_zn_status(number: Field) -> u8 {
    let bits = 0 as u8;
    if (number == 0) {
        bits = bits & 2;
    }
    if (number > 127) {
        bits = bits & 128;
    }
    bits
}

unconstrained fn update_status(status: Field, new: u8)-> Field {
    ((status as u8) & new) as Field
}

unconstrained fn wrapping_add_u16(a: Field, b: Field) -> Field {
    addressing::wrapping_add_u16(a, b)
}

struct WrapResult {
    value: Field,
    wrapped: bool
}

unconstrained fn wrapping_add_u8(a: Field, b: Field) -> WrapResult {
    let max = 255;
    let result = a + b;
    if (result as u16 > 255) {
        WrapResult {
            value: 0,
            wrapped: true,
        }
    } else {
        WrapResult {
            value: result,
            wrapped: false,
        }
    }
}

fn get_addressing(
    mode: Field,
    op_sorted_step: [Field; 7],
    op_sorted_addr: [Field; 7],
    op_sorted_val: [Field; 7],
    op_sorted_op_rw: [Field; 7],
// Returns (Address, Value — for ABY,ABX, and IDY)
) -> [Field; 2] {
    addressing::run(
        mode,
        op_sorted_step,
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}

fn compute_permutation(
    r: Field,
    op_sorted_step: [Field; 21],
    op_sorted_addr: [Field; 21],
    op_sorted_val: [Field; 21],
    op_sorted_op_rw: [Field; 21]
) -> Field {
    permutation::compute(
        r,
        op_sorted_step,
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}