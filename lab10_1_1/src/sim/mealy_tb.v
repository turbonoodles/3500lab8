`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2021 02:17:55 PM
// Design Name: 
// Module Name: mealy_tb
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


module mealy_tb(

    );

reg clk;
reg reset;
reg ain;
reg yout;

// count register
reg [3:0] count = 4'b1111; // this is stupid but it seems to be what we want
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

// TESTBENCH TIME
always begin
    #1;
    clk = ~clk;
end

initial begin
    // just going to implement the lab input waveforms
    clk = 0;
    reset = 1;
    ain = 0;

    #4;
    reset = 0;

    #4;
    ain = 1;

    #4;
    ain=0;

    #12;
    ain = 1;

    #8;
    ain = 0;

    #4;
    ain = 1;

    #2;
    reset = 1;

    #2;
    $finish;

end

endmodule
