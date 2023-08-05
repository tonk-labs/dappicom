use dep::std;

// this computes the intermediary values necessary for permutation check and does addr memory consistency
fn run(
    addr_sorted_step: [Field; 128],
    addr_sorted_addr: [Field; 128],
    addr_sorted_val: [Field; 128],
    addr_sorted_op_rw: [Field; 128],
    op_sorted_step: [Field; 128],
    op_sorted_addr: [Field; 128],
    op_sorted_val: [Field; 128],
    op_sorted_op_rw: [Field; 128],
    r: Field, //precomputed challenge based on hashing to addr and op sorted arrays
    // returns the two intermediary permutation checks, and two intermediary challenge hashes
) -> [Field; 4] {

    // compute the intermediary challenge (we aggregate this at the end to double check the 'r' value)
    let mut challenge_a = 0;
    let mut challenge_op = 0;
    for i in 0..128 {
        challenge_a += std::hash::poseidon::bn254::hash_4([addr_sorted_step[i], addr_sorted_addr[i], addr_sorted_val[i], addr_sorted_op_rw[i]]);        
        challenge_op += std::hash::poseidon::bn254::hash_4([op_sorted_step[i], op_sorted_addr[i], op_sorted_val[i], op_sorted_op_rw[i]]);        
    }


    // compute the intermediary products for final permutation
    let mut part_addr = 1;
    let mut part_op = 1; 
    part_addr = (((addr_sorted_addr[0]) + (addr_sorted_val[0]) + (addr_sorted_step[0]) + (addr_sorted_op_rw[0])) - r) * part_addr;
    part_op = (((op_sorted_addr[0]) + (op_sorted_val[0]) + (op_sorted_step[0]) + (op_sorted_op_rw[0])) - r) * part_op;
    for i in 1..128 {
        part_addr = (((addr_sorted_addr[i]) + (addr_sorted_val[i]) + (addr_sorted_step[i]) + (addr_sorted_op_rw[i])) - r) * part_addr;
        part_op = (((op_sorted_addr[i]) + (op_sorted_val[i]) + (op_sorted_step[i]) + (op_sorted_op_rw[i])) - r) * part_addr;

        // check for memory consistency
        if (addr_sorted_addr[i] != addr_sorted_addr[i-1]) {
            // check addresses properly sorted
            assert(addr_sorted_addr[i] as u32 > addr_sorted_addr[i-1] as u32);
        } else {
            //same addresses are sorted by time
            assert(addr_sorted_step[i] as u64 >= addr_sorted_step[i-1] as u64);
            //memory is consistent
            if (addr_sorted_op_rw[i] == 0) { //read operation
                assert(addr_sorted_val[i] == addr_sorted_val[i-1]);
            } 
        }
    }

    let partials = [challenge_a, challenge_op, part_addr, part_op];
    partials
}