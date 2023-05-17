use dep::std;

mod opcodes;
mod cpu;

fn check_permutations_memory_and_time(
    challenge: Field,
    addr_sorted_rw: [Field; 10],
    addr_sorted_addr: [Field; 10],
    addr_sorted_value: [Field; 10],
    addr_sorted_clk: [Field; 10],
    time_sorted_rw: [Field; 10],
    time_sorted_addr: [Field; 10],
    time_sorted_value: [Field; 10],
    time_sorted_clk: [Field; 10],
) -> Field {
    //check permutations using the challenge
    let mut addr_perm = 0;
    let mut time_perm = 0;
    for i in 0..10 {
        addr_perm = ((addr_sorted_addr[i] * addr_sorted_addr[i]) + 
            (addr_sorted_value[i] * addr_sorted_value[i]) + 
                (addr_sorted_clk[i] * addr_sorted_clk[i]) + 
                (addr_sorted_rw[i] * addr_sorted_rw[i]) - challenge) * addr_perm;
        time_perm = ((time_sorted_addr[i] * time_sorted_addr[i]) + 
            (time_sorted_value[i] * time_sorted_value[i]) + 
                (time_sorted_clk[i] * time_sorted_clk[i] + 
                (time_sorted_rw[i] * time_sorted_rw[i])) - challenge) * time_perm;
    }
    for i in 1..10 {
        assert(addr_sorted_rw[i] as u64 <= 1);
        assert(time_sorted_clk[i] as u64 >= time_sorted_clk[i-1] as u64);

        //addr are correctly sorted
        if (addr_sorted_addr[i] != addr_sorted_addr[i-1]) {
            assert(addr_sorted_addr[i] as u64 > addr_sorted_addr[i-1] as u64);
        } else {
            //same addresses are sorted by time
            assert(addr_sorted_clk[i] as u64 >= addr_sorted_clk[i-1] as u64);
            //memory is consistent
            if (addr_sorted_rw[i] == 0) { //read operation
                assert(addr_sorted_value[i] == addr_sorted_value[i-1]);
            } 
        }
    }

    //time sorted values are permutation of the address sorted values
    assert(addr_perm == time_perm);
    addr_perm
}

// fn check_time_consistency(
//     time_sorted_rw: [Field; 10],
//     time_sorted_addr: [Field; 10],
//     time_sorted_value: [Field; 10],
//     time_sorted_clk: [Field; 10],
// ) {

//     //check time consistency by running through transcript 
//     for i in 0..10 {
//         let opcode = opcodes[i];

//         let operations = opcodes::get_operations(opcode);

//         assert(operations == 0);
        
//     }
// }

fn main(
    // A hash of the transcript and addr
    challenge: pub Field,
    // Index: a register, x register, y register, program conuter, stack pointer, CPU flags, Clock Cycle
    state_array: pub [Field; 7],
    addr_sorted_rw: [Field; 10],
    addr_sorted_addr: [Field; 10],
    addr_sorted_value: [Field; 10],
    addr_sorted_clk: [Field; 10],
    time_sorted_rw: [Field; 10],
    time_sorted_addr: [Field; 10],
    time_sorted_value: [Field; 10],
    time_sorted_clk: [Field; 10],
    opcodes: [Field; 10], 
    // args_1: [Field; 10],
    // args_2: [Field; 10],
    // advice: [Field; 10]
) -> pub [Field; 7] {
    //TODO: ensure memory is consistent across proofs

    let mut new_state = state_array;

    let addr_perm = check_permutations_memory_and_time(
        challenge,
        addr_sorted_rw, addr_sorted_addr, addr_sorted_value, addr_sorted_clk,
        time_sorted_rw, time_sorted_addr, time_sorted_value, time_sorted_clk
    );


    let mut t_index = 0;
    //check time consistency by running through transcript 
    for i in 0..10 {
        let opcode = opcodes[i];
        assert(opcode == time_sorted_value[t_index]);
        t_index = t_index + 1;

        let (updated_state, next_index) = cpu::perform_op(
            opcode, 
            t_index, 
            new_state, 
            time_sorted_rw, time_sorted_addr, time_sorted_value, time_sorted_clk
            );
        
        t_index = next_index;
        new_state = updated_state;
    }

    ////we check the memory reads / writes match
    ////we check the advice arguments for calculations, check opcode matches
    ////check any subsequent reads / writes with result

    new_state[0] = addr_perm;
    new_state

    //check the hash of the time values matches the challenge
}

#[test]
fn test_main() {
        main(
            230492348234,
            [0, 0, 0, 0xFFFC, 0, 0, 0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0]
        );
}

// #[test]
// fn simple_test() {
//     main(
//         2349238492038423,
//         [0,0,0,0,0,0]
//         [],
//         [],
//         [],
//         [],
//         [],
//         [],
//         [],
//         [],
//         [],
//         [],
//     )
// }