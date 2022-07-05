`timescale 1ns / 1ps


module Branch_select(
    input [7:0]pc,
    input [7:0]bus_B,
    output [7:0]BrA
    );    
assign BrA=pc+bus_B;         
endmodule

