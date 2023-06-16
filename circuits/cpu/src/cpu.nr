use crate::opcodes;
use dep::std;

fn perform_op(
    opcode: Field,
    t_index: Field,
    //         0          1            2             3              4               5           6
    // Index: a register, x register, y register, program conuter, stack pointer, CPU flags, Clock Cycle
    state_array: [Field; 7],
    time_sorted_rw: [Field; 10],
    time_sorted_addr: [Field; 10],
    time_sorted_value: [Field; 10],
    time_sorted_clk: [Field; 10],
) -> ([Field; 7], Field) {
    //if the program stops (ie. opcode == 0, then we will have padded the rest of the opcodes array with 0s and the program will not take anymore action)
    let mut tn_index = t_index;
    let mut new_state = state_array;
    let mut params = (0,0,0);

    let t = opcode - 0xa5 == 0;


    //LDA operation
    if ( opcode == 0xa9 ) | ( opcode == 0xa5) | ( opcode == 0xb5) | ( opcode == 0xad) | ( opcode == 0xbd) | ( opcode == 0xb9) | ( opcode == 0xa1) | ( opcode == 0xb1) {        
        params = opcodes::get_op_parameters(opcode);
        let (address, tnn_index) = get_address(
            params.2, t_index, state_array, 
            time_sorted_rw, time_sorted_addr, time_sorted_value, time_sorted_clk
            );
        new_state[0] = time_sorted_value[tnn_index];
        assert(time_sorted_addr[tnn_index] == address);
        assert(time_sorted_rw[tnn_index] == 0);
        assert(time_sorted_clk[tnn_index] == state_array[6]);
        //update flags
        tn_index = tnn_index + 1;
    };


    //TAX operation
    if ( opcode == 0xAA) { 
        new_state[0] = new_state[1];
        //update flags
    }

    //INX operation
    if ( opcode == 0xe8) { 
        new_state[1] = new_state[1] + 1;
        // wrap if the addition is more than 256
        if new_state[1] == 256 {
            new_state[1] = 0;
        }
        //update flags
    }
    
    ///* CLD */
    if (  opcode == 0xd8 ) {
    //  self.status.remove(CpuFlags::DECIMAL_MODE)) ,   
    } 

//         if ( /* CLI */ opcode - 0x58 ) {
// // self.status.remove(CpuFlags::INTERRUPT_DISABLE))
//         }  

//         if ( /* CLV */ opcode - 0xb8 ) {
// // self.status.remove(CpuFlags::OVERFLOW))
//         } 

//         if ( /* CLC */ opcode == 0x18) {
//             // self.clear_carry_flag()) 
//         }

//         if ( /* SEC */ opcode == 0x38) {
//             // self.set_carry_flag()) 
//         }

//         if ( /* SEI */ opcode == 0x78) {
//             // self.status.insert(CpuFlags::INTERRUPT_DISABLE)) 
//         }

//         if ( /* SED */ opcode == 0xf8) {
//             // self.status.insert(CpuFlags::DECIMAL_MODE)) 
//         }

//         if ( /* PHA */ opcode == 0x48) {
//             // self.stack_push(self.register_a)) 
//         }

//         /* PLA */
//         if ( opcode - 0x68 ) {
//             // self.pla();
//         }

//         /* PHP */
//         if ( opcode - 0x08 ) {
//             // self.php();
//         }

//         /* PLP */
//         if ( opcode == 0x28) {
//             // self.plp();
//         }

//         /* ADC */
//         if ( opcode == 0x69) | ( opcode == 0x65) | ( opcode == 0x75) | ( opcode == 0x6d) | ( opcode == 0x7d) | ( opcode == 0x79) | ( opcode == 0x61) | ( opcode == 0x71) {
//             // self.adc(&opcode.mode);
//         }

//         /* SBC */
//         if ( opcode == 0xe9) | ( opcode == 0xe5) | ( opcode == 0xf5) | ( opcode == 0xed) | ( opcode == 0xfd) | ( opcode == 0xf9) | ( opcode == 0xe1) | ( opcode == 0xf1) {
//             // self.sbc(&opcode.mode);
//         }

//         /* AND */
//         if ( opcode == 0x29) | ( opcode == 0x25) | ( opcode == 0x35) | ( opcode == 0x2d) | ( opcode == 0x3d) | ( opcode == 0x39) | ( opcode == 0x21) | ( opcode == 0x31) {
//             // self.and(&opcode.mode);
//         }

//         /* EOR */
//         if ( opcode == 0x49) | ( opcode == 0x45) | ( opcode == 0x55) | ( opcode == 0x4d) | ( opcode == 0x5d) | ( opcode == 0x59) | ( opcode == 0x41) | ( opcode == 0x51) {
//             // self.eor(&opcode.mode);
//         }

//         /* ORA */
//         if ( opcode == 0x09) | ( opcode == 0x05) | ( opcode == 0x15) | ( opcode == 0x0d) | ( opcode == 0x1d) | ( opcode == 0x19) | ( opcode == 0x01) | ( opcode == 0x11) {
//             // self.ora(&opcode.mode);
//         }

//         if ( /* LSR */ opcode == 0x4a ) {
//             // self.lsr_accumulator()) ,
//         }

//         /* LSR */
//         if ( opcode == 0x46) | ( opcode == 0x56) | ( opcode == 0x4e) | ( opcode == 0x5e) {
//             self.lsr(&opcode.mode);
//         }

//         if ( /*ASL*/ opcode == 0x0a) {
//         //  self.asl_accumulator()) ,
//         }

//         /* ASL */
//         if ( opcode == 0x06) | ( opcode == 0x16) | ( opcode == 0x0e) | ( opcode == 0x1e) {
//             self.asl(&opcode.mode);
//         }

//         if ( /*ROL*/ opcode == 0x2a) {
//             // self.rol_accumulator()) ,
//         }

//         /* ROL */
//         if ( opcode == 0x26) | ( opcode == 0x36) | ( opcode == 0x2e) | ( opcode == 0x3e) {
//             self.rol(&opcode.mode);
//         }

//         if ( /* ROR */ opcode == 0x6a) {
//             // self.ror_accumulator()) ,
//         }

//         /* ROR */
//         if ( opcode == 0x66) | ( opcode == 0x76) | ( opcode == 0x6e) | ( opcode == 0x7e) {
//             self.ror(&opcode.mode);
//         }

//         /* INC */
//         if ( opcode == 0xe6) | ( opcode == 0xf6) | ( opcode == 0xee) | ( opcode == 0xfe) {
//             self.inc(&opcode.mode);
//         }

//         /* INY */
//         if ( opcode == 0xc8) {
//             // self.iny())
//         }

//         /* DEC */
//         if ( opcode == 0xc6) | ( opcode == 0xd6) | ( opcode == 0xce) | ( opcode == 0xde) {
//             self.dec(&opcode.mode);
//         }

//         /* DEX */
//         if ( opcode - 0xca ) {
//             self.dex();
//         }

//         /* DEY */
//         if ( opcode - 0x88 ) {
//             self.dey();
//         }

//         /* CMP */
//         if ( opcode == 0xc9) | ( opcode == 0xc5) | ( opcode == 0xd5) | ( opcode == 0xcd) | ( opcode == 0xdd) | ( opcode == 0xd9) | ( opcode == 0xc1) | ( opcode == 0xd1) {
//             self.compare(&opcode.mode, self.register_a);
//         }

//         /* CPY */
//         if ( opcode == 0xc0) | ( opcode == 0xc4) | ( opcode == 0xcc) {
//             self.compare(&opcode.mode, self.register_y);
//         }

//         /* CPX */
//         if ( opcode == 0xe0) | ( opcode == 0xe4) | ( opcode == 0xec) {
//             // self.compare(&opcode.mode, self.register_x)) ,
//         } 

//         /* JMP Absolute */
//         if ( opcode == 0x4c) {
//             // let mem_address = self.mem_read_u16(self.program_counter);
//             // self.program_counter = mem_address;
//         }

//         /* JMP Indirect */
//         if ( opcode == 0x6c) {
//             // let mem_address = self.mem_read_u16(self.program_counter);
//             // // let indirect_ref = self.mem_read_u16(mem_address);
//             // //6502 bug mode with with page boundary:
//             // //  if address $3000 contains $40, $30FF contains $80, and $3100 contains $50,
//             // // the result of JMP ($30FF) will be a transfer of control to $4080 rather than $5080 as you intended
//             // // i.e. the 6502 took the low byte of the address from $30FF and the high byte from $3000

//             // let indirect_ref = if mem_address & opcode - 0x00FF == opcode - 0x00FF {
//             //     let lo = self.mem_read(mem_address);
//             //     let hi = self.mem_read(mem_address & opcode - 0xFF00);
//             //     (hi as u16== << 8) | ( (lo as u16)
//             // } else {
//             //     self.mem_read_u16(mem_address)
//             // };

//             // self.program_counter = indirect_ref;
//         }

//         /* JSR */
//         if ( opcode - 0x20 ) {
//             self.stack_push_u16(self.program_counter + 2 - 1);
//             let target_address = self.mem_read_u16(self.program_counter);
//             self.program_counter = target_address
//         }

//         /* RTS */
//         if ( opcode - 0x60 ) {
//             self.program_counter = self.stack_pop_u16() + 1;
//         }

//         /* RTI */
//         if ( opcode - 0x40 ) {
//             self.status = CpuFlags::from_bits_truncate(self.stack_pop());
//             self.status.remove(CpuFlags::BREAK);
//             self.status.insert(CpuFlags::BREAK2);

//             self.program_counter = self.stack_pop_u16();
//         }

//         /* BNE */
//         if ( opcode - 0xd0 ) {
//             self.branch(!self.status.contains(CpuFlags::ZERO));
//         }

//         /* BVS */
//         if ( opcode - 0x70 ) {
//             self.branch(self.status.contains(CpuFlags::OVERFLOW));
//         }

//         /* BVC */
//         if ( opcode - 0x50 ) {
//             self.branch(!self.status.contains(CpuFlags::OVERFLOW));
//         }

//         /* BPL */
//         if ( opcode - 0x10 ) {
//             self.branch(!self.status.contains(CpuFlags::NEGATIV));
//         }

//         /* BMI */
//         if ( opcode - 0x30 ) {
//             self.branch(self.status.contains(CpuFlags::NEGATIV));
//         }

//         /* BEQ */
//         if ( opcode - 0xf0 ) {
//             self.branch(self.status.contains(CpuFlags::ZERO));
//         }

//         /* BCS */
//         if ( opcode - 0xb0 ) {
//             self.branch(self.status.contains(CpuFlags::CARRY));
//         }

//         /* BCC */
//         if ( opcode - 0x90 ) {
//             self.branch(!self.status.contains(CpuFlags::CARRY));
//         }

//         /* BIT */
//         if ( opcode == 0x24) | ( opcode - 0x2c ) {
//             self.bit(&opcode.mode);
//         }

        // STA
        if ( opcode == 0x85) | ( opcode == 0x95) | ( opcode == 0x8d) | ( opcode == 0x9d) | ( opcode == 0x99) | ( opcode == 0x81) | ( opcode == 0x91) {
            // self.sta(&opcode.mode);
            assert(opcode != 0);
            params = opcodes::get_op_parameters(opcode);
            let (address, tnn_index) = get_address(
                params.2, t_index, state_array, 
                time_sorted_rw, time_sorted_addr, time_sorted_value, time_sorted_clk
                );
            assert(time_sorted_addr[tnn_index] == address);
            assert(time_sorted_rw[tnn_index] == 1);
            assert(time_sorted_clk[tnn_index] == state_array[6]);
            assert(time_sorted_value[tnn_index] == state_array[0]);
            tn_index = tnn_index + 1;
        };

//         /* STX */
//         if ( opcode == 0x86) | ( opcode == 0x96) | ( opcode - 0x8e ) {
//             let addr = self.get_operand_address(&opcode.mode);
//             self.mem_write(addr, self.register_x);
//         }

//         /* STY */
//         if ( opcode == 0x84) | ( opcode == 0x94) | ( opcode - 0x8c ) {
//             let addr = self.get_operand_address(&opcode.mode);
//             self.mem_write(addr, self.register_y);
//         }

//         /* LDX */
//         if ( opcode == 0xa2) | ( opcode == 0xa6) | ( opcode == 0xb6) | ( opcode == 0xae) | ( opcode - 0xbe ) {
//             self.ldx(&opcode.mode);
//         }

//         /* LDY */
//         if ( opcode == 0xa0) | ( opcode == 0xa4) | ( opcode == 0xb4) | ( opcode == 0xac) | ( opcode - 0xbc ) {
//             self.ldy(&opcode.mode);
//         }

//         /* NOP */
//         if ( opcode - 0xea ) {
//             //do nothing
//         }

//         /* TAY */
//         if ( opcode - 0xa8 ) {
//             self.register_y = self.register_a;
//             self.update_zero_and_negative_flags(self.register_y);
//         }

//         /* TSX */
//         if ( opcode - 0xba ) {
//             self.register_x = self.stack_pointer;
//             self.update_zero_and_negative_flags(self.register_x);
//         }

//         /* TXA */
//         if ( opcode == 0x8a) {
//             // self.set_register_a(self.register_x)) ,
//         } 

//         /* TXS */
//         if ( opcode - 0x9a ) {
//             self.stack_pointer = self.register_x;
//         }

//         /* TYA */
//         if ( opcode == 0x98) {
//             // self.set_register_a(self.register_y)) ,
//         } 


    new_state[6] = new_state[6] + params.1;
    (new_state, tn_index) 
}

