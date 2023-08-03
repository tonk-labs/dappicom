struct MemoryOp {
    step: Field,
    addr: Field,
    val: Field,
    op_rw: Field,
}

struct MemoryEntry {
    addr: Field,
    val: Field
}

//These inputs are kept artificially low until we can test with recursion
fn main(
    mem_page: [MemoryEntry; 1024], //full dump of memory for that page (initial state)
    addr_sorted: [MemoryOp; 4], 
    op_sorted: [MemoryOp; 4], 
    r: Field, //precomputed challenge based on hashing to addr and op sorted arrays
    mem_root_a: Field, //the merkle root of the initial memory
    mem_root_b: Field, //the merkle root of the end state of memory

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
    hashpath_a: [Field; 8], //we hash all the reads 
    hashpath_b: [Field; 8], //for the writes
    ) {
        //hash the mem_page
        //prove merkle inclusion
        //roll addr_sorted writes into the mem_page
        //constrain all addr in addr_sorted a subset of mem_page
        //hash new mem_page
        //prove merkle inclusion
        //compute addr_sorted permutation 
        //compute op_sorted  permutation
        //constrain equality
        //output permutations
}

#[test]
fn test_main() {
    // Uncomment to make test fail
    // main(1, 1);
}
