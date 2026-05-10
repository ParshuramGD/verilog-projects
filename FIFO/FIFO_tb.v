`timescale 1ns/1ps

module FIFO_tb;

reg clk;
reg rst;
reg wr_en;
reg rd_en;
reg [7:0] buf_in;

wire [7:0] buf_out;
wire buf_empty;
wire buf_full;
wire [6:0] fifo_counter;

FIFO dut (
  .clk(clk),
  .rst(rst),
  .wr_en(wr_en),
  .rd_en(rd_en),
  .buf_in(buf_in),
  .buf_out(buf_out),
  .buf_empty(buf_empty),
  .buf_full(buf_full),
  .fifo_counter(fifo_counter)
);

// Clock generation
always #5 clk = ~clk;

initial begin
  clk = 0;
  rst = 1;
  wr_en = 0;
  rd_en = 0;
  buf_in = 0;

  // Reset
  #10 rst = 0;

  // Write data
  repeat (5) begin
    @(posedge clk);
    wr_en = 1;
    buf_in = buf_in + 8'd1;
  end

  @(posedge clk);
  wr_en = 0;

  // Read data
  repeat (5) begin
    @(posedge clk);
    rd_en = 1;
  end

  @(posedge clk);
  rd_en = 0;

  // Simultaneous read & write
  @(posedge clk);
  wr_en = 1;
  rd_en = 1;
  buf_in = 8'hAA;

  @(posedge clk);
  wr_en = 0;
  rd_en = 0;

  #20 $finish;
end


initial 
begin

$dumpfile("fifo_sim.vcd");
$dumpvars(0 , FIFO_tb);

end


endmodule
