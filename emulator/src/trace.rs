use serde::{Deserialize, Serialize};

#[derive(Clone, Serialize, Deserialize, Debug)]
enum MemOp {
    Read,
    Write
}

#[derive(Clone, Serialize, Deserialize, PartialEq, Debug)]
pub enum MachineStateType {
    X,
    Y,
    A,
    S,
    PC,
    SP,
    ADDR,
}

#[derive(Clone, Serialize, Deserialize, Debug)]
pub struct MemoryEntry {
    step: u64,
    addr: Option<u32>,
    etype: MachineStateType,
    val: u16, //support up to u16 to include the PC
    op_rw: MemOp
}

#[derive(Clone, Serialize, Deserialize, Debug)]
pub struct Trace {
    steps: u64,
    entries: Vec<MemoryEntry>,
    trace_flag: bool,
}


impl Trace {
    pub fn new() -> Self {
        Self {
            entries: Vec::new(),
            steps: 0,
            trace_flag: false
        }
    }

    pub fn set_trace_flag(&mut self, trace_flag: bool) {
        self.trace_flag = trace_flag;
    }

    pub fn read(&mut self, addr: u32, val: u16, etype: MachineStateType) {
        if self.trace_flag {
            self.steps += 1;
            self.entries.push(MemoryEntry {
                step: self.steps,
                addr: if etype == MachineStateType::ADDR { Some(addr) } else { None },
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
                addr: if etype == MachineStateType::ADDR { Some(addr) } else { None },
                val,
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
}
