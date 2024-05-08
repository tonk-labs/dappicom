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
    let opcode_vec = [9 , 73 , 41];
    for i in 0..opcode_vec.len() {
        if opcode == opcode_vec[i] {
            res = true;
        }
    }
    res
}
pub fn is_zpo(opcode: Field) -> bool {
    let mut res = false;
    let opcode_vec = [198, 230 , 36 , 5 , 69 , 37];
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
    let opcode_vec = [214, 246 , 21 , 85 , 53];
    let mut res = false;
    for i in 0..opcode_vec.len() {
        if opcode == opcode_vec[i] {
            res = true;
        }
    }
    res
}
pub fn is_abs(opcode: Field) -> bool {
    let opcode_vec = [206, 238 , 44 , 13 , 77 , 45];
    let mut res = false;
    for i in 0..opcode_vec.len() {
        if opcode == opcode_vec[i] {
            res = true;
        }
    }
    res
}
pub fn is_abx_aby(opcode: Field) -> bool {
    let opcode_vec = [222, 254 , 29 , 25 , 93 , 89 , 61 , 57];
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
    let opcode_vec = [1 , 65 , 33];
    let mut res = false;
    for i in 0..opcode_vec.len() {
        if opcode == opcode_vec[i] {
            res = true;
        }
    }
    res
}
pub fn is_idy(opcode: Field) -> bool {
    let opcode_vec = [17 , 81 , 49];
    let mut res = false;
    for i in 0..opcode_vec.len() {
        if opcode == opcode_vec[i] {
            res = true;
        }
    }
    res
}

