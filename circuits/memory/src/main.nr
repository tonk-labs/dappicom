use dep::std; 

mod memcheck;
mod continuation;

// These inputs are kept artificially low until we can test with recursion
// we going to avoid structs for now, because they seem to be a bit difficult to work with in Noir atm
fn main(
    // the mem_page format is represented as tuples (addr, val), so iterator should move +2 for every entry
    mem_page: [Field; 512], //full dump of memory for that page (initial state)

    addr_sorted_step: [Field; 128],
    addr_sorted_addr: [Field; 128],
    addr_sorted_val: [Field; 128],
    addr_sorted_op_rw: [Field; 128],
    op_sorted_step: [Field; 128],
    op_sorted_addr: [Field; 128],
    op_sorted_val: [Field; 128],
    op_sorted_op_rw: [Field; 128],

    r: Field, //precomputed challenge based on hashing to addr and op sorted arrays
    mem_root_a: Field, //the merkle root of the initial memory
    mem_root_b: Field, //the merkle root of the end state of memory
    page_index: Field, //the index in the merkle tree

    // the memory space is large, but what is accessed is likely small ranges in practice
    // we don't know a priori what pages (leafs) in the merkle tree are accessed
    // that means we should determine each segment by memory access patterns
    // for now, we assume each segment only accesses 1 page of memory
    // the address space is very large when memory mapped ROMs are normalized
    // but for now we will assume the basic ROMs which only use 32KiB 
    // in the address range 0x4020 and 0xFFFF
    // this gives us a total address range of 64KiB
    // we're hashing the leaves in pages (1024 entries/page)
    // but the levels above are simple binary merkle tree
    // so we get at the end a hash path of 8
    hashpath_a: [Field; 12], //we hash all the reads 
    hashpath_b: [Field; 12], //for the writes
    ) -> (Field, Field, Field, Field) {
        // PROCEDURE 1.a
        // let challenges_and_partial_permutations = memcheck::run(
        //     addr_sorted_step,
        //     addr_sorted_addr,
        //     addr_sorted_val,
        //     addr_sorted_op_rw,
        //     op_sorted_step,
        //     op_sorted_addr,
        //     op_sorted_val,
        //     op_sorted_op_rw,
        //     r
        // );

        // PROCEDURE 1.b
        // let partial_permutation = continuation::run(
        //     mem_page, 
        //     addr_sorted_step,
        //     addr_sorted_addr,
        //     addr_sorted_val,
        //     addr_sorted_op_rw,
        //     r, mem_root_a, mem_root_b, page_index, hashpath_a, hashpath_b);


        //PROCEDURE 4 (aggregation step as comments)
        // verify continuations and memcheck
        // aggregated permutation 1_b = product([partial_permutation])
        // aggregated permutation 1_a_addr = product([challenges_and_partial_permutations[2]])
        // aggregated permutation 1_a_ops = product([challenges_and_partial_permutations[3]])
        // aggregated challenge r = hash([challenges_and_partial_permutations[0], challenges_and_partial_permutations[1]])

        // (aggergated_permutation_1_b, aggregated_permutation_1_a_addr, aggregated_permutation_1_a_ops, aggregated_challenge_r)
        (0,0,0,0) //placeholder for now
}

#[test]
fn test_main() {
    // Uncomment to make test fail
    // main(1, 1);
}
