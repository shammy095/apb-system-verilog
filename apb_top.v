`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.11.2026 20:21:13
// Design Name: 
// Module Name: apb_top
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
module apb_top(pclk,presetn,transfer,wr,addr,wdata,gpio_in,rdata,err,done,gpio_out,timer_irq);
input pclk,presetn,transfer,wr;
input [7:0]addr;
input [31:0]wdata;
input [7:0]gpio_in;
output [31:0]rdata;
output err,done,timer_irq;
output [7:0]gpio_out;
wire psel,penable,pwrite,pready,pslverr;
wire [7:0]paddr;
wire [31:0]pwdata,prdata;
wire psel1,psel2,psel3;
wire [31:0]prdata1,prdata2,prdata3;
wire pready1,pready2,pready3,pslverr1,pslverr2,pslverr3;
apb_master m1(pclk,presetn,transfer,wr,addr,wdata,pready,pslverr,prdata,psel,penable,pwrite,paddr,pwdata,rdata,err,done);
apb_decoder d1(psel,penable,paddr,prdata1,prdata2,prdata3,pready1,pready2,pready3,pslverr1,pslverr2,pslverr3,psel1,psel2,psel3,prdata,pready,pslverr);
apb_gpio s1(pclk,presetn,psel1,penable,pwrite,paddr,pwdata,gpio_in,prdata1,pready1,pslverr1,gpio_out);
apb_timer s2(pclk,presetn,psel2,penable,pwrite,paddr,pwdata,prdata2,pready2,pslverr2,timer_irq);
apb_mem s3(pclk,presetn,psel3,penable,pwrite,paddr,pwdata,prdata3,pready3,pslverr3);
endmodule