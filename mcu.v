`timescale 1ns / 1ps

module MCU(
		//input [7:0] a,
		//output [3:0] b,c,
		//output write_enable,
    input clk,reset,
	 input [8:0] fpga_in,
    output [9:0] fpga_out,
	 //output Out
	 output reg [16:0] Out,PC,IR,A,B,F
);
                                                                    // Initial Stage
// Register
reg [7:0] PC_R;

//Wire
wire [7:0] MuxC_Out;
                                                           //Instruction Fetch stage

   // Wire
wire [7:0] Pc_Fetch, Pc_pc1_Fetch;
wire [16:0] Inst_Fetch;
wire [16:0] Branch_Fetch;

    // Register
reg [7:0] Pc1_IF_R;
reg [16:0] IR_IF_R;

   // Assign PC_Fetch
assign Pc_Fetch = PC_R;

//PC_P1_Fetch Update
assign Pc_pc1_Fetch = PC_R + 8'h1;  

// Performing ProgramMem Fetch
Program_memory PmemFetch(.address(Pc_Fetch),.instruct(Inst_Fetch));

                                                                 // Decoder Stage

// WIRES
wire [2:0] AA_Decoder,BA_Decoder, DA_Dec, SH_Dec;
wire [7:0] A_Data_Decoder,B_Data_Decoder,PC1_Dec;
wire RW_Dec,PS_Dec,MW_Dec, MA_Dec, MB_Dec,CS_Dec;
wire [1:0] MD_Dec, BS_Dec;
wire [3:0] FS_Dec;
wire [7:0] busA_Dec, busB_Dec, constant_output_Dec;
wire [5:0] IM_Dec;
wire [16:0] IR_Dec;


// Register 
reg [7:0] PC2_Dec_R, busA_Dec_R,busB_Dec_R;
reg RW_Dec_R,PS_Dec_R,MW_Dec_R;
reg [2:0] DA_Dec_R,SH_Dec_R;
reg [1:0] MD_Dec_R, BS_Dec_R;
reg [3 :0] FS_Dec_R;

// Assignment of Wires
assign PC1_Dec = Pc1_IF_R;
assign IR_Dec = IR_IF_R;
assign IM_Dec = IR_IF_R[5:0];
assign SH_Dec = IR_IF_R[2:0];


//Call Functions

//Instruction Decoder
Instruction_Decoder InstructionDecoderCall(.instruct(IR_Dec),.RW(RW_Dec),.da(DA_Dec),.mds(MD_Dec),
           .ps1(PS_Dec),.mw(MW_Dec),.fsel(FS_Dec),.mas(MA_Dec),.mbs(MB_Dec),.regaa(AA_Decoder),.regba(BA_Decoder),.consel(CS_Dec));
           
// Constant Unit Call
Constant_unit ConstantunitCall(.IM(IM_Dec),.CS(CS_Dec),.cu_out(constant_output_Dec));
   
//Branch Detection Call
BranchDetection BranchdetectCall(.BS_In(BS_Dec),.RW_In(RW_Dec),.MW_In(MW_Dec),.PS_In(PS_Dec),.Inst_In(Inst_Fetch),.BranchD_O(Branch_Fetch),.BS_N(BS_Invert_wire));   


MUX_A MUX_A(.registerA(A_Data_Decoder),.pc_1(PC1_Dec),.bus_A(busA_Dec),.MA(MA_Dec));
MUX_B MUX_B(.registerB(B_Data_Decoder),.CS(CS_Dec),.MB(MB_Dec),.bus_B(busB_Dec));

                                                                // Execution Stage

// WIRES
wire RW_EX,PS_EX, MW_EX;
wire [2:0] DA_EX,SH_EX; 
wire [1:0] MD_EX;
wire [3:0] FS_EX; 
wire [7:0] PC2_EX;
wire [7:0] BrA_EX; 
wire [7:0] BusB_EX,RAA_EX;
wire [7:0] ALU_FS_EX,Datamem_EX;
wire Zero_EX,Carry_EX,Neg_EX,Overflow_EX;
wire DHS_Out, DHS_Not_W;

// REGISTER
reg RW_EX_R;
reg [2:0] DA_EX_R;
reg [1:0] MD_EX_R;
reg [7:0] ALU_EX_R, Datamem_EX_R;

//Assignment of Wires
assign RW_EX = RW_Dec_R; 
assign PS_EX = PS_Dec_R;
assign MW_EX = MW_Dec_R;
assign DA_EX = DA_Dec_R; 
assign SH_EX = SH_Dec_R;
assign MD_EX = MD_Dec_R;
assign BS_EX = BS_Dec_R;
assign FS_EX = FS_Dec_R;
assign PC2_EX = PC2_Dec_R; 
assign BusB_EX = busB_Dec_R;
assign RAA_EX = busA_Dec_R;



// Adder Call
Branch_select AdderCall(.pc(PC2_EX),.bus_B(BusB_EX),.BrA(BrA_EX));

// ALU Call
ALU ALUCall(.ALU_Sel(FS_EX),.shift(SH_EX),.A(RAA_EX),.B(BusB_EX),.ALU_Out(ALU_FS_EX),.zero(Zero_EX),.neg(Neg_EX),.carry(Carry_EX),.overflow(Overflow_EX));

// Data Memory Call
Data_mem DataMemCall(.clk(clk),.address(RAA_EX),.write(MW_EX),.dataIn(BusB_EX),.dataOut(Datamem_EX));


// DHS Call
DHS DHSCall(.MA(MA_Dec),.MB(MB_Dec),.RW(RW_EX),.AA(AA_Decoder),.BA(BA_Decoder),.DA(DA_EX),.DHS_O(DHS_Out),.DHS_I(DHS_Not_W));

                                                           // Last stage -- Write Back //

mcu_io IO_MODULE(.clk(clk),.reset(reset),.output_write_enable(RW_OUT_Execution),.output_data_in(B_IO_Execution),.output_data_address(A_IO_Execution),.input_data_out(IO_OUT_Execution),.fpga_in(fpga_in),.fpga_out(fpga_out));

///WIRES
wire [7:0] alu_wb,da_wb,busD_wb;
wire rw_wb;
wire [2:0] datamem_wb;
wire [1:0] md_wb;

//Assignment
assign alu_wb = ALU_EX_R;
assign da_wb = DA_EX_R;
assign rw_wb = RW_EX_R;
assign datamem_wb = Datamem_EX_R;
assign md_wb = MD_EX_R;
// Register file call
Reg_f Regfile_Fetch(.clk(clk),.address_of_a(AA_Decoder),.address_of_b(BA_Decoder),.address_of_d(da_wb),.dataIn(busD_wb),.write(rw_wb),.data_of_a(A_Data_Decoder),.data_of_b(B_Data_Decoder));
// MUX D Call
MUX_D MUX_D_Call(.alu_fs(alu_wb),.datamem_out(datamem_wb),.MD(md_wb),.bus_D(busD_wb));

MUX_C MUX_C(.BS(BS_EX),.PCIn(Pc_pc1_Fetch),.PCout(MuxC_Out),.BrA(BrA_EX),.RAA(RAA_EX),.PS(PS_EX),.Z(Zero_Ex));


// Initilization of Registers

initial begin

// Initial stage
PC_R = 0;
Pc1_IF_R = 0;
IR_IF_R = 0;

 // Decoder stage

PC2_Dec_R = 0;
busA_Dec_R = 0;
busB_Dec_R = 0;
RW_Dec_R = 0;
PS_Dec_R = 0;
MW_Dec_R = 0;
DA_Dec_R = 0;
SH_Dec_R = 0;
MD_Dec_R = 0;
BS_Dec_R = 0;
FS_Dec_R = 0;

   // Execution stage
 RW_EX_R = 0;
 DA_EX_R = 0;
 MD_EX_R = 0;
 ALU_EX_R = 0;
 Datamem_EX_R = 0;
end
// Register Assignment
always @(posedge clk)

begin
if((DHS_Out == 0) && (!(BS_Dec[0] || BS_Dec[1]))) // basic N
begin

// Initial stage
PC_R = MuxC_Out;

// Instruction fetch
Pc1_IF_R = Pc_pc1_Fetch;
IR_IF_R = Inst_Fetch;

 // Decode stage
PC2_Dec_R = PC1_Dec;
busA_Dec_R = busA_Dec;
busB_Dec_R = busB_Dec;
RW_Dec_R = RW_Dec;
PS_Dec_R = PS_Dec;
MW_Dec_R = MW_Dec;
DA_Dec_R = DA_Dec;
SH_Dec_R = SH_Dec;
MD_Dec_R = MD_Dec;
BS_Dec_R = BS_Dec;
FS_Dec_R = FS_Dec;

 // Execution stage
  RW_EX_R = RW_EX;
  DA_EX_R = DA_EX;
  MD_EX_R = MD_EX;
  ALU_EX_R = ALU_FS_EX;
  Datamem_EX_R = Datamem_EX;
 
end

else if((DHS_Out == 1) && (!(BS_Dec[0] || BS_Dec[1]))) // DHS

begin

  PC_R   = PC_R;
 
    // Instruction Fetch
  Pc1_IF_R = Pc1_IF_R;
  IR_IF_R = IR_IF_R;
 
       // Decode stage
   PC2_Dec_R = PC2_Dec_R;
  busA_Dec_R = busA_Dec;
  busB_Dec_R = busB_Dec;
  RW_Dec_R = RW_Dec && DHS_Not_W;
  DA_Dec_R = DA_Dec && DHS_Not_W;
  MD_Dec_R = MD_Dec;
  BS_Dec_R = BS_Dec && DHS_Not_W;
  PS_Dec_R = PS_Dec;
  MW_Dec_R = MW_Dec && DHS_Not_W;
  FS_Dec_R = FS_Dec;
  SH_Dec_R = SH_Dec;
 
     // Execution Stage
  RW_EX_R = RW_EX;
  DA_EX_R = DA_EX;
  MD_EX_R = MD_EX;
  ALU_EX_R = ALU_FS_EX;
  Datamem_EX_R = Datamem_EX;
 end 

else if ((DHS_Out == 0) && (BS_Dec[0] || BS_Dec[1])) // branch detection
begin

 // Initial stage
 PC_R = MuxC_Out;

 // Instruction fetch
 Pc1_IF_R = Pc_pc1_Fetch;
 IR_IF_R = Branch_Fetch;

     // Decode stage
 PC2_Dec_R = PC1_Dec;
 busA_Dec_R = busA_Dec;
 busB_Dec_R = busB_Dec;
RW_Dec_R = RW_Dec && BS_Invert_wire;
 DA_Dec_R = DA_Dec;
 MD_Dec_R = MD_Dec;
BS_Dec_R = BS_Dec && BS_Invert_wire;
 PS_Dec_R = PS_Dec;
 MW_Dec_R = MW_Dec && BS_Invert_wire;
 FS_Dec_R = FS_Dec;
 SH_Dec_R = SH_Dec;

    // Execution Stage
  RW_EX_R = RW_EX;
  DA_EX_R = DA_EX;
  MD_EX_R = MD_EX;
  ALU_EX_R = ALU_FS_EX;
  Datamem_EX_R = Datamem_EX;

end

end
always@(*)
begin
    PC<=PC_R;
    IR<=Inst_Fetch;
    A<=busA_Dec_R;
    B<=busB_Dec_R;
    F<=ALU_EX_R;
    Out<=Datamem_EX;
end
endmodule

