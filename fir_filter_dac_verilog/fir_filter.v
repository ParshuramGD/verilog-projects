//
//
//
//
//


`timescale 1ns / 1 ps

module fir_filter (input_data , clk , RST , ENABLE , output_data , sampleT);
//  FIR coefficient word width
parameter N1 = 8;
// input data word width
parameter N2 = 16;

//output data word witdh
parameter N3 = 32; // to be safe side
//here the number of bits representing output is larger than that of the output 
// this is mainly because the after every multiplication or additional binary number results will have
// increase no of binary bits to representing accurately the result
//hence bit size grows
//generally we need more no of bits than that of to store bits variables that particate in multiplication
//you can do simulation to check no of bits

//this array is used to store the coefficients

wire signed [N1 -1 : 0] b[0:7];
//this array is declared as array even if filter coefficient may be positive
//but inputs can be -ve
//whenever you have your in or out -ve use signed

// filter coefficients


assign b[0] = 8'b00010000;
assign b[1] = 8'b00010000;
assign b[2] = 8'b00010000;
assign b[3] = 8'b00010000;
assign b[4] = 8'b00010000;
assign b[5] = 8'b00010000;
assign b[6] = 8'b00010000;
assign b[7] = 8'b00010000;

 
 //input data

 input signed [N2 - 1 : 0] input_data;

 //output data samples

 output signed [N2-1 : 0] sampleT;

 //clock
 input clk;

//used to set to zero all filter taps
input RST;

//used to enable the filter
input ENABLE;
//filtered data

output signed [N3-1 : 0] output_data;


//this register is used to store the output
reg signed [N3-1 : 0] output_data_reg ;

//this array is used to store samples and to shift them
reg signed [N2-1:0] samples[0:6];
// 7 past input values
//uk uk-1 uk-2

always @(posedge clk)
begin
if (RST)
begin

samples[0] <= 0;
samples[1] <= 0; //all the statements are excecuted at the same time 
samples[2] <= 0; //imediatly after positive edge clock
samples[3] <= 0; //setting  all the past values of sample to 0
samples[4] <= 0; //
samples[5] <= 0;
samples[6] <= 0;
output_data_reg <=0; //output of value to be 0
end
 
 if((ENABLE == 1'b1) && (RST == 1'b0))
 begin
 output_data_reg <= b[0]*input_data 
                     + b[1]*samples[0]
                     + b[2]*samples[1]
                     + b[3]*samples[2]
                     + b[4]*samples[3]
                     + b[5]*samples[4]
                     + b[6]*samples[5]
                     + b[7]*samples[6];


        samples[0]  <= input_data;
        samples[1] <= samples[0];
        samples[2] <= samples[1];
        samples[3] <= samples[2];
        samples[4] <= samples[3];
        samples[5] <= samples[4];
        samples[6] <= samples[5];
        //we need to store input values  that is we need to properly assign
        // pass input values  
    end
end

 assign output_data = output_data_reg;
 assign sampleT = samples[0]; 
 //you can select any sample and can inspect it later on in our simulation
 //time diagram


endmodule 



