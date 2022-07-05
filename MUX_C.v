`timescale 1ns / 1ps


module MUX_C(BS,PCIn,PCout,BrA,RAA,PS,Z);
input PS,Z;
input [1:0] BS;
input [7:0] BrA,RAA,PCIn;
output [7:0] PCout;
wire [1:0] select;

assign Select = BS[0] & (BS [1] | (PS^Z));
assign PCout = (Select == 2'b00) ? PCIn:
               (Select == 2'b01) ? BrA:
               (Select == 2'b10) ? RAA:
               (Select == 2'b11) ? BrA:
               7'b0;
endmodule

//assign select[0] = BS[0];
//assign select[1] = (PS^Z)|BS[0]&BS[0];

//always@(PS,BS,Z)
//case(select)
//2'b00: out = a;
//2'b01: out = b;
//2'b01: out = c;
//2'b01: out = d;
//endcase
//endmodule
