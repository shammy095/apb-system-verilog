`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.11.2026 20:21:31
// Design Name: 
// Module Name: apb_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
module apb_tb;
reg pclk,presetn,transfer,wr;
reg [7:0]addr;
reg [31:0]wdata;
reg [7:0]gpio_in;
wire [31:0]rdata;
wire err,done,timer_irq;
wire [7:0]gpio_out;
integer pass,fail;
apb_top dut(pclk,presetn,transfer,wr,addr,wdata,gpio_in,rdata,err,done,gpio_out,timer_irq);
always #5 pclk=~pclk;
task apb_write;
input [7:0]a;
input [31:0]d;
begin
@(negedge pclk);
transfer=1;
wr=1;
addr=a;
wdata=d;
@(negedge pclk);
transfer=0;
@(posedge done);
@(negedge pclk);
end
endtask
task apb_read;
input [7:0]a;
begin
@(negedge pclk);
transfer=1;
wr=0;
addr=a;
@(negedge pclk);
transfer=0;
@(posedge done);
@(negedge pclk);
end
endtask
task check;
input ok;
input [8*40:1]msg;
begin
if(ok)
begin
pass=pass+1;
$display("PASS: %0s",msg);
end
else
begin
fail=fail+1;
$display("FAIL: %0s  rdata=%h err=%b",msg,rdata,err);
end
end
endtask
initial
begin
pclk=0;
presetn=0;
transfer=0;
wr=0;
addr=0;
wdata=0;
gpio_in=8'h3C;
pass=0;
fail=0;
#20 presetn=1;
apb_write(8'h00,32'h000000FF);
apb_write(8'h04,32'h000000A5);
check(gpio_out==8'hA5&&err==0,"GPIO OUT register drives pins");
apb_read(8'h04);
check(rdata==32'h000000A5,"GPIO OUT register read back");
apb_read(8'h08);
check(rdata==32'h0000003C,"GPIO IN register reads pins");
apb_write(8'h08,32'h00000001);
check(err==1,"GPIO IN is read only (PSLVERR)");
apb_write(8'h14,32'h00000005);
apb_read(8'h14);
check(rdata==32'h00000005&&err==0,"TIMER LOAD register (wait state)");
apb_write(8'h10,32'h00000001);
repeat(10)@(negedge pclk);
check(timer_irq==1,"TIMER counts to zero, interrupt set");
apb_read(8'h1C);
check(rdata==32'h00000001,"TIMER STATUS done flag");
apb_read(8'h18);
check(rdata==32'h00000000,"TIMER COUNT register is zero");
apb_write(8'h1C,32'h00000001);
check(timer_irq==0,"TIMER STATUS cleared");
apb_write(8'h18,32'h00000009);
check(err==1,"TIMER COUNT is read only (PSLVERR)");
apb_write(8'h20,32'h11111111);
apb_write(8'h2C,32'hDEADBEEF);
apb_read(8'h20);
check(rdata==32'h11111111&&err==0,"MEMORY word 0 (2 wait states)");
apb_read(8'h2C);
check(rdata==32'hDEADBEEF&&err==0,"MEMORY word 3 (2 wait states)");
apb_write(8'h40,32'h00000077);
check(err==1,"Invalid address 0x40 (PSLVERR)");
$display("TOTAL: %0d passed, %0d failed",pass,fail);
#20 $finish;
end
endmodule