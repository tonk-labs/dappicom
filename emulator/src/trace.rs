use std::env;
use std::fs::File;
use std::io::{Error as IOError, ErrorKind};
use serde::{Deserialize, Serialize};
use serde_json;

use crate::cpu::instr::{Instr, string_to_operation};

#[derive(Clone, Serialize, Deserialize, Debug)]
enum MemOp {
    Read,
    Write,
}

#[derive(Clone, Copy, Serialize, Deserialize, PartialEq, Debug)]
pub enum MachineStateType {
    X,
    Y,
    A,
    S,
    PC,
    SP,
    ADDR,
    DELIMITER,
}

#[derive(Clone, Serialize, Deserialize, Debug)]
pub struct MemoryEntry {
    step: u64,
    addr: Option<u32>,
    etype: MachineStateType,
    val: u16, //support up to u16 to include the PC
    op_rw: MemOp,
    instr: Option<Instr>
}

#[derive(Clone, Serialize, Deserialize, Debug)]
pub struct Trace {
    steps: u64,
    entries: Vec<MemoryEntry>,
    trace_flag: bool,
    pub current_instr: Option<Instr>,
    filter_trace: Option<String>
}

fn filter_by_string<'a>(data: &'a Vec<MemoryEntry>, target: &str) -> Result<Vec<&'a MemoryEntry>, &'static str> {
    let op = string_to_operation(target);
    if op.is_err() {
        Err("Failed to convert opcode")
    } else {
        Ok(data.iter()
            .filter(|&e| {
                if let (Some(instr), Ok(actual_op)) = (&e.instr, &op) {
                    instr.2 == *actual_op
                } else {
                    false
                }
            })
            .collect())
    }
}

impl Trace {
    pub fn new() -> Self {
        Self {
            entries: Vec::new(),
            steps: 0,
            current_instr: None,
            trace_flag: false,
            filter_trace: None,
        }
    }

    pub fn set_filter_trace(&mut self, filter_trace: Option<String>) {
        self.filter_trace = filter_trace;
    }

    pub fn set_trace_flag(&mut self, trace_flag: bool) {
        self.trace_flag = trace_flag;
    }

    pub fn mark_instr_boundary(&mut self) {
        self.steps += 1;
        self.entries.push(MemoryEntry { 
            step: self.steps, 
            addr: None, 
            etype: MachineStateType::DELIMITER, 
            val: 0, 
            op_rw: MemOp::Read, 
            instr: self.current_instr 
        });
    }

    pub fn read(&mut self, addr: u32, val: u16, etype: MachineStateType) {
        if self.trace_flag {
            self.steps += 1;
            self.entries.push(MemoryEntry {
                step: self.steps,
                addr: if etype == MachineStateType::ADDR {
                    Some(addr)
                } else {
                    None
                },
                instr: self.current_instr,
                val,
                op_rw: MemOp::Read,
                etype,
            });
        }
    }

    pub fn write(&mut self, addr: u32, val: u16, etype: MachineStateType) {
        if self.trace_flag {
            self.steps += 1;
            self.entries.push(MemoryEntry {
                step: self.steps,
                addr: if etype == MachineStateType::ADDR {
                    Some(addr)
                } else {
                    None
                },
                val,
                instr: self.current_instr,
                op_rw: MemOp::Write,
                etype,
            });
        }
    }


    // TODO: write functions to dump the trace here to a file at config path
    // We'll have to benchmark this vector as it absorbs many reads and writes
    // to make sure we can effectively clear it. It maybe better to preallocate
    // space up front and have the Trace element raise an event when the vector
    // is ready to be dumped.
    // for now this is fine, we will mostly be using it for writing out test traces
    pub fn serialize_trace(&self) -> Result<(), IOError> {
        match env::current_dir() {
            Ok(path) => {
                let filepath = path.join("trace.json");
                let file = File::create(filepath)?;
                let mut writable = &self.entries[1..3];
                let munged_ops: Vec<MemoryEntry>;
                if self.filter_trace.is_some() {
                    let filtered = filter_by_string(&self.entries, self.filter_trace.as_ref().unwrap().as_str());

                    if filtered.is_ok() {
                        let unwrapped_vec = filtered.as_ref().unwrap();
                        let slice_index = unwrapped_vec.iter()
                            .enumerate()
                            .filter(|&(_, &value)| value.etype == MachineStateType::DELIMITER)
                            .nth(5)
                            .map(|(idx, _)| idx);
                        if slice_index.is_some() {
                            munged_ops = unwrapped_vec.iter().take(slice_index.unwrap()).map(|&e| e.clone()).collect();
                            writable = &munged_ops[0..slice_index.unwrap()];
                        } else {
                            munged_ops = unwrapped_vec.iter().map(|&e| e.clone()).collect();
                            writable = &munged_ops[0..munged_ops.len()-1];
                        }
                    }
                }  
                serde_json::to_writer(file, &writable)?;
                Ok(())
            }
            Err(e) => {
                println!("Error retrieving the current directory: {}", e);
                Err(IOError::new(ErrorKind::Other, "Could not get the environment working directory"))
            }
        }
    }



}
