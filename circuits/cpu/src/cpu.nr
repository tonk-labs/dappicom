use crate::opcodes;

fn perform_op(
    opcode: Field,
    t_index: Field,
    state_array: [Field; 7],
    time_sorted_rw: [Field; 10],
    time_sorted_addr: [Field; 10],
    time_sorted_value: [Field; 10],
    time_sorted_clk: [Field; 10],
) -> ([Field; 7], Field) {
    //if the program stops (ie. opcode == 0, then we will have padded the rest of the opcodes array with 0s and the program will not take anymore action)
    let mut tn_index = t_index;

    //LDA operation
    if ( opcode - 0xa9 == 0 ) | ( opcode - 0xa5 == 0 ) | ( opcode - 0xb5 == 0 ) | ( opcode - 0xad == 0 ) | ( opcode - 0xbd == 0 ) | ( opcode - 0xb9 == 0 ) | ( opcode - 0xa1 == 0 ) | ( opcode - 0xb1 == 0 ) {
        let params: (Field, Field, Field) = opcodes::get_op_parameters(opcode);
        let (address, tnn_index) = get_address(
            params.2, t_index, state_array, 
            time_sorted_rw, time_sorted_addr, time_sorted_value, time_sorted_clk
            );
        tn_index = tnn_index;
        assert(address != 0);
    }


//         if ( opcode - 0xAA == 0) { 
//             // self.tax()) 
//         }
//         if ( opcode - 0xe8 == 0) { 
//             // self.inx()) 
//         }
//         if ( opcode - 0x00 == 0) { 
//             // return) 
//         }

//         if ( /* CLD */ opcode - 0xd8 ) {
//         //  self.status.remove(CpuFlags::DECIMAL_MODE)) ,   
//         } 

//         if ( /* CLI */ opcode - 0x58 ) {
// // self.status.remove(CpuFlags::INTERRUPT_DISABLE))
//         }  

//         if ( /* CLV */ opcode - 0xb8 ) {
// // self.status.remove(CpuFlags::OVERFLOW))
//         } 

//         if ( /* CLC */ opcode - 0x18 == 0 ) {
//             // self.clear_carry_flag()) 
//         }

//         if ( /* SEC */ opcode - 0x38 == 0 ) {
//             // self.set_carry_flag()) 
//         }

//         if ( /* SEI */ opcode - 0x78 == 0 ) {
//             // self.status.insert(CpuFlags::INTERRUPT_DISABLE)) 
//         }

//         if ( /* SED */ opcode - 0xf8 == 0 ) {
//             // self.status.insert(CpuFlags::DECIMAL_MODE)) 
//         }

//         if ( /* PHA */ opcode - 0x48 == 0 ) {
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
//         if ( opcode - 0x28 == 0) {
//             // self.plp();
//         }

//         /* ADC */
//         if ( opcode - 0x69 == 0 ) | ( opcode - 0x65 == 0 ) | ( opcode - 0x75 == 0 ) | ( opcode - 0x6d == 0 ) | ( opcode - 0x7d == 0 ) | ( opcode - 0x79 == 0 ) | ( opcode - 0x61 == 0 ) | ( opcode - 0x71 == 0 ) {
//             // self.adc(&opcode.mode);
//         }

//         /* SBC */
//         if ( opcode - 0xe9 == 0 ) | ( opcode - 0xe5 == 0 ) | ( opcode - 0xf5 == 0 ) | ( opcode - 0xed == 0 ) | ( opcode - 0xfd == 0 ) | ( opcode - 0xf9 == 0 ) | ( opcode - 0xe1 == 0 ) | ( opcode - 0xf1 == 0 ) {
//             // self.sbc(&opcode.mode);
//         }

//         /* AND */
//         if ( opcode - 0x29 == 0 ) | ( opcode - 0x25 == 0 ) | ( opcode - 0x35 == 0 ) | ( opcode - 0x2d == 0 ) | ( opcode - 0x3d == 0 ) | ( opcode - 0x39 == 0 ) | ( opcode - 0x21 == 0 ) | ( opcode - 0x31 == 0 ) {
//             // self.and(&opcode.mode);
//         }

//         /* EOR */
//         if ( opcode - 0x49 == 0 ) | ( opcode - 0x45 == 0 ) | ( opcode - 0x55 == 0 ) | ( opcode - 0x4d == 0 ) | ( opcode - 0x5d == 0 ) | ( opcode - 0x59 == 0 ) | ( opcode - 0x41 == 0 ) | ( opcode - 0x51 == 0 ) {
//             // self.eor(&opcode.mode);
//         }

//         /* ORA */
//         if ( opcode - 0x09 == 0 ) | ( opcode - 0x05 == 0 ) | ( opcode - 0x15 == 0 ) | ( opcode - 0x0d == 0 ) | ( opcode - 0x1d == 0 ) | ( opcode - 0x19 == 0 ) | ( opcode - 0x01 == 0 ) | ( opcode - 0x11 == 0 ) {
//             // self.ora(&opcode.mode);
//         }

//         if ( /* LSR */ opcode - 0x4a  == 0 ) {
//             // self.lsr_accumulator()) ,
//         }

//         /* LSR */
//         if ( opcode - 0x46 == 0 ) | ( opcode - 0x56 == 0 ) | ( opcode - 0x4e == 0 ) | ( opcode - 0x5e == 0 ) {
//             self.lsr(&opcode.mode);
//         }

//         if ( /*ASL*/ opcode - 0x0a == 0 ) {
//         //  self.asl_accumulator()) ,
//         }

//         /* ASL */
//         if ( opcode - 0x06 == 0 ) | ( opcode - 0x16 == 0 ) | ( opcode - 0x0e == 0 ) | ( opcode - 0x1e == 0 ) {
//             self.asl(&opcode.mode);
//         }

//         if ( /*ROL*/ opcode - 0x2a == 0 ) {
//             // self.rol_accumulator()) ,
//         }

//         /* ROL */
//         if ( opcode - 0x26 == 0 ) | ( opcode - 0x36 == 0 ) | ( opcode - 0x2e == 0 ) | ( opcode - 0x3e == 0 ) {
//             self.rol(&opcode.mode);
//         }

//         if ( /* ROR */ opcode - 0x6a == 0 ) {
//             // self.ror_accumulator()) ,
//         }

//         /* ROR */
//         if ( opcode - 0x66 == 0 ) | ( opcode - 0x76 == 0 ) | ( opcode - 0x6e == 0 ) | ( opcode - 0x7e == 0 ) {
//             self.ror(&opcode.mode);
//         }

//         /* INC */
//         if ( opcode - 0xe6 == 0 ) | ( opcode - 0xf6 == 0 ) | ( opcode - 0xee == 0 ) | ( opcode - 0xfe == 0 ) {
//             self.inc(&opcode.mode);
//         }

//         /* INY */
//         if ( opcode - 0xc8 == 0 ) {
//             // self.iny())
//         }

//         /* DEC */
//         if ( opcode - 0xc6 == 0 ) | ( opcode - 0xd6 == 0 ) | ( opcode - 0xce == 0 ) | ( opcode - 0xde == 0 ) {
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
//         if ( opcode - 0xc9 == 0 ) | ( opcode - 0xc5 == 0 ) | ( opcode - 0xd5 == 0 ) | ( opcode - 0xcd == 0 ) | ( opcode - 0xdd == 0 ) | ( opcode - 0xd9 == 0 ) | ( opcode - 0xc1 == 0 ) | ( opcode - 0xd1 == 0 ) {
//             self.compare(&opcode.mode, self.register_a);
//         }

//         /* CPY */
//         if ( opcode - 0xc0 == 0 ) | ( opcode - 0xc4 == 0 ) | ( opcode - 0xcc == 0 ) {
//             self.compare(&opcode.mode, self.register_y);
//         }

//         /* CPX */
//         if ( opcode - 0xe0 == 0 ) | ( opcode - 0xe4 == 0 ) | ( opcode - 0xec == 0 ) {
//             // self.compare(&opcode.mode, self.register_x)) ,
//         } 

//         /* JMP Absolute */
//         if ( opcode - 0x4c == 0 ) {
//             // let mem_address = self.mem_read_u16(self.program_counter);
//             // self.program_counter = mem_address;
//         }

//         /* JMP Indirect */
//         if ( opcode - 0x6c == 0 ) {
//             // let mem_address = self.mem_read_u16(self.program_counter);
//             // // let indirect_ref = self.mem_read_u16(mem_address);
//             // //6502 bug mode with with page boundary:
//             // //  if address $3000 contains $40, $30FF contains $80, and $3100 contains $50,
//             // // the result of JMP ($30FF) will be a transfer of control to $4080 rather than $5080 as you intended
//             // // i.e. the 6502 took the low byte of the address from $30FF and the high byte from $3000

//             // let indirect_ref = if mem_address & opcode - 0x00FF == opcode - 0x00FF {
//             //     let lo = self.mem_read(mem_address);
//             //     let hi = self.mem_read(mem_address & opcode - 0xFF00);
//             //     (hi as u16) << 8 == 0 ) | ( (lo as u16)
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
//         if ( opcode - 0x24 == 0 ) | ( opcode - 0x2c ) {
//             self.bit(&opcode.mode);
//         }

//         /* STA */
//         if ( opcode - 0x85 == 0 ) | ( opcode - 0x95 == 0 ) | ( opcode - 0x8d == 0 ) | ( opcode - 0x9d == 0 ) | ( opcode - 0x99 == 0 ) | ( opcode - 0x81 == 0 ) | ( opcode - 0x91 ) {
//             self.sta(&opcode.mode);
//         }

//         /* STX */
//         if ( opcode - 0x86 == 0 ) | ( opcode - 0x96 == 0 ) | ( opcode - 0x8e ) {
//             let addr = self.get_operand_address(&opcode.mode);
//             self.mem_write(addr, self.register_x);
//         }

//         /* STY */
//         if ( opcode - 0x84 == 0 ) | ( opcode - 0x94 == 0 ) | ( opcode - 0x8c ) {
//             let addr = self.get_operand_address(&opcode.mode);
//             self.mem_write(addr, self.register_y);
//         }

//         /* LDX */
//         if ( opcode - 0xa2 == 0 ) | ( opcode - 0xa6 == 0 ) | ( opcode - 0xb6 == 0 ) | ( opcode - 0xae == 0 ) | ( opcode - 0xbe ) {
//             self.ldx(&opcode.mode);
//         }

//         /* LDY */
//         if ( opcode - 0xa0 == 0 ) | ( opcode - 0xa4 == 0 ) | ( opcode - 0xb4 == 0 ) | ( opcode - 0xac == 0 ) | ( opcode - 0xbc ) {
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
//         if ( opcode - 0x8a == 0 ) {
//             // self.set_register_a(self.register_x)) ,
//         } 

//         /* TXS */
//         if ( opcode - 0x9a ) {
//             self.stack_pointer = self.register_x;
//         }

//         /* TYA */
//         if ( opcode - 0x98 == 0 ) {
//             // self.set_register_a(self.register_y)) ,
//         } 


    let mut new_state = state_array;
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
    // default behacior when mode == 0
    // immediate means we get the value directly off the program_counter
    let mut address = state_array[3];

    //steps are used to index into the time sorted array
    let mut tn_index = t_index;

    // zeropage means we read the location in memory from the value of the program counter
    if mode == 1 {
        let value = time_sorted_value[t_index];
        assert(time_sorted_rw[t_index] == 0);
        assert(time_sorted_clk[t_index] == state_array[6]);
        assert(time_sorted_addr[t_index] == state_array[3]);
        tn_index = tn_index + 1;
        address = value;
    };
    // absolute means we use a different heuristic to read the address given the value of program counter
    // zeropage x means we read the value in memory from the value in PC and then add the contents of register X to it and read from that addr
    // zeropage y means we do the same thing except add from register y
    // absolute x means we use the read heuristic to do what zero page x does
    // absolute y means we use the read heuristic to do what zero page y does
    // indirect x means we read zero page as base and then add register x and these components become the heuristic for the address
    // indirect y means we read zero page, then use the heuristic to define pointer, then we add y to the dereferenced pointer 
    // non addressing is used when there is no addressing mode

    (address, tn_index)
}