.//FIFO - single clock hardware block

module FIFO(clk , rst , buf_in , buf_out , wr_en , rd_en , buf_empty , buf_full , fifo_counter);

input clk , rst ,wr_en,rd_en;
input  [7:0] buf_in;
output reg [7:0] buf_out;
output reg [6:0] fifo_counter;
output buf_empty,buf_full;


reg [7:0] buf_mem [63:0] ;  // 8bit data having elements 64 //memory store
reg [5:0] w_ptr , r_ptr;

//always @(fifo_counter) begin
//buf_empty = (fifo_counter == 0);
//buf_full = (fifo_counter == 64);
//end

assign buf_empty = (fifo_counter == 0);
assign buf_full  = (fifo_counter == 64);


//dealing with fifo_counter 
always @(posedge clk or posedge rst) begin

if(rst)
fifo_counter <=  0;
else if((!buf_full && wr_en) && (!buf_empty && rd_en))
fifo_counter <= fifo_counter;
else if(!buf_full && wr_en)
fifo_counter <= fifo_counter + 1'b1;
else if(!buf_empty && rd_en)
fifo_counter <= fifo_counter - 1'b1;

else
fifo_counter <= fifo_counter;
end

//helps to fetch data

always @(posedge clk or posedge rst)
begin
if(rst)
 buf_out <= 8'd0;
 else
begin
if(rd_en && !buf_empty)
buf_out <= buf_mem[r_ptr];
else
buf_out <= buf_out;

end
end

 //helps to writing data into fifo

always @(posedge clk )
begin
if(wr_en && !buf_full)
buf_mem[w_ptr] <= buf_in;  // with wptr we get address 
//else
//buf_mem[w_ptr]  <= buf_mem[w_ptr] ;
end


//now we manage the pointers

//manageing head pointers
always @(posedge clk or posedge rst)
begin
if(rst)
begin
w_ptr <=0;
r_ptr <=0;
end
//both happens simultaously /concurrently within this else block

else begin
//write 
    if(!buf_full && wr_en)
    w_ptr <= w_ptr + 1;
else
w_ptr <= w_ptr;

//read

if(!buf_empty && rd_en)
r_ptr <= r_ptr + 1;
else
r_ptr <= r_ptr;  //tail cant overtake head
 
end

end


endmodule








