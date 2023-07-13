use dep::std;

// Permutation checks are useful to verify two sets of varying order contain the same elements (in O(n) time whereas a sort and compare would be O(nlogn))
// this can be useful when two different representations of these sets (e.g. sets of memory reads and writes) are useful for different purposes
// in this case, the address sorted memory is used to check for memory consistency
// the op sorted memory in our examples are used in checking each opcode

// because permutation checks use an element-wise product, they may be helpful in ensuring consistency across multiple
// proofs aggregated through recursion, but there is more work to discover exactly how this can be done in practice for this project

// here we just illustrate how a permutation check would be computed for two various sets

// the random_challenge element must be computed from a hash of the elements in both sets
// here we will do a simple straight hash of all the elements
// but in the case of a large set of elements, again it may be possible to use k-ary merkelization
// to compute the hash through recursion

fn permutation_check(
    addr_sorted_rw: [Field; 10],
    addr_sorted_addr: [Field; 10],
    addr_sorted_value: [Field; 10],
    addr_sorted_time: [Field; 10],
    addr_sorted_clk: [Field; 10],
    op_sorted_rw: [Field; 10],
    op_sorted_addr: [Field; 10],
    op_sorted_value: [Field; 10],
    op_sorted_time: [Field; 10],
    op_sorted_clk: [Field; 10],
) {
    //compute the challenge
    let mut challenge = 0;
    for i in 0..10 {
        challenge += std::hash::poseidon::bn254::hash_5([addr_sorted_rw[i], addr_sorted_addr[i], addr_sorted_value[i], op_sorted_time[i], addr_sorted_clk[i]]);
    }
    for i in 0..10 {
        challenge += std::hash::poseidon::bn254::hash_5([op_sorted_rw[i], op_sorted_addr[i], op_sorted_value[i], op_sorted_time[i], op_sorted_clk[i]]);
    }

    //check permutations using the challenge
    let mut addr_perm = 0;
    let mut op_perm = 0;
    for i in 0..10 {
        addr_perm = (((addr_sorted_addr[i]) + (addr_sorted_value[i]) + (addr_sorted_clk[i]) + (addr_sorted_rw[i]) + (addr_sorted_time[i])) - challenge) * addr_perm;
        op_perm = ((op_sorted_addr[i]) + (op_sorted_value[i]) + (op_sorted_clk[i] + (op_sorted_rw[i]) + op_sorted_time[i]) - challenge) * op_perm;
    }

    for i in 1..10 {
        if ((addr_sorted_addr[i] - 1048575 != 0)) { // the address 0xFFFFF is used as the 'padding' address

            assert(addr_sorted_rw[i] as u64 <= 1); //all addresses are either read or write
            assert(op_sorted_clk[i] as u64 >= op_sorted_clk[i-1] as u64); //the clock is monotonically increasing

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
    }

    //time sorted values are permutation of the address sorted values
    assert(addr_perm == op_perm);
}


#[test]
fn test_permutation_check() {
        permutation_check(
            [0,0,0,0,0,0,0,0,0,1],
            [0,0,0,0,0,0,1,2,3,3],
            [0,0,0,0,0,0,0,1,2,8],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,1,0,0,0],
            [0,1,3,0,0,0,3,0,2,0],
            [0,0,2,0,0,0,2,0,1,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
        );
}