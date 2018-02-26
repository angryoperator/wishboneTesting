`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2018 10:39:11 AM
// Design Name: 
// Module Name: arty_top
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

module arty_top(
      SYS_CLK,
      SW,
      LEDB,
      LEDG,
      LEDR,
      LED,
      BTN,
      JA,
      JB,
      JC,
      JD,
      CKIO
    );
    // - Define 'puts - //
    input SYS_CLK;
    input [3:0] SW;
    output [3:0] LEDB, LEDG, LEDR, LED;
    input [3:0] BTN;
    inout [7:0] JA, JB, JC, JD;
    output [41:0] CKIO;
    
    // - Parameters - //
    parameter DEBUG_MODE = 0;
    
    // - Define Locals - // 
    // -- WB Signals -- //
    wire top_cyc;
    wire top_stb;
    wire top_we;
    wire top_ack;
    reg [15:0] top_dat_i;
    reg [15:0] top_dat_o;
    // -- Registers -- //
    reg [15:0] top_data;
    reg [7:0] top_adr;
    // -- Wires -- //
    wire reset_n;
    
    // - Initialize - //
    initial begin
      top_dat_i = 0;
      top_dat_o = 0;
      top_data = 0;
      top_adr = 0;
    end
    
    // - Assignments - //
    assign top_cyc = JD[3];
    assign top_we = JD[2];
    assign top_stb = JD[1];
    assign top_ack = JD[0];
    
    assign JA = (top_cyc & top_stb) ? (top_adr) : (16'bZ);
    assign {JB, JC} = (top_cyc & top_stb & top_we) ? (top_data) : (16'bZ);
    
    button_debouncer #(
      .DEBUG_MODE(0)
    ) reset_btn_debouncer (
      .sys_clk(SYS_CLK),
      .btn_in(BTN[0]),
      .btn_out(reset_n)
    );
    
    always @(posedge SYS_CLK) begin
      if(top_cyc & top_stb & ~top_we) begin
        top_data <= {JB, JC};
      end
    end
    
    always @(posedge SYS_CLK) begin
      
    end
    
endmodule
