`timescale 1ns / 1ps

module fir_dac_tb;

    // --- Simulation Parameters ---
    parameter CLK_PERIOD = 83.333; // 12 MHz clock period (1/12M = 83.333 ns)

    // --- Inputs to the DUT (top_fir_dac) ---
    reg clk;
    reg RST;
    reg ENABLE;
    reg signed [15:0] input_data;

    // --- Outputs from the DUT ---
    // DAC Pins (P70, P100, P65)
    wire dac_clk_pin;
    wire dac_cs_pin;
    wire dac_din_pin;

    // FIR Debug Output (32-bit result before scaling)
    wire signed [31:0] fir_out_debug;

    // --- Internal Memory and Control ---
    // NOTE: N2 is 16 from the original file, using 15:0 for signed input
    reg [15:0] data[99:0]; 
    integer k;
    integer FILE1;

    // --- Instantiate the DUT (Top Module) ---
    // The top_fir_dac module internally instantiates fir_filter and dac_interface.
    top_fir_dac UUT (
        .clk(clk),
        .RST(RST),
        .ENABLE(ENABLE),
        .input_data(input_data),
        .dac_clk_pin(dac_clk_pin),
        .dac_cs_pin(dac_cs_pin),
        .dac_din_pin(dac_din_pin),
        .fir_out_debug(fir_out_debug)
    );

    // --- 1. Clock Generation (12 MHz) ---
    // Half period is ~41.666 ns
    always # (CLK_PERIOD / 2.0) clk = ~clk;

    // --- 2. Stimulus Generation ---
    initial begin
        // Load input samples from file
        $readmemb("input.data" , data);

        // Open file for saving the filtered data
        FILE1 = $fopen("filtered_output.data" , "w");

        // Initialization
        clk = 1'b0;
        RST = 1'b1;
        ENABLE = 1'b0;
        input_data = 16'd0;

        $display("----------------------------------------------");
        $display("Starting FIR/DAC Simulation (12 MHz CLK)");
        $display("----------------------------------------------");

        // 1. Assert Reset
        # (CLK_PERIOD * 5); 
        RST = 1'b0;

        // 2. Enable Filter and Start Data Feed
        ENABLE = 1'b1;
        input_data <= data[0]; // Load first sample

        // Loop to feed 99 subsequent samples and capture output
        for(k = 1 ; k < 100 ; k=k+1) begin
            @(posedge clk);
            
            // Capture FIR output (32-bit) before it is sent to the DAC
            $fdisplay(FILE1 , "%b" , fir_out_debug);

            // Feed the next input sample
            input_data <= data[k];

            if(k == 99) begin
                // Wait for one more clock cycle to capture the last output
                @(posedge clk); 
                $fdisplay(FILE1 , "%b" , fir_out_debug);
                $fclose(FILE1);
            end
        end
         
        // 3. Wait to observe multiple DAC cycles after all data is processed
        // DAC clock period is 1/750kHz = 1333 ns.
        // A single 16-bit frame takes 16 * 1333 ns = ~21.3 us.
        // Waiting for 100 * CLK_PERIOD (~8.3 us) is enough to see a few transmissions.
        # (CLK_PERIOD * 100); 

        $display("----------------------------------------------");
        $display("Simulation Finished. Data saved to filtered_output.data");
        $display("----------------------------------------------");
        $stop;
    end
    
    // --- 3. DAC Pin Monitoring ---
    always @(negedge dac_cs_pin) begin
        $display("@ %t: DAC Start. FIR Output (32-bit): 0x%h", $time, fir_out_debug);
    end
    
    always @(posedge dac_cs_pin) begin
        $display("@ %t: DAC End. Waiting for next cycle.", $time);
    end


initial
begin
$dumpfile("top.vcd");
$dumpvars( 0 , fir_dac_tb);
end

endmodule
