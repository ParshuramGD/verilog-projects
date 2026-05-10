# Synchronous FIFO Design in Verilog

## Overview
This project implements a **Synchronous FIFO (First-In First-Out) Memory Buffer** using **Verilog HDL**. The FIFO design supports controlled data storage and retrieval using common clock synchronization.

The project demonstrates practical understanding of:

- Digital logic design
- Sequential circuit implementation
- FIFO memory architecture
- Verilog HDL development
- Hardware simulation and verification

This repository is intended to showcase my RTL design and hardware verification skills to recruiters and hiring managers.

---

## Features

### FIFO Characteristics
- Synchronous FIFO architecture
- Shared clock operation
- Configurable memory depth
- Read and write pointer management
- FIFO status flag generation

### Supported Functionalities
- Data write operation
- Data read operation
- FIFO full detection
- FIFO empty detection
- Pointer increment logic
- Reset functionality

---

## Design Components

### Main Modules
- FIFO memory module
- Read pointer logic
- Write pointer logic
- Status flag control
- Testbench for simulation

---

## Project Structure

```text
.
├── FIFO.v          # FIFO design module
├── FIFO_tb.v       # Testbench
├── fifo_sim.vcd    # Waveform output
├── fifo_sim        # Compiled simulation file
└── README.md
```

---

## Tools Used
- Verilog HDL
- Icarus Verilog
- GTKWave
- VS Code

---

## Running the Project

### Compile
```bash
iverilog -o fifo_sim FIFO.v FIFO_tb.v
```

### Run Simulation
```bash
vvp fifo_sim
```

### View Waveforms
```bash
gtkwave fifo_sim.vcd
```

---

## Concepts Demonstrated

- FIFO Buffer Design
- Sequential Logic
- Clocked Digital Systems
- Pointer Management
- Memory Operations
- Hardware Verification
- Verilog Testbench Development
- Waveform Analysis

---

## Why This Project Matters
This project reflects my ability to:

- Design RTL systems using Verilog
- Implement memory-based digital architectures
- Understand synchronization concepts
- Verify hardware behavior through simulation
- Develop structured hardware testbenches
- Analyze timing and waveform outputs

---

## Future Improvements
Potential enhancements include:

- Asynchronous FIFO implementation
- Parameterized FIFO depth and width
- Overflow and underflow protection
- Advanced verification testcases
- SystemVerilog assertions
- FPGA deployment support

---

## Author
Created by a Computer Engineering student passionate about:
- RTL Design
- Digital Electronics
- Computer Architecture
- FPGA and Embedded Systems
- Hardware Verification

---

## License
This project is open-source and available for learning and educational purposes.

