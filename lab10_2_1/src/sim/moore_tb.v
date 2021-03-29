`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2021 03:36:07 PM
// Design Name: 
// Module Name: moore_tb
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


module moore_tb(

    );

reg clk;
reg reset;
reg [1:0] ain;
reg yout = 0;

// state definitions
parameter [3:0] R = 4'b0000; // reset state
parameter [3:0] G01 = 1, G0100 = 4;
parameter [3:0] G11 = 3, G1100 = 5;
parameter [3:0] G10 = 2, G1000 = 6;
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
    #1;
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
                2'b00: next_state = G1000;
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
        G1000: begin
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

// calculate outputs
always @( state ) begin
    if ( state == R ) yout = 0;
    else if ( state == G1100 ) yout = 1; // synchronous set
    else if ( state == G0100 ) yout = 0; // synchronous clear
    else if ( state == G1000 ) yout = ~yout; // toggle
end 

//testbench stuff
initial begin
    clk = 0;
    reset = 1;
    ain = 0;
    
    #20;
    reset = 0;

    #10;
    ain = 3;
    #10;
    ain = 2;
    #10;
    ain = 0;

    #20;
    ain = 2;
    #10;
    ain = 0;
    #10;
    ain = 3;
    #10;
    ain = 0;
    #10;
    ain = 1;
    #10;
    ain = 0;
    #10;
    ain = 2;
    #10;
    ain = 3;
    #10;
    ain = 0;

    #10;
    reset = 1;
    #10;
    reset = 0;
    #10;

    ain = 2;
    #30;
    ain = 3;
    #30;
    $finish;
end

always begin
    #5;
    clk = ~clk;
end

endmodule
