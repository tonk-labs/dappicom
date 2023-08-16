// 0 immediate means we read the value directly off the program_counter
// 1 zeropage means we read the location in memory from the value of the program counter
// 2 absolute means we use a different heuristic to read the address given the value of program counter
// 3 zeropage x means we read the value in memory from the value in PC and then add the contents of register X to it and read from that addr
// 4 zeropage y means we do the same thing except add from register y
// 5 absolute x means we use the read heuristic to do what zero page x does
// 6 absolute y means we use the read heuristic to do what zero page y does
// 7 indirect x means we read zero page as base and then add register x and these components become the heuristic for the address
// 8 indirect y means we read zero page, then use the heuristic to define pointer, then we add y to the dereferenced pointer 
// 9 non addressing is used when there is no addressing mode


//@TODO — we can separate these out into each opcode document, so will leave this here as a reference until that time.
fn get_op_parameters(
    opcode: Field,
) -> (Field, Field, Field) {
    assert(opcode as u64 < 0xff);

    // Byte Length (to update PC), cycles (for clk checking), mode (addressing mode)
    let mut params: (Field, Field, Field) = (0,0,0);
    if (opcode - 0x00 == 0) { 
        params = (1, 7, 9);
    }

    if (opcode - 0xea == 0) { 
        params = (1, 2, 9);
    }

    // Arithmetic */
    if (opcode - 0x69 == 0) { 
        params = (2, 2, 0);
    }

    if (opcode - 0x65 == 0) { 
        params = (2, 3, 1);
    }

    if (opcode - 0x75 == 0) { 
        params = (2, 4, 3);
    }

    if (opcode - 0x6d == 0) { 
        params = (3, 4, 2);
    }

    if (opcode - 0x7d == 0) { 
        //+1 if page crossed*/
        params = (3, 4, 5);
    }

    if (opcode - 0x79 == 0) { 
        //+1 if page crossed*/
        params = (3, 4, 6);
    }

    if (opcode - 0x61 == 0) { 
        params = (2, 6, 7);
    }

    if (opcode - 0x71 == 0) { 
        //+1 if page crossed*/
        params = (2, 5, 8);
    }


    if (opcode - 0xe9 == 0) { 
        params = (2, 2, 0);
    }

    if (opcode - 0xe5 == 0) { 
        params = (2, 3, 1);
    }

    if (opcode - 0xf5 == 0) { 
        params = (2, 4, 3);
    }

    if (opcode - 0xed == 0) { 
        params = (3, 4, 2);
    }

    if (opcode - 0xfd == 0) { 
        //+1 if page crossed*/
        params = (3, 4, 5);
    }

    if (opcode - 0xf9 == 0) { 
        //+1 if page crossed*/
        params = (3, 4, 6);
    }

    if (opcode - 0xe1 == 0) { 
        params = (2, 6, 7);
    }

    if (opcode - 0xf1 == 0) { 
        //+1 if page crossed*/
        params = (2, 5, 8);
    }


    if (opcode - 0x29 == 0) { 
        params = (2, 2, 0);
    }

    if (opcode - 0x25 == 0) { 
        params = (2, 3, 1);
    }

    if (opcode - 0x35 == 0) { 
        params = (2, 4, 3);
    }

    if (opcode - 0x2d == 0) { 
        params = (3, 4, 2);
    }

    if (opcode - 0x3d == 0) { 
        //+1 if page crossed*/
        params = (3, 4, 5);
    }

    if (opcode - 0x39 == 0) { 
        //+1 if page crossed*/
        params = (3, 4, 6);
    }

    if (opcode - 0x21 == 0) { 
        params = (2, 6, 7);
    }

    if (opcode - 0x31 == 0) { 
        //+1 if page crossed*/
        params = (2, 5, 8);
    }


    if (opcode - 0x49 == 0) { 
        params = (2, 2, 0);
    }

    if (opcode - 0x45 == 0) { 
        params = (2, 3, 1);
    }

    if (opcode - 0x55 == 0) { 
        params = (2, 4, 3);
    }

    if (opcode - 0x4d == 0) { 
        params = (3, 4, 2);
    }

    if (opcode - 0x5d == 0) { 
        //+1 if page crossed*/
        params = (3, 4, 5);
    }

    if (opcode - 0x59 == 0) { 
        //+1 if page crossed*/
        params = (3, 4, 6);
    }

    if (opcode - 0x41 == 0) { 
        params = (2, 6, 7);
    }

    if (opcode - 0x51 == 0) { 
        //+1 if page crossed*/
        params = (2, 5, 8);
    }


    if (opcode - 0x09 == 0) { 
        params = (2, 2, 0);
    }

    if (opcode - 0x05 == 0) { 
        params = (2, 3, 1);
    }

    if (opcode - 0x15 == 0) { 
        params = (2, 4, 3);
    }

    if (opcode - 0x0d == 0) { 
        params = (3, 4, 2);
    }

    if (opcode - 0x1d == 0) { 
        //+1 if page crossed*/
        params = (3, 4, 5);
    }

    if (opcode - 0x19 == 0) { 
        //+1 if page crossed*/
        params = (3, 4, 6);
    }

    if (opcode - 0x01 == 0) { 
        params = (2, 6, 7);
    }

    if (opcode - 0x11 == 0) { 
        //+1 if page crossed*/
        params = (2, 5, 8);
    }


    // Shifts */
    if (opcode - 0x0a == 0) { 
        params = (1, 2, 9);
    }

    if (opcode - 0x06 == 0) { 
        params = (2, 5, 1);
    }

    if (opcode - 0x16 == 0) { 
        params = (2, 6, 3);
    }

    if (opcode - 0x0e == 0) { 
        params = (3, 6, 2);
    }

    if (opcode - 0x1e == 0) { 
        params = (3, 7, 5);
    }


    if (opcode - 0x4a == 0) { 
        params = (1, 2, 9);
    }

    if (opcode - 0x46 == 0) { 
        params = (2, 5, 1);
    }

    if (opcode - 0x56 == 0) { 
        params = (2, 6, 3);
    }

    if (opcode - 0x4e == 0) { 
        params = (3, 6, 2);
    }

    if (opcode - 0x5e == 0) { 
        params = (3, 7, 5);
    }


    if (opcode - 0x2a == 0) { 
        params = (1, 2, 9);
    }

    if (opcode - 0x26 == 0) { 
        params = (2, 5, 1);
    }

    if (opcode - 0x36 == 0) { 
        params = (2, 6, 3);
    }

    if (opcode - 0x2e == 0) { 
        params = (3, 6, 2);
    }

    if (opcode - 0x3e == 0) { 
        params = (3, 7, 5);
    }


    if (opcode - 0x6a == 0) { 
        params = (1, 2, 9);
    }

    if (opcode - 0x66 == 0) { 
        params = (2, 5, 1);
    }

    if (opcode - 0x76 == 0) { 
        params = (2, 6, 3);
    }

    if (opcode - 0x6e == 0) { 
        params = (3, 6, 2);
    }

    if (opcode - 0x7e == 0) { 
        params = (3, 7, 5);
    }


    if (opcode - 0xe6 == 0) { 
        params = (2, 5, 1);
    }

    if (opcode - 0xf6 == 0) { 
        params = (2, 6, 3);
    }

    if (opcode - 0xee == 0) { 
        params = (3, 6, 2);
    }

    if (opcode - 0xfe == 0) { 
        params = (3, 7, 5);
    }


    if (opcode - 0xe8 == 0) { 
        params = (1, 2, 9);
    }

    if (opcode - 0xc8 == 0) { 
        params = (1, 2, 9);
    }


    if (opcode - 0xc6 == 0) { 
        params = (2, 5, 1);
    }

    if (opcode - 0xd6 == 0) { 
        params = (2, 6, 3);
    }

    if (opcode - 0xce == 0) { 
        params = (3, 6, 2);
    }

    if (opcode - 0xde == 0) { 
        params = (3, 7, 5);
    }


    if (opcode - 0xca == 0) { 
        params = (1, 2, 9);
    }

    if (opcode - 0x88 == 0) { 
        params = (1, 2, 9);
    }


    if (opcode - 0xc9 == 0) { 
        params = (2, 2, 0);
    }

    if (opcode - 0xc5 == 0) { 
        params = (2, 3, 1);
    }

    if (opcode - 0xd5 == 0) { 
        params = (2, 4, 3);
    }

    if (opcode - 0xcd == 0) { 
        params = (3, 4, 2);
    }

    if (opcode - 0xdd == 0) { 
        //+1 if page crossed*/
        params = (3, 4, 5);
    }

    if (opcode - 0xd9 == 0) { 
        //+1 if page crossed*/
        params = (3, 4, 6);
    }

    if (opcode - 0xc1 == 0) { 
        params = (2, 6, 7);
    }

    if (opcode - 0xd1 == 0) { 
        //+1 if page crossed*/
        params = (2, 5, 8);
    }


    if (opcode - 0xc0 == 0) { 
        params = (2, 2, 0);
    }

    if (opcode - 0xc4 == 0) { 
        params = (2, 3, 1);
    }

    if (opcode - 0xcc == 0) { 
        params = (3, 4, 2);
    }


    if (opcode - 0xe0 == 0) { 
        params = (2, 2, 0);
    }

    if (opcode - 0xe4 == 0) { 
        params = (2, 3, 1);
    }

    if (opcode - 0xec == 0) { 
        params = (3, 4, 2);
    }



    // Branching */

    if (opcode - 0x4c == 0) { 
        params = (3, 3, 9); //AddressingMode that acts as Immidiate
    }

    if (opcode - 0x6c == 0) { 
        params = (3, 5, 9); //AddressingMode:Indirect with 6502 bug
    }


    if (opcode - 0x20 == 0) { 
        params = (3, 6, 9);
    }

    if (opcode - 0x60 == 0) { 
        params = (1, 6, 9);
    }


    if (opcode - 0x40 == 0) { 
        params = (1, 6, 9);
    }


    if (opcode - 0xd0 == 0) { 
        //(+1 if branch succeeds +2 if to a new page)*/
        params = (2, 2 , 9);
    }

    if (opcode - 0x70 == 0) { 
        //(+1 if branch succeeds +2 if to a new page)*/
        params = (2, 2 , 9);
    }

    if (opcode - 0x50 == 0) { 
        //(+1 if branch succeeds +2 if to a new page)*/
        params = (2, 2 , 9);
    }

    if (opcode - 0x30 == 0) { 
        //(+1 if branch succeeds +2 if to a new page)*/
        params = (2, 2 , 9);
    }

    if (opcode - 0xf0 == 0) { 
        //(+1 if branch succeeds +2 if to a new page)*/
        params = (2, 2 , 9);
    }

    if (opcode - 0xb0 == 0) { 
        //(+1 if branch succeeds +2 if to a new page)*/
        params = (2, 2 , 9);
    }

    if (opcode - 0x90 == 0) { 
        //(+1 if branch succeeds +2 if to a new page)*/
        params = (2, 2 , 9);
    }

    if (opcode - 0x10 == 0) { 
        //(+1 if branch succeeds +2 if to a new page)*/
        params = (2, 2 , 9);
    }


    if (opcode - 0x24 == 0) { 
        params = (2, 3, 1);
    }

    if (opcode - 0x2c == 0) { 
        params = (3, 4, 2);
    }



    // Stores, Loads */
    if (opcode - 0xa9 == 0) { 
        params = (2, 2, 0);
    }

    if (opcode - 0xa5 == 0) { 
        params = (2, 3, 1);
    }

    if (opcode - 0xb5 == 0) { 
        params = (2, 4, 3);
    }

    if (opcode - 0xad == 0) { 
        params = (3, 4, 2);
    }

    if (opcode - 0xbd == 0) { 
        //+1 if page crossed*/
        params = (3, 4, 5);
    }

    if (opcode - 0xb9 == 0) { 
        //+1 if page crossed*/
        params = (3, 4, 6);
    }

    if (opcode - 0xa1 == 0) { 
        params = (2, 6, 7);
    }

    if (opcode - 0xb1 == 0) { 
        //+1 if page crossed*/
        params = (2, 5, 8);
    }


    if (opcode - 0xa2 == 0) { 
        params = (2, 2, 0);
    }

    if (opcode - 0xa6 == 0) { 
        params = (2, 3, 1);
    }

    if (opcode - 0xb6 == 0) { 
        params = (2, 4, 4);
    }

    if (opcode - 0xae == 0) { 
        params = (3, 4, 2);
    }

    if (opcode - 0xbe == 0) { 
        //+1 if page crossed*/
        params = (3, 4, 6);
    }


    if (opcode - 0xa0 == 0) { 
        params = (2, 2, 0);
    }

    if (opcode - 0xa4 == 0) { 
        params = (2, 3, 1);
    }

    if (opcode - 0xb4 == 0) { 
        params = (2, 4, 3);
    }

    if (opcode - 0xac == 0) { 
        params = (3, 4, 2);
    }

    if (opcode - 0xbc == 0) { 
        //+1 if page crossed*/
        params = (3, 4, 5);
    }



    if (opcode - 0x85 == 0) { 
        params = (2, 3, 1);
    }

    if (opcode - 0x95 == 0) { 
        params = (2, 4, 3);
    }

    if (opcode - 0x8d == 0) { 
        params = (3, 4, 2);
    }

    if (opcode - 0x9d == 0) { 
        params = (3, 5, 5);
    }

    if (opcode - 0x99 == 0) { 
        params = (3, 5, 6);
    }

    if (opcode - 0x81 == 0) { 
        params = (2, 6, 7);
    }

    if (opcode - 0x91 == 0) { 
        params = (2, 6, 8);
    }


    if (opcode - 0x86 == 0) { 
        params = (2, 3, 1);
    }

    if (opcode - 0x96 == 0) { 
        params = (2, 4, 4);
    }

    if (opcode - 0x8e == 0) { 
        params = (3, 4, 2);
    }


    if (opcode - 0x84 == 0) { 
        params = (2, 3, 1);
    }

    if (opcode - 0x94 == 0) { 
        params = (2, 4, 3);
    }

    if (opcode - 0x8c == 0) { 
        params = (3, 4, 2);
    }



    // Flags clear */

    if (opcode - 0xD8 == 0) { 
        params = (1, 2, 9);
    }

    if (opcode - 0x58 == 0) { 
        params = (1, 2, 9);
    }

    if (opcode - 0xb8 == 0) { 
        params = (1, 2, 9);
    }

    if (opcode - 0x18 == 0) { 
        params = (1, 2, 9);
    }

    if (opcode - 0x38 == 0) { 
        params = (1, 2, 9);
    }

    if (opcode - 0x78 == 0) { 
        params = (1, 2, 9);
    }

    if (opcode - 0xf8 == 0) { 
        params = (1, 2, 9);
    }


    if (opcode - 0xaa == 0) { 
        params = (1, 2, 9);
    }

    if (opcode - 0xa8 == 0) { 
        params = (1, 2, 9);
    }

    if (opcode - 0xba == 0) { 
        params = (1, 2, 9);
    }

    if (opcode - 0x8a == 0) { 
        params = (1, 2, 9);
    }

    if (opcode - 0x9a == 0) { 
        params = (1, 2, 9);
    }

    if (opcode - 0x98 == 0) { 
        params = (1, 2, 9);
    }


    // Stack */
    if (opcode - 0x48 == 0) { 
        params = (1, 3, 9);
    }

    if (opcode - 0x68 == 0) { 
        params = (1, 4, 9);
    }

    if (opcode - 0x08 == 0) { 
        params = (1, 3, 9);
    }

    if (opcode - 0x28 == 0) { 
        params = (1, 4, 9);
    }

    params
}
