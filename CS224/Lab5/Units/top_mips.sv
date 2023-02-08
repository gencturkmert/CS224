module top_mips (input  logic        clk, reset,
             output  logic[31:0]  instrF,
             output logic[31:0] PC, PCF,
             output logic PcSrcD,
             output logic MemWriteD, MemToRegD, ALUSrcD, BranchD, RegDstD, RegWriteD,
             output logic [2:0]  alucontrol,
             output logic [31:0] instrD, 
             output logic [31:0] ALUOutE, WriteDataE,
             output logic [1:0] ForwardAE, ForwardBE,
                 output logic ForwardAD, ForwardBD,output logic [7:0] controls,output logic EqualID, output logic [5:0] op, funct, opDebug
                 , output logic [5:0] opDebugController);


	// ********************************************************************
	// Below, instantiate a controller and a datapath with their new (if modified) signatures
	// and corresponding connections.
	// ********************************************************************
  
   Controller control(op,funct,
   MemToRegD,MemWriteD,
   ALUSrcD
   ,RegDstD,RegWriteD,
   alucontrol,
   BranchD,
   controls, opDebug,opDebugController);
   
    datapath data(clk,reset,alucontrol,
    RegWriteD,MemToRegD, MemWriteD, ALUSrcD, RegDstD, BranchD,
    instrF,PC,instrD , PCF,PcSrcD,
    ALUOutE,WriteDataE,ForwardAE,ForwardBE,ForwardAD,ForwardBD,
    EqualID);
    
    assign op = instrD[31:26];
    assign funct = instrD[5:0];
    
    
   
  
endmodule