fn get_address(
    mode: Field,
    t_index: Field,
    //         0          1            2             3              4               5           6
    // Index: a register, x register, y register, program conuter, stack pointer, CPU flags, Clock Cycle
    state_array: [Field; 7],
    time_sorted_rw: [Field; 10],
    time_sorted_addr: [Field; 10],
    time_sorted_value: [Field; 10],
    time_sorted_clk: [Field; 10]
) -> (Field, Field) {
    // default behavior when mode == 0
    // immediate means we get the value directly off the program_counter
    let mut address = state_array[3];

    //steps are used to index into the time sorted array
    let mut tn_index = t_index;

    // zeropage means we read the location in memory from the value of the program counter
    if mode == 1 {        
        assert(time_sorted_rw[t_index] == 0);
        assert(time_sorted_clk[t_index] == state_array[6]);
        assert(time_sorted_addr[t_index] == state_array[3]);
        tn_index = tn_index + 1;
        address = time_sorted_value[t_index];
    };
    // absolute means we use a different heuristic to read the address given the value of program counter
    if mode == 2 {
        // these are the values
        let lo = time_sorted_value[t_index];
        let hi = (time_sorted_value[t_index + 1] as u64) << 8;
        // the address matches that which is in the PC
        assert(time_sorted_addr[t_index] == state_array[3]);
        assert(time_sorted_addr[t_index+1] == state_array[3] + 1);
        // these are reads
        assert(time_sorted_rw[t_index] == 0);
        assert(time_sorted_rw[t_index + 1] == 0);
        assert(time_sorted_clk[t_index] == state_array[6]);
        assert(time_sorted_clk[t_index+1] == state_array[6]);
        tn_index = tn_index + 2;
        address = (hi as Field) + lo;
    };
    // zeropage x means we read the value in memory from the value in PC and then add the contents of register X to it and read from that addr
    // zeropage y means we do the same thing except add from register y
    // absolute x means we use the read heuristic to do what zero page x does
    // absolute y means we use the read heuristic to do what zero page y does
    // indirect x means we read zero page as base and then add register x and these components become the heuristic for the address
    // indirect y means we read zero page, then use the heuristic to define pointer, then we add y to the dereferenced pointer 
    // non addressing is used when there is no addressing mode

    (address, tn_index)
}