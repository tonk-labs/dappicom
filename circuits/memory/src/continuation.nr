use dep::std;

fn run(
    mem_page: [Field; 512],
    addr_sorted_step: [Field; 128],
    addr_sorted_addr: [Field; 128],
    addr_sorted_val: [Field; 128],
    addr_sorted_op_rw: [Field; 128],
    r: Field,
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
) -> Field {
    //TODO: account for padding in the addr_sorted and op_sorted values

    //hash the mem_page
    let leaf: [Field; 2] = std::hash::pedersen(mem_page);
    //prove merkle inclusion
    let challenge_root_a = std::merkle::compute_merkle_root(leaf[0], page_index, hashpath_a);

    assert(mem_root_a == challenge_root_a);

    //check if sorted_addresses are within range
    let start_addr = mem_page[0];
    let end_addr = mem_page[510];

    assert(addr_sorted_addr[0] as u32 >= start_addr as u32);
    assert(addr_sorted_addr[127] as u32 <= end_addr as u32);

    let mut new_mem_page = mem_page;

    // compute the intermediary challenge (we aggregate this at the end to double check the 'r' value)
    let mut part_addr = 1;
    part_addr = (((addr_sorted_addr[0]) + (addr_sorted_val[0]) + (addr_sorted_step[0]) + (addr_sorted_op_rw[0])) - r) * part_addr;
    for i in 1..128 {
        part_addr = (((addr_sorted_addr[i]) + (addr_sorted_val[i]) + (addr_sorted_step[i]) + (addr_sorted_op_rw[i])) - r) * part_addr;
        //also we need to update the mem_page with the writes which happened in part_addr

        //TODO: this part of the code is adding lots of constraints (we should figure out a more efficient way to update the mem_page)
        //ideally we have some way to just roll all of the "final" writes ??
        if (addr_sorted_op_rw[i] == 1) {
            let calculated_mem_offset = (addr_sorted_addr[i] - start_addr) * 2;
            new_mem_page[calculated_mem_offset + 1] = addr_sorted_val[i];
        }
    }

    let leaf_end: [Field; 2] = std::hash::pedersen(new_mem_page);
    let challenge_root_b = std::merkle::compute_merkle_root(leaf_end[0], page_index, hashpath_b);

    assert(mem_root_b == challenge_root_b);

    part_addr
}