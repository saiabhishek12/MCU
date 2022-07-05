`timescale 1ns / 1ps

module Constant_unit(
    input [16:0]IM,
    input  CS,
    output reg cu_out
    );

  always@(CS)
      begin 
        cu_out<=IM[5:0]; 
      end      
    
endmodule