`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2018 03:06:38 PM
// Design Name: 
// Module Name: button_debouncer
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


module button_debouncer(
      sys_clk,
      btn_in,
      btn_out
    );
    // - Define 'puts - //
    input sys_clk;
    input btn_in;
    output btn_out;
    
    // - Parameters - //
    parameter DEBUG_MODE = 0;
    parameter DELAY_TIME = 0;
    
    // - Locals - //
    // -- FSM Locals -- //
//    reg [2:0] state, next;
//    localparam IDLE=0, ACTIVE=1, DELAY=2;
    
    // -- Registers -- //
    reg [31:0] delayTimer;
    reg buttonPush;
    reg [1:0] btnSBuffer;
    reg btnPolFlipped;
    reg btnOutBuffer;
    
    // -- Wires -- //
    wire activeDone;
    wire delayDone;
    wire [2:0] btnPolStatus;
    wire btnRisingEdge;
    wire btnFallingEdge;
    wire btnInBuffer;
    
    // - Initialize - //
    initial begin
      delayTimer = 0;
      btnSBuffer = 0;
      btnPolFlipped = 0;
      btnOutBuffer = 0;
    end
    // - Assigns - //
    assign delayDone = (delayTimer >= DELAY_TIME) ? (1'b1) : (1'b0);
    assign btnPolStatus = {btnPolFlipped, btnSBuffer};
    assign btnRisingEdge = (btnPolStatus == 3'b101) ? (1'b1) : (1'b0);
    assign btnFallingEdge = (btnPolStatus == 3'b110) ? (1'b1) : (1'b0);
    
//    // - FSM - //
//    // -- Synchronous State Transition -- //
//      always @(posedge sys_clk) begin
//        if(sys_rst) begin
//          state[IDLE] <= 1;
//        end else begin
//          state <= next;
//        end
//      end
//      
//      // -- Asynchronous State Logic -- //
//      always @* begin
//        next = 0;
//        case(1)
//          state[IDLE]: begin
//            if(1) begin 
//              next[ACTIVE] = 1;
//            end else begin
//              next[IDLE] = 1;
//            end
//          end
//          state[ACTIVE]: begin
//            if(1) begin 
//              next[IDLE] = 1;
//            end else if(1) begin
//              next[DELAY] = 1;
//            end else begin
//              next[ACTIVE] = 1;
//            end
//          end
//          state[DELAY]: begin
//            if(1) begin 
//              next[IDLE] = 1;
//            end else begin
//              next[DELAY] = 1;
//            end 
//          end
//        endcase
//      end
//    
    // - Operations - //
    IBUF #(
      .IOSTANDARD("DEFAULT")
    ) IBUF_BTN (
      .O(btnInBuffer),
      .I(btn_in)
    );
//    
//    
//    // -- Delay Timer -- //
//    always @(posedge sys_clk) begin
//      if(state[DELAY]) begin
//        if(delayTimer <= DELAY_TIME) begin
//          delayTimer <= delayTimer + 1'b1;
//        end else begin
//          delayTimer <= delayTimer;
//        end
//      end else begin
//        delayTimer <= 'b0;
//      end
//    end
    
    // -- BTN Debouncing -- //
   
    always @(posedge sys_clk) begin
      btnSBuffer <= {btnSBuffer[0], btnInBuffer};
      if(btnSBuffer[1] != btnInBuffer) begin
        btnPolFlipped = 1;
      end else begin
        btnPolFlipped = 0;
      end
    end
    
    always @(posedge sys_clk) begin
      if(btnRisingEdge) begin
        btnOutBuffer <= 1'b1;
      end else begin
        btnOutBuffer <= 1'b0;
      end
    end
    
endmodule
