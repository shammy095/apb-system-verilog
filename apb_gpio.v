`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2026 21:37:38
// Design Name: 
// Module Name: apb_gpio
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
module apb_gpio(pclk,presetn,psel,penable,pwrite,paddr,pwdata,gpio_in,prdata,pready,pslverr,gpio_out);
input pclk,presetn,psel,penable,pwrite;
input [7:0]paddr;
input [31:0]pwdata;
input [7:0]gpio_in;
output reg [31:0]prdata;
output pready,pslverr;
output [7:0]gpio_out;
reg [7:0]dir_reg,out_reg;
assign pready=psel&&penable;
assign pslverr=psel&&penable&&((pwrite&&paddr[3:2]==2'b10)||(paddr[3:2]==2'b11));
assign gpio_out=out_reg&dir_reg;
always@(posedge pclk or negedge presetn)
begin
if(!presetn)
begin
dir_reg<=0;
out_reg<=0;
end
else if(psel&&penable&&pwrite&&!pslverr)
case(paddr[3:2])
2'b00:dir_reg<=pwdata[7:0];
2'b01:out_reg<=pwdata[7:0];
endcase
end
always@(*)
begin
case(paddr[3:2])
2'b00:prdata={24'h000000,dir_reg};
2'b01:prdata={24'h000000,out_reg};
2'b10:prdata={24'h000000,gpio_in};
default:prdata=32'h00000000;
endcase
end
endmodule