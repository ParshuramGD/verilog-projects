`timescale 1ns / 1ps

// This module connects the FIR filter output to the DAC interface input.
module top_fir_dac (
    // System Ports (Input from FPGA)
    input clk,
    input RST,
    input ENABLE,
    input signed [15:0] input_data,

    // DAC Output Pins (To be connected to P70, P100, P65)
    output dac_clk_pin,   
    output dac_cs_pin,    
    output dac_din_pin,   

    // Debug Output (for Testbench and FPGA Debug)
    output signed [31:0] fir_out_debug
);

    // Internal wire to carry the 32-bit filtered output
    wire signed [31:0] fir_output_data;
    
    // Unused wire from the FIR filter (sampleT is 16-bit)
    wire signed [15:0] sampleT_unused; 

    // 1. Instantiate the FIR Filter Module (Assumes fir_filter.v exists)
    fir_filter fir_inst (
        .input_data  (input_data),
        .clk         (clk),
        .RST         (RST),
        .ENABLE      (ENABLE),
        .output_data (fir_output_data),
        .sampleT     (sampleT_unused)
    );

    // Assign debug output
    assign fir_out_debug = fir_output_data;

    // 2. Instantiate the DAC Interface Module (Assumes dac_interface.v exists)
    dac_interface dac_inst (
        .clk         (clk),
        .RST         (RST),
        .fir_output  (fir_output_data), // Connect filter output to DAC input

        // Connect DAC interface outputs to top-level pins
        .dac_clk     (dac_clk_pin),
        .dac_cs      (dac_cs_pin),
        .dac_din     (dac_din_pin)
    );

endmodule // top_fir_dac
