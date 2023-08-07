
// Illustrative example of validating an opcode instruction from MOS 6502
// ( we only care about immediate addressing at the moment )

// we overload the memory field to cut down on the number of parameters
// PC addr = 1048560
// X reg = 1048561 


// leftover values are padded with 0s and memory address 0xFFFFF
fn check_op(
    //we assume for now the number of memory writes and reads is 7 cumulatively
    mem_addr: [Field; 10], //the address read or written from
    mem_value: [Field; 10], //the value at the address of same index
    mem_time: [Field; 10], //the value of the memory clock (updated after every read/write)
    mem_cpu_time: [Field; 10], //the value of the cpu clock at the time of read/write
    mem_rw: [Field; 10], //0 if read, 1 if write
    zero_flag: Field,
    negative_flag: Field
) {
    let LENGTH_OF_LDX = 2;
    let OPCODE_LDX = 162;

    //assert read of the PC — memory read from PC matches opcode
    assert(mem_rw[0] == 0); // read from PC
    assert(mem_addr[0] == 1048560);

    let pc0 = mem_value[0];
    //read the value at the mem address pointed to by PC
    assert(mem_rw[1] == 0); // read from loc pointed to by PC
    assert(mem_addr[1] == pc0);
    assert(mem_value[1] == OPCODE_LDX);

    //assert PC is incremented with a write
    assert(mem_rw[2] == 1); // write to PC
    assert(mem_addr[2] == 1048560);
    assert(mem_value[2] == (pc0 + 1));

    //read the value of the PC again as part of the address mode
    assert(mem_rw[3] == 0); // read value of PC + 1
    assert(mem_addr[3] == 1048560);
    let pc1 = mem_value[3];

    //read value from memory address at value PC + 1
    assert(mem_rw[4] == 0);
    assert(mem_addr[4] == pc1);
    let value = mem_value[4];

    //asert that memory is loaded into value of X register at the timestep — memory value matches what is written to X register
    assert(mem_rw[5] == 1); 
    assert(mem_addr[5] == 1048561);
    assert(mem_value[5] == value);

    //assert that flags are set correctly
    if (pc1 == 0) {
        assert(zero_flag == 1);
    } else {
        assert(zero_flag == 0);
    }
    if (value as u8 & 0x80 != 0) {
        assert(negative_flag == 1);
    } else {
        assert(negative_flag == 0);
    }

    //assert PC is incremented by length of opcode
    assert(mem_rw[6] == 1);
    assert(mem_addr[6] == 1048560);
    assert(mem_value[6] == pc1 + LENGTH_OF_LDX);

    //assert the cpu_time is the same and that mem_time is incremental
    for i in 1..7 {
        assert((mem_time[i] - mem_time[i-1] - 1) == 0);
        assert(mem_cpu_time[i] == mem_cpu_time[i-1]);
    }
}


#[test]
fn test_ldx() {
    check_op(
        [1048560, 1337, 1048560, 1048560, 1338, 1048561, 1048560, 1048575, 1048575, 1048575],
        [1337,    162,   1338,    1338,    255,    255,     1340, 0, 0, 0],
        [0, 1, 2, 3, 4, 5, 6, 0, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 0, 0, 0],
        [0,         0,     1,      0,       0,       1,       1, 0, 0, 0],
        0,
        1
    )
}

