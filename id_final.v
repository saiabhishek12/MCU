`timescale 1ns / 1ps

module Instruction_Decoder(input [16:0] instruct,

			 output  RW,
			 output  da,
			 output  [1:0] mds,
			 output  [1:0] bs,
			 output  ps1,
			 output  [2:0] mw,
			 output  [3:0] fsel,
			 output  mas,
			 output  mbs,
			 output  [2:0] regaa,
			 output  [2:0] regba,
			 output  consel
    );
	
reg RW_WIRE, PS_WIRE,MW_WIRE, MA_WIRE, MB_WIRE, CS_WIRE;
reg [2:0]DA_WIRE; 
reg [1:0]MD_WIRE;
reg [1:0]BS_WIRE;
reg [3:0]FS_WIRE;
reg [2:0]AA_WIRE;
reg [2:0]BA_WIRE;
reg[4:0]opcode; 
		
		always @(*)
		begin
		case (instruct [16:12])
		
		5'b00000: begin//No OP
		RW_WIRE = 1'b0; 
		DA_WIRE = 3'b000; 
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b00;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b0000; 
		MA_WIRE = 1'b0; 
		MB_WIRE = 1'b0; 
		AA_WIRE = 3'b000; 
		BA_WIRE = 3'b000; 
		CS_WIRE = 1'b0;
		end
		
		5'b00001:begin //load
		RW_WIRE = 1'b1; 
		DA_WIRE = instruct[11:9]; 
		MD_WIRE = 2'b01;
		BS_WIRE = 2'b00;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b0000; 
		MA_WIRE = 1'b0; 
		MB_WIRE = 1'b0; 
		AA_WIRE = instruct[8:6]; 
		BA_WIRE = 3'b000; 
		CS_WIRE = 1'b0;  
		end
		
		5'b00010:begin //store
		RW_WIRE = 1'b0; 
		DA_WIRE = instruct[11:9]; 
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b00;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b1;
		FS_WIRE = 4'b0000; 
		MA_WIRE = 1'b0;
		MB_WIRE = 1'b0; 
		AA_WIRE = instruct[8:6]; 
		BA_WIRE = instruct[5:3]; 
		CS_WIRE = 1'b0;
		end
		
		5'b00011:begin //move
		RW_WIRE = 1'b1; 
		DA_WIRE = instruct[11:9];
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b00;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b0001;
		MA_WIRE = 1'b0; 
		MB_WIRE = 1'b0; 
		AA_WIRE = instruct[8:6]; 
		BA_WIRE = instruct[5:3]; 
		CS_WIRE = 1'b0; 
		end
		
		5'b00100:begin //input
		RW_WIRE = 1'b1;
		DA_WIRE = instruct[11:9]; 
		MD_WIRE = 2'b10;
		BS_WIRE = 2'b00;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b0000; 
		MA_WIRE = 1'b0; 
		MB_WIRE = 1'b0; 
		AA_WIRE = instruct[8:6]; 
		BA_WIRE = 3'b000; 
		CS_WIRE = 1'b0;  
		end
		
		5'b00101:begin //output
		RW_WIRE = 1'b0;
		DA_WIRE = 3'b000; 
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b11;
		PS_WIRE = 1'b1;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b1000; 
		MA_WIRE = 1'b0; 
		MB_WIRE = 1'b1; 
		AA_WIRE = instruct[8:6]; 
		BA_WIRE = 3'b000; 
		CS_WIRE = 1'b1; 
		end
		
		5'b01010:begin //jump register 
		RW_WIRE = 1'b0; 
		DA_WIRE = 3'b000; 
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b01;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b1000;
		MA_WIRE = 1'b0;
		MB_WIRE = 1'b1;
		AA_WIRE = instruct[8:6];
		BA_WIRE = 3'b000; 
		CS_WIRE = 1'b1;  
		end
		
		5'b01011:begin //jump
		RW_WIRE = 1'b0; 
		DA_WIRE = 3'b000; 
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b00;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b1;
		FS_WIRE = 4'b0000; 
		MA_WIRE = 1'b0; 
		MB_WIRE = 1'b0; 
		AA_WIRE = instruct[8:6];
		BA_WIRE = instruct[5:3];
		CS_WIRE = 1'b0; 
		end
		
		5'b01100:begin //jump and link
		RW_WIRE = 1'b1; 
		DA_WIRE = instruct[11:9]; 
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b00;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b1101; 
		MA_WIRE = 1'b0; 
		MB_WIRE = 1'b0; 
		AA_WIRE = instruct[8:6]; 
		BA_WIRE = 3'b000; 
		CS_WIRE = 1'b0; 
		end
		
		5'b10000:begin //AND immediate 
		RW_WIRE = 1'b1; 
		DA_WIRE = instruct[11:9];
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b00;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b1000; 
		MA_WIRE = 1'b0; 
		MB_WIRE = 1'b0; 
		AA_WIRE = 3'b000;
		BA_WIRE = 3'b000; 
		CS_WIRE = 1'b0;
		end
		
		5'b10001:begin //exclusive OR
		RW_WIRE = 1'b1; 
		DA_WIRE = instruct[11:9]; 
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b00;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b1010; 
		MA_WIRE = 1'b0; 
		MB_WIRE = 1'b0; 
		AA_WIRE = instruct[8:6];
		BA_WIRE = instruct[5:3];
		CS_WIRE = 1'b0;  
    
		end
		
		5'b10010:begin //OR
		RW_WIRE = 1'b1;
		DA_WIRE = instruct[11:9];
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b00;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b1001; 
		MA_WIRE = 1'b0;
		MB_WIRE = 1'b1; 
		AA_WIRE = instruct[8:6]; 
		BA_WIRE = 3'b000; 
		CS_WIRE = 1'b0;
		end
		
		5'b10011:begin //compliment / NOT comeback
		RW_WIRE = 1'b1; 
		DA_WIRE = instruct[11:9]; 
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b00;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b0001; 
		MA_WIRE = 1'b0; 
		MB_WIRE = 1'b0;
		AA_WIRE = ~(instruct[8:6]); 
		BA_WIRE = 3'b000; 
		CS_WIRE = 1'b0;  
    
		end
		
		5'b10101:begin //logical shift left
		RW_WIRE = 1'b1;
		DA_WIRE = instruct[11:9]; 
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b00;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b0110; 
		MA_WIRE = 1'b0; 
		MB_WIRE = 1'b0; 
		AA_WIRE = instruct[8:6];
		BA_WIRE = 3'b000; 
		CS_WIRE = 1'b0;
    
		end
		
		5'b10110:begin //logical shift right comeback
		RW_WIRE = 1'b1; 
		DA_WIRE = instruct[11:9];  
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b00;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b0111; 
		MA_WIRE = 1'b0; 
		MB_WIRE = 1'b0; 
		AA_WIRE = instruct[8:6]; 
		BA_WIRE = 3'b000; 
		CS_WIRE = 1'b0;
		
		/*RW = 1;
		da = 3'b001;
		mds = 2'b01;
		bs = bs+1;
		ps1 = 2'b00;
		mw = 1;
		fsel = 4'b0101;
		mas = 1;
		mbs = 0;
		regaa = 3'b001;
		regba = 3'b000;
		consel = 0;*/
		end
		
		5'b11001:begin //ADD
		RW_WIRE = 1'b1;
		DA_WIRE = instruct[11:9]; 
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b00;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b0000;
		MA_WIRE = 1'b0; 
		MB_WIRE = 1'b0; 
		AA_WIRE = instruct[8:6]; 
		BA_WIRE = instruct[5:3]; 
		CS_WIRE = 1'b0;  
    
		end
		
		5'b11010:begin //ADD immediate comeback
		RW_WIRE = 1'b1; 
		DA_WIRE = instruct[11:9];
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b00;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b0000; 
		MA_WIRE = 1'b0; 
		MB_WIRE = 1'b1; 
		AA_WIRE = instruct[8:6];
		BA_WIRE = 3'b000; 
		CS_WIRE = 1'b0;
		
		/*RW = 1;
		da = 3'b001;
		mds = 2'b01;
		bs = bs+1;
		ps1 = 2'b00;
		mw = 1;
		fsel = 4'b0000;
		mas = 1;
		mbs = 1;
		regaa = 3'b001;
		regba = 3'b010;
		consel = 0;*/
		end
		
		5'b11011:begin //SUB
		RW_WIRE = 1'b1; 
		DA_WIRE = instruct[11:9]; 
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b00;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b0001; 
		MA_WIRE = 1'b0; 
		MB_WIRE = 1'b0; 
		AA_WIRE = instruct[8:6]; 
		BA_WIRE = instruct[5:3]; 
		CS_WIRE = 1'b0; 
    
		end
		
		5'b11100:begin //branch if non zero
		RW_WIRE = 1'b0; 
		DA_WIRE = 3'b000;
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b11;
		PS_WIRE = 1'b1;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b1000; 
		MA_WIRE = 1'b0; 
		MB_WIRE = 1'b1; 
		AA_WIRE = instruct[8:6];
		BA_WIRE = 3'b000; 
		CS_WIRE = 1'b1; 
    
		end
		
		5'b11101:begin //branch if zero
		RW_WIRE = 1'b0; 
		DA_WIRE = 3'b000;
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b01;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b1000; 
		MA_WIRE = 1'b0; 
		MB_WIRE = 1'b1; 
		AA_WIRE = instruct[8:6]; 
		BA_WIRE = 3'b000; 
		CS_WIRE = 1'b1;
    
		end
		
		5'b11111:begin //set if less than
		RW_WIRE = 1'b1; 
		DA_WIRE = instruct[11:9]; 
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b00;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b1001; 
		MA_WIRE = 1'b0; 
		MB_WIRE = 1'b0; 
		AA_WIRE = instruct[8:6]; 
		BA_WIRE = instruct[5:3]; 
		CS_WIRE = 1'b0;
    
		end
	default:begin
		RW_WIRE = 1'b0; 
		DA_WIRE = 3'b000; 
		MD_WIRE = 2'b00;
		BS_WIRE = 2'b00;
		PS_WIRE = 1'b0;
		MW_WIRE = 1'b0;
		FS_WIRE = 4'b0000; 
		MA_WIRE = 1'b0; 
		MB_WIRE = 1'b0; 
		AA_WIRE = 3'b000;
		BA_WIRE = 3'b000; 
		CS_WIRE = 1'b0;
		end
	endcase
	end

assign RW = RW_WIRE;
assign da = DA_WIRE;
assign mds = MD_WIRE;
assign bs = BS_WIRE;
assign ps1 = PS_WIRE;
assign mw = MW_WIRE;
assign fsel = FS_WIRE;
assign mas = MA_WIRE;
assign mbs = MB_WIRE;
assign regaa = AA_WIRE;
assign regba = BA_WIRE;
assign consel = CS_WIRE;	

endmodule
