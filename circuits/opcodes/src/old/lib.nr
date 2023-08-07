mod ldx;
mod inx;
mod stx;

fn op_ldx(
    //we assume for now the number of memory writes and reads is 6 cumulatively
    mem_addr: [Field; 10], //the address read or written from
    mem_value: [Field; 10], //the value at the address of same index
    mem_time: [Field; 10], //the value of the memory clock (updated after every read/write)
    mem_cpu_time: [Field; 10], //the value of the cpu clock at the time of read/write
    mem_rw: [Field; 10], //0 if read, 1 if write
    zero_flag: Field,
    negative_flag: Field
) {
    ldx::check_op(
        mem_addr,
        mem_value,
        mem_time,
        mem_cpu_time,
        mem_rw,
        zero_flag,
        negative_flag 
        );
}


fn op_stx(
    //we assume for now the number of memory writes and reads is 6 cumulatively
    mem_addr: [Field; 10], //the address read or written from
    mem_value: [Field; 10], //the value at the address of same index
    mem_time: [Field; 10], //the value of the memory clock (updated after every read/write)
    mem_cpu_time: [Field; 10], //the value of the cpu clock at the time of read/write
    mem_rw: [Field; 10], //0 if read, 1 if write
    zero_flag: Field,
    negative_flag: Field
) {
    stx::check_op(
        mem_addr,
        mem_value,
        mem_time,
        mem_cpu_time,
        mem_rw,
        zero_flag,
        negative_flag 
        );
}



fn op_inx(
    //we assume for now the number of memory writes and reads is 6 cumulatively
    mem_addr: [Field; 10], //the address read or written from
    mem_value: [Field; 10], //the value at the address of same index
    mem_time: [Field; 10], //the value of the memory clock (updated after every read/write)
    mem_cpu_time: [Field; 10], //the value of the cpu clock at the time of read/write
    mem_rw: [Field; 10], //0 if read, 1 if write
    zero_flag: Field,
    negative_flag: Field
) {
    inx::check_op(
        mem_addr,
        mem_value,
        mem_time,
        mem_cpu_time,
        mem_rw,
        zero_flag,
        negative_flag 
        );
}