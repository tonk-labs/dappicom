// checker functions 

pub fn is_acc(opcode: Field) -> bool {
    let mut res = false;
    let opcode_vec = [];
    for i in 0..opcode_vec.len() {
        if opcode == opcode_vec[i] {
            res = true;
        }
    }
    res
}
pub fn is_imp(opcode: Field) -> bool {
    let opcode_vec = [202, 136, 24, 216, 88, 184, 232, 200, 56, 248, 120, 170, 168, 138];
    let mut res = false;
    for i in 0..opcode_vec.len() {
        if opcode == opcode_vec[i] {
            res = true;
        }
    }
    res
}
pub fn is_imm(opcode: Field) -> bool {
    let mut res = false;
    let opcode_vec = [];
    for i in 0..opcode_vec.len() {
        if opcode == opcode_vec[i] {
            res = true;
        }
    }
    res
}
pub fn is_zpo(opcode: Field) -> bool {
    let mut res = false;
    let opcode_vec = [];
    for i in 0..opcode_vec.len() {
        if opcode == opcode_vec[i] {
            res = true;
        }
    }
    res
}
pub fn is_rel(opcode: Field) -> bool {
    let mut res = false;
    let opcode_vec = [];
    for i in 0..opcode_vec.len() {
        if opcode == opcode_vec[i] {
            res = true;
        }
    }
    res
}
pub fn is_zpx_zpy(opcode: Field) -> bool {
    let opcode_vec = [214, 246];
    let mut res = false;
    for i in 0..opcode_vec.len() {
        if opcode == opcode_vec[i] {
            res = true;
        }
    }
    res
}
pub fn is_abs(opcode: Field) -> bool {
    let opcode_vec = [206, 238];
    let mut res = false;
    for i in 0..opcode_vec.len() {
        if opcode == opcode_vec[i] {
            res = true;
        }
    }
    res
}
pub fn is_abx_aby(opcode: Field) -> bool {
    let opcode_vec = [222, 254];
    let mut res = false;
    for i in 0..opcode_vec.len() {
        if opcode == opcode_vec[i] {
            res = true;
        }
    }
    res
}
pub fn is_ind(opcode: Field) -> bool {
    let opcode_vec = [];
    let mut res = false;
    for i in 0..opcode_vec.len() {
        if opcode == opcode_vec[i] {
            res = true;
        }
    }
    res
}
pub fn is_idx(opcode: Field) -> bool {
    let opcode_vec = [];
    let mut res = false;
    for i in 0..opcode_vec.len() {
        if opcode == opcode_vec[i] {
            res = true;
        }
    }
    res
}
pub fn is_idy(opcode: Field) -> bool {
    let opcode_vec = [];
    let mut res = false;
    for i in 0..opcode_vec.len() {
        if opcode == opcode_vec[i] {
            res = true;
        }
    }
    res
}

