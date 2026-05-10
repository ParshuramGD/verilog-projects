# FIR Filter and DAC Interface Design in Verilog

## Overview
This project implements a **Finite Impulse Response (FIR) Digital Filter** integrated with a **DAC (Digital-to-Analog Converter) Interface** using **Verilog HDL**.

The design demonstrates digital signal processing concepts along with RTL hardware implementation and verification techniques.

This project was developed to showcase practical skills in:

- Digital Signal Processing (DSP)
- RTL Design using Verilog
- Digital hardware simulation
- Data filtering techniques
- DAC interfacing concepts
- Hardware verification workflows

This repository is intended to demonstrate my hardware design and DSP implementation skills to recruiters and hiring managers.

---

## Features

### FIR Filter
- Digital FIR filter implementation
- Sample-based data processing
- Sequential filter operation
- Data buffering support
- Filtered output generation

### DAC Interface
- DAC communication logic
- Data transfer handling
- Digital output interfacing
- Integrated signal flow

### Verification
- Verilog testbench implementation
- Input/output data testing
- Waveform generation and analysis
- Simulation-based verification

---

## Design Components

### Main Modules
- FIR filter module
- DAC interface module
- FIFO support module
- Top integration module
- Testbench module

---

## Project Structure

```text
.
├── fir_filter.v          # FIR filter implementation
├── dac_interface.v       # DAC interface module
├── top_fir_dac.v         # Top-level integration
├── fir_dac_tb.v          # Testbench
├── fifo.v                # FIFO support module
├── input.data            # Input samples
├── filtered_output.data  # Filter output data
├── top.vcd               # Waveform output
├── README.md
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
iverilog -o fir_sim top_fir_dac.v fir_filter.v dac_interface.v fifo.v fir_dac_tb.v
```

### Run Simulation
```bash
vvp fir_sim
```

### View Waveforms
```bash
gtkwave top.vcd
```

---

## Concepts Demonstrated

- FIR Filter Design
- Digital Signal Processing
- RTL Design
- FIFO-Based Data Handling
- DAC Interfacing
- Sequential Logic Design
- Hardware Verification
- Testbench Development
- Waveform Analysis

---

## Why This Project Matters
This project reflects my ability to:

- Implement DSP algorithms in hardware
- Design RTL systems using Verilog HDL
- Integrate multiple hardware modules
- Simulate and verify digital systems
- Work with signal processing concepts
- Debug hardware using waveform analysis

---

## Future Improvements
Potential enhancements include:

- Parameterized FIR filter coefficients
- Higher-order filter support
- Real-time audio processing
- FPGA implementation
- AXI or SPI DAC interfacing
- SystemVerilog verification environment
- Optimized filter performance

---

## Author
Created by a Computer Engineering student passionate about:
- Digital Signal Processing
- RTL Design
- Computer Architecture
- FPGA and Embedded Systems
- Hardware Verification

---

## License
This project is open-source and available for learning and educational purposes.
