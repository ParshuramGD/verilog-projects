module fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16
)(
    input wire clk,
    input wire rst,

    input wire w_en,
    input wire r_en,
    input wire [DATA_WIDTH-1:0] d,

    output reg [DATA_WIDTH-1:0] q,
    output wire full,
    output wire empty
);

    // Memory array: Size is DEPTH
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Pointers and counter sizing:
    // Pointers need $clog2(DEPTH) bits (e.g., 4 bits for DEPTH=16)
    reg [$clog2(DEPTH)-1:0] wptr, rptr;
    // Counter needs $clog2(DEPTH+1) bits to represent 0 to DEPTH (e.g., 5 bits for DEPTH=16)
    reg [$clog2(DEPTH+1)-1:0] count;

    // --- Sequential Logic ---
    always @(posedge clk ) begin
        // Reset Logic
        if (rst) begin
            wptr  <= 0;
            rptr  <= 0;
            count <= 0;
            q     <= 0; // Reset read data output
        end
        // Normal Operation
        else begin
            // 1. WRITE OPERATION
            // Data is written to the memory location pointed to by wptr.
            if (w_en && !full) begin
                mem[wptr] <= d;
                wptr <= (wptr + 1) % DEPTH; // Advance write pointer (wraps around)
            end

            // 2. READ OPERATION
            // Data is read from the memory location pointed to by rptr.
            // Note: The read data 'q' will be available on the *next* clock edge.
            if (r_en && !empty) begin
                q <= mem[rptr];
                rptr <= (rptr + 1) % DEPTH; // Advance read pointer (wraps around)
            end

            // 3. COUNT UPDATE LOGIC (Explicitly handles all cases for robust synthesis)
            // Case A: Write Only (or Write/Read simultaneous where FIFO is empty)
            if (w_en && !full && (!r_en || empty)) begin
                count <= count + 1;
            end
            // Case B: Read Only (or Read/Write simultaneous where FIFO is full)
            else if (r_en && !empty && (!w_en || full)) begin
                count <= count - 1;
            end
            // Case C: Simultaneous Write and Read (w_en & r_en, and !full & !empty)
            // count does not change (count <= count)
            // Case D: No operation
            // count does not change (count <= count)
        end
    end

    // --- Combinational Logic ---
    // Full/Empty Status Flags
    assign full  = (count == DEPTH); // Max count reached
    assign empty = (count == 0);     // Zero count reached

endmodule