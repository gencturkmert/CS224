module PipeMtoW(
    input logic clk, reset,
    input logic RegWriteM, MemToRegM,
    input logic [31:0] ReadDataM,
    input logic [31:0] ALUOutM,
    input logic [4:0] WriteRegM,
    output logic RegWriteW, MemToRegW,
    output logic [31:0] ReadDataW,
    output logic [31:0] ALUOutW,
    output logic [4:0] WriteRegW
);

always_ff @(posedge clk, posedge reset) 
begin
		
        if(reset)
            begin
                 RegWriteW <= 0;
                 MemToRegW <= 0;
                 ReadDataW <= 0;
                 ALUOutW <= 0;
                 WriteRegW <= 0;
            end
        else
            begin
                 RegWriteW <= RegWriteM;
                 MemToRegW <= MemToRegM;
                 ReadDataW <= ReadDataM;
                 ALUOutW <= ALUOutM;
                 WriteRegW <= WriteRegW;    
            end
end


endmodule