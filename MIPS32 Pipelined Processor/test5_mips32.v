module test5_mips32;


reg clk1 , clk2;

integer k;

pipe_MIPS32 dut(.clk1(clk1) , .clk2(clk2));


initial 
begin

clk1 =0;
clk2 =0;

repeat(20)begin
 clk1 = #5 1'b1 ; clk2 = #5 1'b0 ;
 
 clk2 = #5 1'b1 ; clk1 = #5 1'b0 ;
end
end


initial begin
  // Initialize registers
  dut.Reg[1] = 5;   // base address
  dut.Reg[2] = 10;
  dut.Reg[4] = 10;

  // Initialize memory
  dut.Mem[5] = 20;  // data to load

  // Program
  dut.Mem[0] = 32'h20210000; // LW R1, 0(R1) (example encoding adjust)
  dut.Mem[1] = 32'h0ce77800;  // OR R7 , R7 , R7 -- dummy instruct
   
 // mips.Mem[2] = 32'h0ce77800;  // OR R7 , R7 , R7 -- dummy instruct
   
  dut.Mem[2] = 32'h00241800; // ADD R3, R1, R4

#100;


$display("R1 = %d " ,dut.Reg[1]);


$display("R2 = %d " ,dut.Reg[2]);

$display("R3 = %d " ,dut.Reg[3]);




end

initial
begin

$dumpfile("test5.vcd");
$dumpvars(0 , test5_mips32);

#100
$finish;

end




endmodule