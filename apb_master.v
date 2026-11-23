`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.11.2026 20:19:26
// Design Name: 
// Module Name: apb_master
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
module apb_master(pclk,presetn,transfer,wr,addr,wdata,pready,pslverr,prdata,psel,penable,pwrite,paddr,pwdata,rdata,err,done);
input pclk,presetn,transfer,wr,pready,pslverr;
input [7:0]addr;
input [31:0]wdata,prdata;
output reg psel,penable,pwrite,err,done;
output reg [7:0]paddr;
output reg [31:0]pwdata,rdata;
reg [1:0]state;
always@(posedge pclk or negedge presetn)
begin
if(!presetn)
begin
state<=2'b00;
psel<=0;
penable<=0;
pwrite<=0;
paddr<=0;
pwdata<=0;
rdata<=0;
err<=0;
done<=0;
end
else
case(state)
2'b00:begin
penable<=0;
done<=0;
if(transfer)
begin
psel<=1;
pwrite<=wr;
paddr<=addr;
pwdata<=wdata;
state<=2'b01;
end
else
psel<=0;
end
2'b01:begin
penable<=1;
done<=0;
state<=2'b10;
end
2'b10:begin
if(pready)
begin
penable<=0;
done<=1;
err<=pslverr;
if(!pwrite)
rdata<=prdata;
if(transfer)
begin
pwrite<=wr;
paddr<=addr;
pwdata<=wdata;
state<=2'b01;
end
else
begin
psel<=0;
state<=2'b00;
end
end
end
default:state<=2'b00;
endcase
end
endmodule
