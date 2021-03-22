`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2021 02:17:26 PM
// Design Name: 
// Module Name: mealy
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


module mealy(
    input wire clk,
    input wire reset,
    input wire ain,
    output reg yout,
    output reg [3:0] count = 4'b1111
    );

// count register
reg [3:0] next_count;
// let's count some ones
always @(posedge clk, posedge reset) begin
    if (reset) count <= 0;
    else count <= next_count;
end

// compute the next value of count
always @( count, ain ) begin
    if ( ain ) begin
        if ( count == 15 ) next_count = 0;
        else next_count = count + 1;
    end
    else begin // ~ain
        next_count = count;
    end
end

// compute the value of yout
always @(count, ain) begin
    // current count is divisible by 3; input makes it not
    if ( count == 3 | count == 6 | count == 9 | count == 12 | count == 15 ) begin
        yout = ~ain;
    end
    // for (n+1)%3=0; adding a one makes it divisible by 3
    else if ( count == 2 | count == 5 | count == 8 | count == 13 | count == 14 ) begin
        yout = ain;
    end
    // for 0, 1, 4, ... it doesn't matter; the input isn't enough for %3=0
    else begin
        yout = 0;
    end
end

endmodule
