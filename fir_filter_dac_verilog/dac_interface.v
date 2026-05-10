`timescale 1ns / 1ps

// ----------------------------------------------------------------------
// 1. DAC Interface Module (DAC084S085 Driver)
//    - Implements the 16-bit serial protocol for the 4-channel, 8-bit DAC.
//    - Assumes the DAC expects a 16-bit frame: 4 control bits (Channel Address) + 8 Data bits + 4 Don't Care bits.
// ----------------------------------------------------------------------

module dac_interface (
    input clk,            // System clock (12 MHz)
    input RST,            // Synchronous Reset
    input signed [31:0] fir_output, // 32-bit signed output from the FIR filter

    // DAC Control Signal Outputs (Connect to physical FPGA pins)
    output reg dac_clk,   // P70 (SCLK) - Serial Clock
    output reg dac_cs,    // P100 (CS)  - Chip Select
    output reg dac_din    // P65 (DIN)  - Serial Data Input
);

    // --- Parameters and Constants ---
    localparam FRAME_SIZE = 16;
    localparam CHANNEL_A = 4'b0000; // Channel A (OUT-A) for the filtered signal

    // --- State Machine Registers ---
    reg [4:0] bit_counter;        // Counter for the 16 bits in the frame (0 to 15)
    reg [FRAME_SIZE - 1: 0] shift_register; // Holds the 16-bit data frame to be sent

    // --- Scaled and Biased Data Conversion ---
    // FIR output is 32-bit signed. DAC is 8-bit unipolar (0 to 255).
    // Right shift by 16 bits is used for scaling (discarding the 16 LSBs).
    wire signed [7:0] scaled_out_signed;
    // Arithmetic right shift by 16
    assign scaled_out_signed = fir_output[31:0] >>> 16; 

    // Convert signed [-128, 127] to unsigned [0, 255] by adding DC bias (128).
    wire [7:0] dac_data_value = scaled_out_signed + 8'd128;

    // --- Main Clock and State Control ---
    // CLK = 12 MHz. We target a dac_clk (SCLK) frequency around 750 kHz.
    // We use a clock divider to generate a slower clock for the serial state machine.
    // The state machine clock (slow_clk) will run at CLK / 8 = 1.5 MHz.
    // The dac_clk (SCLK) runs at half this speed (toggled in the always block) = 750 kHz.
    reg [2:0] clk_divider_reg = 0; // 3-bit counter for CLK/8 division
    wire slow_clk;

    // Generate a pulse every 8 system clocks (1.5 MHz)
    always @(posedge clk) begin
        clk_divider_reg <= clk_divider_reg + 1'b1;
    end
    assign slow_clk = clk_divider_reg[2]; // CLK/8

    // --- Data Loading and Shifting Logic (FSM) ---

    always @(posedge slow_clk) begin
        if (RST) begin
            bit_counter <= 0;
            dac_cs <= 1'b1; // Chip Select is high (inactive)
            dac_clk <= 1'b0;
            dac_din <= 1'b0;
            shift_register <= 0;
        end else begin
            // 1. DAC Clock Generation (SCLK)
            // Toggles on every 'slow_clk' edge, running at 750 kHz.
            dac_clk <= ~dac_clk;

            // 2. Main State Logic (Triggered on positive edge of the slower dac_clk)
            // Note: We use 'if (dac_clk)' to ensure data changes on the DAC's falling edge
            // and is sampled on the rising edge, or vice-versa, depending on DAC clock polarity.
            // This setup uses the rising edge of dac_clk for shifting control.
            if (dac_clk) begin
                if (bit_counter == 0) begin
                    // --- START OF FRAME: Load Data and Assert CS ---
                    dac_cs <= 1'b0; // Chip Select low (active)

                    // 16-bit frame format: [4 Control Bits | 8 Data Bits | 4 Don't Care Bits]
                    shift_register <= {CHANNEL_A, dac_data_value, 4'b0000};
                    bit_counter <= bit_counter + 1;
                end else if (bit_counter < FRAME_SIZE) begin
                    // --- SHIFTING PHASE: Send one bit of data ---
                    dac_din <= shift_register[FRAME_SIZE - 1]; // Output MSB of the frame
                    shift_register <= shift_register << 1;     // Shift the register left
                    bit_counter <= bit_counter + 1;
                end else begin
                    // --- END OF FRAME: De-assert CS ---
                    dac_cs <= 1'b1; // Chip Select high (inactive)
                    bit_counter <= 0; // Reset counter
                    dac_din <= 1'b0;
                end
            end
        end
    end

endmodule // dac_interface

// The top_fir_dac module remains unchanged as it simply connects the two main blocks.
