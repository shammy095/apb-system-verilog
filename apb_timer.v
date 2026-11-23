`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2026 21:38:09
// Design Name: 
// Module Name: apb_timer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
module apb_timer(pclk,presetn,psel,penable,pwrite,paddr,pwdata,prdata,pready,pslverr,timer_irq);
input pclk,presetn,psel,penable,pwrite;
input [7:0]paddr;
input [31:0]pwdata;
output reg [31:0]prdata;
output pready,pslverr,timer_irq;
reg [1:0]ctrl_reg;
reg [31:0]load_reg,count_reg;
reg done_flag,waitd;
assign pready=(psel&&penable)?waitd:1'b0;
assign pslverr=psel&&penable&&pready&&pwrite&&(paddr[3:2]==2'b10);
assign timer_irq=done_flag;
always@(posedge pclk or negedge presetn)
begin
if(!presetn)
waitd<=0;
else if(psel&&penable&&!pready)
waitd<=1;
else
waitd<=0;
end
always@(posedge pclk or negedge presetn)
begin
if(!presetn)
begin
ctrl_reg<=0;
load_reg<=0;
count_reg<=0;
done_flag<=0;
end
else if(psel&&penable&&pready&&pwrite&&!pslverr)
begin
case(paddr[3:2])
2'b00:ctrl_reg<=pwdata[1:0];
2'b01:begin
load_reg<=pwdata;
count_reg<=pwdata;
end
2'b11:if(pwdata[0])
done_flag<=0;
endcase
end
else if(ctrl_reg[0])
begin
if(count_reg==0)
begin
done_flag<=1;
if(ctrl_reg[1])
count_reg<=load_reg;
else
ctrl_reg[0]<=0;
end
else
count_reg<=count_reg-1;
end
end
always@(*)
begin
case(paddr[3:2])
2'b00:prdata={30'h00000000,ctrl_reg};
2'b01:prdata=load_reg;
2'b10:prdata=count_reg;
2'b11:prdata={31'h00000000,done_flag};
endcase
end
endmodule
