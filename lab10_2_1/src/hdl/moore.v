`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2021 03:35:48 PM
// Design Name: 
// Module Name: moore
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


module moore(
    input wire clk,
    input wire reset,
    input wire [1:0] ain,
    output reg yout = 0
    );

// state definitions
parameter [3:0] R = 4'b0000; // reset state
parameter [3:0] G01 = 1, G0100 = 4;
parameter [3:0] G11 = 3, G1100 = 5;
parameter [3:0] G10 = 4'b0010;
parameter [3:0] G1000H = 4'b0110;
parameter [3:0] G1000L = 4'b1110;
parameter [3:0] H = 7; // hold state

reg [2:0] state = R;
reg [2:0] next_state;
// drive state machine
always @( posedge clk, posedge reset ) begin
    if (reset) state <= R;
    else state <= next_state;
end

// calculate next state
always @( state, ain ) begin
    case ( state )
        R: begin
            case (ain)
                2'b01: next_state = G01;
                2'b10: next_state = G10;
                2'b11: next_state = G11;
                default: next_state = R;
            endcase
        end
        H: begin
            case (ain)
                2'b01: next_state = G01;
                2'b10: next_state = G10;
                2'b11: next_state = G11;
                default: next_state = H;
            endcase
        end
        G01: begin
            case (ain)
                2'b00: next_state = G0100;
                2'b01: next_state = G01;
                2'b10: next_state = G10;
                2'b11: next_state = G11;
                default: next_state = H;
            endcase
        end
        G10: begin
            case (ain)
                2'b00: begin
                    if ( yout ) next_state = G1000H;
                    else next_state = G1000L;
                end
                2'b01: next_state = G01;
                2'b10: next_state = G10;
                2'b11: next_state = G11;
                default: next_state = H;
            endcase
        end
        G11: begin
            case (ain)
                2'b00: next_state = G1100;
                2'b01: next_state = G01;
                2'b10: next_state = G10;
                2'b11: next_state = G11;
                default: next_state = H;
            endcase
        end
        G1100: begin
            case (ain)
                2'b00: next_state = H;
                2'b01: next_state = G01;
                2'b10: next_state = G10;
                2'b11: next_state = G11;
                default: next_state = H; 
            endcase
        end
        G1000L: begin
            case (ain)
                2'b00: next_state = H;
                2'b01: next_state = G01;
                2'b10: next_state = G10;
                2'b11: next_state = G11;
                default: next_state = H; 
            endcase
        end 
        G1000H: begin
            case (ain)
                2'b00: next_state = H;
                2'b01: next_state = G01;
                2'b10: next_state = G10;
                2'b11: next_state = G11;
                default: next_state = H; 
            endcase
        end        
        G0100: begin
            case (ain)
                2'b00: next_state = H;
                2'b01: next_state = G01;
                2'b10: next_state = G10;
                2'b11: next_state = G11;
                default: next_state = H; 
            endcase
        end
        default: next_state = state; 
    endcase
end

reg yout_prev;
// calculate outputs
always @( state ) begin
    yout_prev = yout;
    yout = 0;
    if ( state == R ) yout = 0;
    else if ( state == G1100 ) yout = 1; // synchronous set
    else if ( state == G0100 ) yout = 0; // synchronous clear
    else if ( state == G1000H ) yout = 0; // toggle
    else if ( state == G1000L ) yout = 1; // toggle
    else yout = yout_prev; // for states G01, G10, G11, and H
end 

endmodule
