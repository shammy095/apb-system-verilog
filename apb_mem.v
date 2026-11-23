`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2026 21:38:40
// Design Name: 
// Module Name: apb_mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
module apb_mem(pclk,presetn,psel,penable,pwrite,paddr,pwdata,prdata,pready,pslverr);
input pclk,presetn,psel,penable,pwrite;
input [7:0]paddr;
input [31:0]pwdata;
output [31:0]prdata;
output pready,pslverr;
reg [31:0]mem0,mem1,mem2,mem3;
reg [1:0]wcnt;
assign pready=psel&&penable&&(wcnt==2'b10);
assign pslverr=1'b0;
assign prdata=(paddr[3:2]==2'b00)?mem0:(paddr[3:2]==2'b01)?mem1:(paddr[3:2]==2'b10)?mem2:mem3;
always@(posedge pclk or negedge presetn)
begin
if(!presetn)
wcnt<=0;
else if(psel&&penable&&!pready)
wcnt<=wcnt+1;
else
wcnt<=0;
end
always@(posedge pclk or negedge presetn)
begin
if(!presetn)
begin
mem0<=0;
mem1<=0;
mem2<=0;
mem3<=0;
end
else if(psel&&penable&&pready&&pwrite)
case(paddr[3:2])
2'b00:mem0<=pwdata;
2'b01:mem1<=pwdata;
2'b10:mem2<=pwdata;
2'b11:mem3<=pwdata;
endcase
end
endmodule