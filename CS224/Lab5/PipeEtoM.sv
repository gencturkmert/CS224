module PipeEtoM(
    input logic clk,reset,
    input logic [31:0] ALUOutE,
    input logic [31:0] WriteDataE,
    input logic [4:0] WriteRegE,
    input logic RegWriteE, MemToRegE, MemWriteE,
    output logic RegWriteM, MemWriteM, MemToRegM,
    output logic [31:0] WriteDataM,
    output logic [31:0] ALUOutM,
    output logic [4:0] WriteRegM
);

    always_ff @(posedge clk, posedge reset) 
    begin
        if(reset) 
        begin
             RegWriteM <= 0;
             MemToRegM <= 0;
             MemWriteM <= 0;
             WriteDataM <= 0;
             ALUOutM <= 0;
             WriteRegM <= 0;
        end

        else
        begin
             RegWriteM <= RegWriteE;
             MemToRegM <= MemToRegE;
             MemWriteM <= MemWriteE;
             WriteDataM <= WriteDataE;
             ALUOutM <= ALUOutE;
             WriteRegM <= WriteRegE;
        end
    end

endmodule