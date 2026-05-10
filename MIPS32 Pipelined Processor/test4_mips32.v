//After an ADD instruction, the correct value is written into the destination register.


module test4_mips32;


reg clk1 , clk2;
integer k;

pipe_MIPS32 mips(.clk1(clk1) , .clk2(clk2));


 initial
    begin
        clk1=0; clk2=0;
        repeat(20)       //Generating two-phase clock
            begin
                #5 clk1 = 1;  #5 clk2=0;
                #5 clk2 = 1 ; #5 clk1=0;
            end
        end



initial
for(k =0; k < 32 ; k = k +1)
begin

     mips.Reg[k] = k;


    // mips.Mem[0] = 32'h01450800;  //ADD R1 ,R2 , R3
    mips.Mem[0] = {6'b000000, 5'd2, 5'd3, 5'd1, 11'd0};


#100

$display("\r1 = %32h ", mips.Mem[0]);

$display("\r1 = %4d ", mips.Reg[1]);



$finish;


end








endmodule