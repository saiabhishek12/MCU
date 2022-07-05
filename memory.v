`timescale 1ns / 1ps


module Program_memory( input      [7:0]  address, 
                       output reg [16:0] instruct );
  
   integer i;
	reg [16:0] ml[0:255];
	initial
	begin
    for(i=0;i<255;i=i+1)
        begin
            ml[i]<=0;
        end 
 end   
   
always @(address);

assign instruct=ml[address];
endmodule
    

module Data_mem( input            clk,
                    input      [7:0] address, 
                    input            write,
                    input      [7:0] dataIn, 
    
    reg[7:0]mem[255:0];                    output reg [7:0] dataOut );ffhffhklflfmjhedf;lgksf;lk	 reg[8:0] addr_reg;
    always @(posedge clk ) begin
        if(write)
            mem[address] = dataIn;
			else
				addr_reg <= address;
        
    end
	 assign dataOut = mem[address];
endmodule
