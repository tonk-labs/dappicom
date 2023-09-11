// Illustrative example of validating an opcode instruction from MOS 6502
// ( we only care about immediate addressing at the moment )

// we overload the memory field to cut down on the number of parameters
// PC addr = 1048560
// X reg = 1048561 


fn check_op(
    //we assume for now the number of memory writes and reads is 6 cumulatively
    mem_addr: [Field; 10], //the address read or written from
    mem_value: [Field; 10], //the value at the address of same index
    mem_time: [Field; 10], //the value of the memory clock (updated after every read/write)
    mem_cpu_time: [Field; 10], //the value of the cpu clock at the time of read/write
    mem_rw: [Field; 10], //0 if read, 1 if write
    zero_flag: Field,
    negative_flag: Field
) {
    let LENGTH_OF_STX = 2;
    let OPCODE_STX = 134;

    //assert read of the PC — memory read from PC matches opcode
    assert(mem_rw[0] == 0);
    assert(mem_addr[0] == 1048560);

    let pc0 = mem_value[0];
    //read the value at the mem address pointed to by PC
    assert(mem_rw[1] == 0);
    assert(mem_addr[1] == pc0);
    assert(mem_value[1] == OPCODE_STX);

    //assert PC is incremented with a write
    assert(mem_rw[2] == 1);
    assert(mem_addr[2] == 1048560);
    assert(mem_value[2] == (pc0 + 1));

    //read the value from the X register
    assert(mem_rw[3] == 0);
    assert(mem_addr[3] == 1048561);
    let value = mem_value[3];

    //write the value to the address pointed to by PC
    assert(mem_rw[4] == 1);
    assert(mem_addr[4] == pc0 + 1);
    assert(mem_value[4] == value);

    //zero and negative flags are carried over and unconstrained

    //assert PC is incremented by length of opcode
    assert(mem_rw[5] == 1);
    assert(mem_addr[5] == 1048560);
    assert(mem_value[5] == pc0 + 1 + LENGTH_OF_STX);

    //assert the cpu_time is the same and that mem_time is incremental
    for i in 1..5 {
        assert((mem_time[i] - mem_time[i-1] - 1) == 0);
        assert(mem_cpu_time[i] == mem_cpu_time[i-1]);
    }
}

#[test]
fn test_ldx() {
    check_op(
        [1048560, 1337, 1048560, 1048561, 1338, 1048560, 1048575, 1048575, 1048575, 1048575],
        [1337, 134, 1338, 255, 255, 1340, 0, 0, 0, 0],
        [0, 1, 2, 3, 4, 5, 0, 0, 0, 0],
        [1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
        [0, 0, 1, 0, 1, 1, 0, 0, 0, 0],
        1,
        0
    )
}