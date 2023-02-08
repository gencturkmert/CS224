module maindec (input logic[5:0] op, 
	              output logic memtoreg, memwrite, branch,
	              output logic alusrc, regdst, regwrite,
	              output logic[1:0] aluop ,output logic [7:0]controls, output logic [5:0] opDebug);
  

   assign {regwrite, regdst, alusrc, branch, memwrite,
                memtoreg,  aluop} = controls;
  assign opDebug = op;
  always_comb
    case(op)
      6'b000000: controls <= 8'b11000010; // R-type
      6'b100011: controls <= 8'b10100100; // LW
      6'b101011: controls <= 8'b00101000; // SW
      6'b000100: controls <= 8'b00010001; // BEQ
      6'b001000: controls <= 8'b10100000; // ADDI
      default:   controls <= 8'bxxxxxxxx; // illegal op
    endcase
endmodule