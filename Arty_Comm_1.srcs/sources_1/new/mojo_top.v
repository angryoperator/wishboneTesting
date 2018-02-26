`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2018 03:06:42 PM
// Design Name: 
// Module Name: mojo_top
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

`include "memoryMap.vh"

module mojo_top(
      input CLK,
      input RST_N,
      output [7:0] LED,
      input [7:0] ADR_I,
      inout [15:0] AD_IO,
      input CYC_I,
      input WE_I,
      input STB_I,
      output ACK_IO
    );
    
    // - Parameters - //
    parameter DEBUG_MODE = 0;
    parameter ADDRESS_ONE = 8'h02;
    parameter ADDRESS_TWO = 8'h04;
    parameter ADDRESS_THREE = 8'h06;
    parameter ADDRESS_FOUR = 8'h08;
    
    // - Locals - //
    reg [15:0] dataIBuf;
    wire [7:0] dataI;
    wire selectAddressOne;
    wire selectAddressTwo;
    wire selectAddressThree;
    wire selectAddressFour;
    reg [15:0] addressOne;
    reg [15:0] addressTwo;
    reg [15:0] addressThree;
    reg [15:0] addressFour;
    
    initial begin
      dataIBuf = 0;
      addressOne = 16'h000F;
      addressTwo = 16'h00F0;
      addressThree = 16'h0F00;
      addressFour = 16'hF000;
    end
    
    assign selectAddressOne = (ADR_I == ADDRESS_ONE) ? (1'b1) : (1'b0);
    assign selectAddressTwo = (ADR_I == ADDRESS_TWO) ? (1'b1) : (1'b0);
    assign selectAddressThree = (ADR_I == ADDRESS_THREE) ? (1'b1) : (1'b0);
    assign selectAddressFour = (ADR_I == ADDRESS_FOUR) ? (1'b1) : (1'b0);
    
    assign AD_IO = (selectAddressOne & CYC_I & STB_I & ~WE_I) ? addressOne : 16'bZ;
    assign AD_IO = (selectAddressTwo & CYC_I & STB_I & ~WE_I) ? addressTwo : 16'bZ;
    assign AD_IO = (selectAddressThree & CYC_I & STB_I & ~WE_I) ? addressThree : 16'bZ;
    assign AD_IO = (selectAddressFour & CYC_I & STB_I & ~WE_I) ? addressFour : 16'bZ;
    
    always @(posedge CLK) begin
      if(CYC_I & WE_I & STB_I) begin
        case(1'b1)
          selectAddressOne: begin
            addressOne <= AD_IO;
          end
          selectAddressTwo: begin
            addressTwo <= AD_IO;
          end
          selectAddressThree: begin
            addressThree <= AD_IO;
          end
          selectAddressFour: begin
            addressFour <= AD_IO;
          end
          default: begin
            if(DEBUG_MODE) begin
              $display("%t: (Mojo) Can't write to address", $time);
            end
          end
        endcase
      end
    end
    
    
endmodule
