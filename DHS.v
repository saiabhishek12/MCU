`timescale 1ns / 1ps

module DHS(
input MA,
input MB,
input RW,
input [2:0]AA,
input [2:0]BA,
input [2:0]DA,
output DHS_O,DHS_I
);

wire hb1,hb2,ha1,ha2,da,ca,ha,hb;


comp CB(.a(DA),.b(BA),.r(hb1));
not(hb2,MB);
comp CA(.a(DA),.b(AA),.r(ha1)); 
not(ha2,MA);
or(da,DA[2],DA[1],DA[0]);
and(hb,hb1,hb2,RW,da);
and(ha,ha1,ha2,RW,da);

or(DHS_O,hb,ha);
not(DHS_I,DHS_O);
 

endmodule



module comp(
    input [2:0]a,
    input [2:0]b,
    output reg r
);

always@(a,b)
if(a==b)
    begin
        r <=1'b1;
    end    
else
    begin
        r <=1'b0;
    end        
endmodule