`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2026 21:36:44
// Design Name: 
// Module Name: apb_decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
module apb_decoder(psel,penable,paddr,prdata1,prdata2,prdata3,pready1,pready2,pready3,pslverr1,pslverr2,pslverr3,psel1,psel2,psel3,prdata,pready,pslverr);
input psel,penable;
input [7:0]paddr;
input [31:0]prdata1,prdata2,prdata3;
input pready1,pready2,pready3,pslverr1,pslverr2,pslverr3;
output psel1,psel2,psel3;
output [31:0]prdata;
output pready,pslverr;
assign psel1=psel&&(paddr[7:4]==4'h0);
assign psel2=psel&&(paddr[7:4]==4'h1);
assign psel3=psel&&(paddr[7:4]==4'h2);
assign prdata=psel1?prdata1:psel2?prdata2:psel3?prdata3:32'h00000000;
assign pready=psel1?pready1:psel2?pready2:psel3?pready3:(psel&&penable);
assign pslverr=psel1?pslverr1:psel2?pslverr2:psel3?pslverr3:(psel&&penable);
endmodule