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
// all permanently-high states set the MSB
parameter [3:0] R = 4'b0000; // reset state
parameter [3:0] G01L = 1, G01H = 9;
parameter [3:0] G0100 = 4;
parameter [3:0] G11L = 3, G11H = 11;
parameter [3:0] G1100 = 5;
parameter [3:0] G10L = 2, G10H = 10;
parameter [3:0] G1000H = 8;
parameter [3:0] G1000L = 14;
parameter [3:0] HoldL = 7; // hold low output
parameter [3:0] HoldH = 6; // hold high output

reg [2:0] state = R;
reg [2:0] next_state;
// drive state machine
always @( posedge clk, posedge reset ) begin
    if (reset) state <= R;
    else state <= next_state;
end

// calculate next state
always @( state, ain, yout ) begin
    #1;
    case ( state )
        R: begin
            if ( yout ) begin
                case (ain)
                    2'b01: next_state = G01H;
                    2'b10: next_state = G10H;
                    2'b11: next_state = G11H;
                    default: next_state = R;
                endcase
            end
            else begin
                case (ain)
                    2'b01: next_state = G01L;
                    2'b10: next_state = G10L;
                    2'b11: next_state = G11L;
                    default: next_state = R;
                endcase
            end
        end
        HoldH: begin
            case (ain)
                2'b01: next_state = G01H;
                2'b10: next_state = G10H;
                2'b11: next_state = G11H;
                default: next_state = HoldH;
            endcase
        end
        HoldL: begin
            case (ain)
                2'b01: next_state = G01L;
                2'b10: next_state = G10L;
                2'b11: next_state = G11L;
                default: next_state = HoldL;
            endcase
        end
        G01H: begin
            case (ain)
                2'b00: next_state = G0100;
                2'b01: next_state = G01H;
                2'b10: next_state = G10H;
                2'b11: next_state = G11H;
                default: next_state = HoldH;
            endcase
        end
        G01L: begin
                case (ain)
                    2'b00: next_state = G0100;
                    2'b01: next_state = G01L;
                    2'b10: next_state = G10L;
                    2'b11: next_state = G11L;
                    default: next_state = HoldL;
                endcase
            end
        G10H: begin
            case (ain)
                2'b00: next_state = G1000L; // toggle
                2'b01: next_state = G01H;
                2'b10: next_state = G10H;
                2'b11: next_state = G11H;
                default: next_state = HoldH;
            endcase
        end
        G10L: begin
                case (ain)
                    2'b00: next_state = G1000H; // toggle
                    2'b01: next_state = G01L;
                    2'b10: next_state = G10L;
                    2'b11: next_state = G11L;
                    default: next_state = HoldL;
                endcase   
        end
        G11H: begin
                case (ain)
                    2'b00: next_state = G1100;
                    2'b01: next_state = G01H;
                    2'b10: next_state = G10H;
                    2'b11: next_state = G11H;
                    default: next_state = HoldH;
                endcase
        end
        G11L: begin
                 case (ain)
                    2'b00: next_state = G1100;
                    2'b01: next_state = G01L;
                    2'b10: next_state = G10L;
                    2'b11: next_state = G11L;
                    default: next_state = HoldH;
                endcase
        end
        G1100: begin
            case (ain) // this will set
                2'b00: next_state = HoldH;
                2'b01: next_state = G01H;
                2'b10: next_state = G10H;
                2'b11: next_state = G11H;
                default: begin
                    if ( yout ) next_state = HoldH;
                    else next_state = HoldL;
                end
            endcase
        end
        G1000L: begin
            case (ain) 
                2'b00: next_state = HoldL;
                2'b01: next_state = G01L;
                2'b10: next_state = G10L;
                2'b11: next_state = G11L;
                default: next_state = HoldL;
            endcase
        end 
        G1000H: begin
            case (ain)
                2'b00: next_state = HoldH;
                2'b01: next_state = G01H;
                2'b10: next_state = G10H;
                2'b11: next_state = G11H;
                default: next_state = HoldH;
            endcase
        end        
        G0100: begin
            case (ain) // this will clear
                2'b00: next_state = HoldL;
                2'b01: next_state = G01L;
                2'b10: next_state = G10L;
                2'b11: next_state = G11L;
                default: begin
                    if ( yout ) next_state = HoldH;
                    else next_state = HoldL;
                end 
            endcase
        end
        default: next_state = state;
    endcase
end

// calculate outputs
always @( state ) begin
    case ( state )
        R: yout = 0;
        G10H: yout = 1;
        G10L: yout = 0;
        G11H: yout = 1;
        G11L: yout = 0;
        G01H: yout = 1;
        G01L: yout = 0;
        G1100: yout = 1;
        G0100: yout = 0;
        G1000H: yout = 1;
        G1000L: yout = 0;
        HoldL: yout = 0;
        HoldH: yout = 1;
        default: yout = 0;
    endcase
end 

endmodule
