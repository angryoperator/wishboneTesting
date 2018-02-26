`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2018 03:10:39 PM
// Design Name: 
// Module Name: top_TB
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
//////////////////////////////////////////////////////////////////////////////////


module top_TB;
  
  reg clk, rst;
  reg [4:1] artySwitch;
  wire [4:1] artyLEDB, artyLEDG, artyLEDR, artyLED;
  reg [4:1] artyBTN;
  wire [8:1] artyJA, artyJB, artyJC, artyJD;
  wire [42:1] artyCKIO;
  wire [8:1] mojoLED;
  
  wire [8:1] wbAdrI;
  wire [15:0] wbAdIo;
  wire wbCycI, wbWeI, wbStbI, wbAckIo;
  
  assign wbAdrI = artyJA;
  assign wbAdIo = {artyJB, artyJC};
  assign {wbCycI, wbWeI, wbStbI, wbAckIo} = artyJD[3:0];
  
  // - UUTs - //
  arty_top #(
    .DEBUG_MODE(1)
  ) ARTY_inst (
    .SYS_CLK(clk),
    .SW(artySwitch),
    .LEDB(artyLEDB),
    .LEDG(artyLEDG),
    .LEDR(artyLEDR),
    .LED(artyLED),
    .BTN(artyBTN),
    .JA(artyJA),
    .JB(artyJB),
    .JC(artyJC),
    .JD(artyJD),
    .CKIO(artyCKIO)
  );
  
  mojo_top #(
    .DEBUG_MODE(1)
  ) MOJO_inst (
      .CLK(clk),
      .RST_N(rst),
      .LED(mojoLED),
      .ADR_I(wbAdrI),
      .AD_IO(wbAdIo),
      .CYC_I(wbCycI),
      .WE_I(wbWeI),
      .STB_I(wbStbI),
      .ACK_IO(wbAckIo)
  );
  
  
  
endmodule
