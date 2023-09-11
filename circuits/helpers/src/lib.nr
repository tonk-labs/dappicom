mod addressing;
mod permutation;

fn compute_zn_status(number: Field) -> u8 {
    let mut bits = 0 as u8;
    if (number == 0) {
        bits = bits & 2;
    }
    if (number as u8 > 127) {
        bits = bits & 128;
    }
    bits
}

fn update_status(status: Field, new: u8)-> Field {
    ((status as u8) & new) as Field
}

fn wrapping_add_u16(a: Field, b: Field) -> Field {
    addressing::wrapping_add_u16(a, b)
}

struct WrapResult {
    value: Field,
    wrapped: bool
}

fn wrapping_add_u8(a: Field, b: Field) -> WrapResult {
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

fn acc(
    op_sorted_addr: [Field; 1],
    op_sorted_val: [Field; 1],
    op_sorted_op_rw: [Field; 1],
) {
    addressing::acc(
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}
fn imp(
    op_sorted_addr: [Field; 1],
    op_sorted_val: [Field; 1],
    op_sorted_op_rw: [Field; 1],
) {
    addressing::imp(
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}
fn imm(
    op_sorted_addr: [Field; 2],
    op_sorted_val: [Field; 2],
    op_sorted_op_rw: [Field; 2],
) -> Field {
    addressing::imm(
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}
fn zpo(
    op_sorted_addr: [Field; 3],
    op_sorted_val: [Field; 3],
    op_sorted_op_rw: [Field; 3],
) -> Field {
    addressing::zpo(
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}
fn zpx_zpy(
    mode: Field,
    op_sorted_addr: [Field; 5],
    op_sorted_val: [Field; 5],
    op_sorted_op_rw: [Field; 5],
) -> Field {
    addressing::zpx_zpy(
        mode,
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}
fn rel(
    op_sorted_addr: [Field; 3],
    op_sorted_val: [Field; 3],
    op_sorted_op_rw: [Field; 3],
) -> Field {
    addressing::rel(
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}
fn abs(
    op_sorted_addr: [Field; 6],
    op_sorted_val: [Field; 6],
    op_sorted_op_rw: [Field; 6],
) -> Field {
    addressing::abs(
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}
fn abx_aby(
    mode: Field,
    op_sorted_addr: [Field; 8],
    op_sorted_val: [Field; 8],
    op_sorted_op_rw: [Field; 8],
) -> [Field; 2] {
    addressing::abx_aby(
        mode,
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}
fn ind(
    op_sorted_addr: [Field; 8],
    op_sorted_val: [Field; 8],
    op_sorted_op_rw: [Field; 8],
) -> Field {
    addressing::ind(
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}
fn idx(
    op_sorted_addr: [Field; 7],
    op_sorted_val: [Field; 7],
    op_sorted_op_rw: [Field; 7],
) -> Field {
    addressing::idx(
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}
fn idy(
    op_sorted_addr: [Field; 7],
    op_sorted_val: [Field; 7],
    op_sorted_op_rw: [Field; 7],
) -> [Field; 2] {
    addressing::idy(
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