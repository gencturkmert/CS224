module Controller(input  logic[5:0] op, funct,
                  output logic     memtoreg, memwrite,
                  output logic     alusrc,
                  output logic     regdst, regwrite,
                  output logic[2:0] alucontrol,
                  output logic branch
                  ,output logic [7:0] controls,output logic [5:0] opDebug, output logic [5:0] opDebugController);

   logic [1:0] aluop;
   assign opDebugController = op;
  maindec md (op, memtoreg, memwrite, branch, alusrc, regdst, regwrite, aluop,controls, opDebug);

   aludec  ad (funct, aluop, alucontrol);

endmodule