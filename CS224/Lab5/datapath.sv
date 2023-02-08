module datapath (input  logic clk, reset,
                input  logic[2:0]  ALUControlD,
                input logic RegWriteD, MemToRegD, MemWriteD, ALUSrcD, RegDstD, BranchD,
                 output logic [31:0] instrF,	
                 output logic [31:0] PC,	
                 output logic [31:0] instrD,  PCF,
                output logic PcSrcD,                 
                output logic [31:0] ALUOutE, WriteDataE,
                output logic [1:0] ForwardAE, ForwardBE,ForwardCE,
                 output logic ForwardAD, ForwardBD,output logic EqualID); // Add or remove input-outputs if necessary

	// ********************************************************************
	// Here, define the wires that are needed inside this pipelined datapath module
	// ********************************************************************
  
  	//* We have defined a few wires for you
    logic [31:0] PcSrcA, PcSrcB,PcBranchD,PcPlus4D, PcPlus4F;	
  	logic StallD, StallF;

	logic RegWriteE, MemToRegE, MemWriteE, ALUSrcE,RegDstE;
	logic RegWriteM, MemToRegM, MemWriteM;
	logic RegWriteW, MemToRegW;

    logic [4:0] WriteRegE, WriteRegM,WriteRegW;

	logic [2:0] ALUControlE;	

	logic [15:0] SignExtend;
	logic [31:0] RD1D, RD2D, WD3D, SignImmD, SignImmShifted, RD3D;
	logic [31:0] RsData, RtData, RD3E,WD3E, SignImmE;
    logic [31:0] EqualRd1,EqualRd2,adebug,bdebug,cdebug, ALUOutMS,ALUOutMM;

    logic [31:0] SrcAE, SrcBE,SrcCE, ReadDataM, ReadDataW, ALUOutM, ALUOutW, WriteDataM,ResultW;

    logic FlushE,srac;

    logic [4:0] RsD,RtD,RdD,RsE,RtE,RdE;

    logic zero;
    
    logic [31:0] PcDebug;
	

    
  	// Instantiate PipeWtoF
  	PipeWtoF pipe1(PC,
                ~StallF, clk, reset,
                PCF);
                
                 assign PcPlus4F = PCF + 4;
                  assign PcSrcB = PcBranchD;
                   assign PcSrcA = PcPlus4F;
                    mux2 #(32) pc_mux(PcSrcA, PcSrcB, PcSrcD, PC);
               
                   imem im1(PCF[7:0], instrF);
                   
                   assign PcDebug = PC;
  
  	// Do some operations
    
  	// Instantiate PipeFtoD
    PipeFtoD pipe2(instrF,PcPlus4F,~StallD,PcSrcD,clk,reset,instrD,PcPlus4D);


    signext signext(instrD[15:0],SignImmD);

    sl2 sl2(SignImmD,SignImmShifted);

    adder adder(SignImmShifted,PcPlus4D,PcBranchD);

    assign RsD = instrD[25:21];
    assign RtD = instrD[20:16];
    assign RdD = instrD[15:11];

    regfile RF(clk,reset,RegWriteW,RsD,RtD,WriteRegW,ResultW,RD1D,RD2D,RD3D);
    mux2 rd1Mux(RD1D,ALUOutM,ForwardAD,EqualRd1);
    mux2 rd2Mux(RD2D,ALUOutM,ForwardBD,EqualRd2);

    assign EqualID = EqualRd1 == EqualRd2;
    assign PcSrcD = BranchD && EqualID;
    
  	// Instantiate PipeDtoE
    PipeDtoE pipe3(RD1D,RD2D,RD3D,SignImmD,
    RsD,RtD,RdD,
    RegWriteD, MemToRegD,MemWriteD,ALUSrcD,RegDstD
    ,ALUControlD,
    FlushE,clk,reset,
    RsData,RtData,RD3E,SignImmE,
    RsE,RtE,RdE,
    RegWriteE,MemToRegE, MemWriteE,ALUSrcE,RegDstE,
    ALUControlE);
    
    
    mux2 #(5) RegDst(RtE,RdE,RegDstE,WriteRegE);

    mux4 #(32)forwardA(RsData,ResultW,ALUOutM,0,ForwardAE,SrcAE);

    mux4 #(32)forwardB(RtData,ResultW,ALUOutM,0,ForwardBE,WriteDataE);
    
    assign SrcCE = RD3E;
    
    assign adebug = SrcAE;
    assign bdebug = SrcBE;
    assign cdebug = SrcCE;
    
    mux2 immMux(WriteDataE,SignImmE,ALUSrcE,SrcBE);

    alu ALU(SrcAE,SrcBE,ALUControlE,ALUOutE,zero);
    

  	// Instantiate PipeEtoM

    PipeEtoM pipe4(clk,reset,ALUOutE,WriteDataE,WriteRegE,RegWriteE,MemToRegE,MemWriteE,
    RegWriteM,MemToRegM,MemWriteM,WriteDataM,ALUOutMM,WriteRegM);

    dmem MEM(clk,MemWriteM,ALUOutM,WriteDataM,ReadDataM);
    
    assign srac = (ALUControlD == 100);
    adder sraacAdder(ALUOutMM,RD3D,ALUOutMS);
    mux2 sracmux(ALUOutMS,ALUOutMM,srac,ALUOutM);

  	// Instantiate PipeMtoW
    PipeMtoW pipe5(clk,reset,RegWriteM,MemToRegM,ReadDataM,ALUOutM,WriteRegM,
    RegWriteW,MemToRegW,ReadDataW,ALUOutW,WriteRegW);

    mux2 memtoreg(ALUOutW,ReadDataW,MemToRegW,ResultW);
    
    
  	// Do some operations

    HazardUnit hazard(RegWriteW,BranchD,
    WriteRegW,WriteRegE,
    RegWriteM,MemToRegM,
    WriteRegM,
    RegWriteE,MemToRegE,
    RsE,RtE,RdE,
    RsD,RtD,
    ForwardAE,ForwardBE,ForwardCE,
    FlushE,StallD,StallF,
    ForwardAD,ForwardBD);
    
 
endmodule