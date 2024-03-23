mod addressing;
mod permutation;

struct Status {
    C: u16, // Carry
    Z: u16, // Zero
    I: u16, // Disable Interrupt
    D: u16, // Decimal Mode
    B: u16, // Break
    U: u16, // Unused
    V: u16, // Overflow
    N: u16, // Negative
}

unconstrained fn convert_to_status(n: Field) -> Status {
    let number = n as u16;
    let status = Status {
        C: number & 1,
        Z: number & 2,
        I: number & 4,
        D: number & 8,
        B: number & 16,
        U: number & 32,
        V: number & 64,
        N: number & 128
    };
    status
}

unconstrained fn status_to_num(status: Status) -> Field {
    let mut number = 0 as u16;
     number = number | status.C & 1;
     number = number | status.Z & 2;
     number = number | status.I & 4;
     number = number | status.D & 8;
     number = number | status.B & 16;
     number = number | status.U & 32;
     number = number | status.V & 64;
     number = number | status.N & 128;
     number as Field
}

fn compute_zn_status(number: Field, mut status: Status) -> Status {
    // let mut bits = 0 as u8;
    if (number == 0) {
        status.Z = 1;
        // bits = bits & 2;
    }
    if (number as u8 > 127) {
        status.N = 1;
        // bits = bits & 128;
    }
    // bits
    status
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

pub fn wrapping_dec_u8(a: Field, b: Field) -> WrapResult {
    let result = a - b;

    if (result as i32 < 0) {
        WrapResult {
            value: 255,
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
    op_sorted_addr: [Field; 2],
    op_sorted_val: [Field; 2],
    op_sorted_op_rw: [Field; 2],
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

fn compute_permutation_9(
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
fn compute_permutation_21(
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