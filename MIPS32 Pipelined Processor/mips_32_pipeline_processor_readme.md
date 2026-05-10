# MIPS32 Pipelined Processor in Verilog

## Overview
This project implements a simplified **32-bit pipelined MIPS processor** using **Verilog HDL**. The processor supports multiple instruction types, pipelined execution stages, branch handling, memory operations, and hazard testing.

The project was developed to demonstrate:

- Digital design fundamentals
- Computer architecture concepts
- Pipeline implementation
- Verilog HDL coding skills
- Simulation and debugging workflow
- Understanding of instruction execution and hazards

This repository is intended to showcase my practical hardware design and RTL development skills to recruiters and hiring managers.

---

## Features

### Processor Architecture
- 32-bit MIPS-style architecture
- Two-phase clock pipeline design
- Multi-stage instruction pipeline
- Register bank implementation
- Memory subsystem implementation

### Supported Instructions
#### Arithmetic / Logical
- ADD
- SUB
- AND
- OR
- SLT
- MUL

#### Immediate Instructions
- ADDI
- SUBI
- SLTI

#### Memory Instructions
- LW (Load Word)
- SW (Store Word)

#### Branch Instructions
- BEQZ
- BNEQZ

#### Control
- HLT

---

## Pipeline Stages
The processor follows a classic pipelined architecture:

1. **IF – Instruction Fetch**
2. **ID – Instruction Decode**
3. **EX – Execute**
4. **MEM – Memory Access**
5. **WB – Write Back**

The design also includes:
- Branch handling
- Pipeline control logic
- Basic hazard-oriented testing

---

## Project Structure

```text
.
├── pipe_MIPS32(1).v      # Main pipelined MIPS32 processor
├── test_mips32(1).v      # Testbench
├── test3_mips32(1).v     # Additional testbench
├── test4_mips32.v        # Test case
├── test5_mips32.v        # Test case
├── datahazard_test.v     # Hazard testing
├── *.vcd                 # Simulation waveform files
├── output*               # Simulation outputs
└── README.md
```

---

## Tools Used
- Verilog HDL
- Icarus Verilog / ModelSim (for simulation)
- GTKWave (waveform visualization)
- VS Code

---

## Running the Project

### Compile
```bash
iverilog -o mips_sim pipe_MIPS32(1).v test_mips32(1).v
```

### Run Simulation
```bash
vvp mips_sim
```

### Open Waveforms
```bash
gtkwave mips.vcd
```

---

## Concepts Demonstrated

- RTL Design
- Pipelined CPU Architecture
- Instruction Decoding
- ALU Operations
- Register File Design
- Branch Handling
- Memory Access
- Verilog Testbench Development
- Waveform Debugging
- Data Hazard Analysis

---

## Why This Project Matters
This project reflects my ability to:

- Design hardware systems using Verilog
- Understand processor internals and pipelining
- Write structured RTL code
- Debug hardware behavior using waveform analysis
- Build simulation-based verification workflows
- Apply computer architecture concepts practically

---

## Future Improvements
Potential enhancements include:

- Forwarding Unit
- Stall Control Logic
- Cache Memory
- Full Hazard Detection Unit
- More MIPS Instructions
- Better test coverage
- FPGA implementation support

---

## Author
Created by a Electronics Engineering student passionate about:
- Computer Architecture
- RTL Design
- Digital Systems
- Embedded Systems
- Hardware Verification

---

## License
This project is open-source and available for learning and educational purposes.

