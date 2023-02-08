module imem ( input logic [7:0] addr, output logic [31:0] instr);

// imem is modeled as a lookup table, a stored-program byte-addressable ROM
	always_comb
	   case (addr)		   	// word-aligned fetch
//
// 	***************************************************************************
//	Here, you can paste your own test cases that you prepared for the part 1-e.
//  An example test program is given below.        
//	***************************************************************************
//
//		address		instruction
//		-------		-----------
//	     8'h00: instr = 32'h20080007;
//       8'h04: instr = 32'h20090005;
//       8'h08: instr = 32'h200a0000;
//       8'h0c: instr = 32'h210b000f;
//       8'h10: instr = 32'h01095020;
//       8'h14: instr = 32'h01095025;
//       8'h18: instr = 32'h01095024;
//       8'h1c: instr = 32'h01095022;
//       8'h20: instr = 32'h0109502a;
//       8'h24: instr = 32'had280002;
//       8'h28: instr = 32'h8d090000;
//       8'h2c: instr = 32'h1100fff5;
//       8'h30: instr = 32'h200a000a;
//       8'h34: instr = 32'h2009000c;
        8'h00: instr = 32'h20080010; //addi $t0, $zero, 0x0010
		8'h04: instr = 32'h20090015; //addi $t1, $zero, 0x0015
		8'h08: instr = 32'h200A0012; //addi $t2, $zero, 0x0012
		8'h0c: instr = 32'h200B0010; //addi $t3, $zero, 0x0010 
		8'h10: instr = 32'h200C0018; //addi $t4, $zero, 0x0018
		8'h14: instr = 32'h21100007; //addi $s0, $t0, 0x0007
		8'h18: instr = 32'hAC080004; //sw $t0, 0x0004($zero)
		8'h1c: instr = 32'h01098820; //add $s1, $t0, $t1
		8'h20: instr = 32'h01495025; //or $t2, $t2, $t1
		8'h24: instr = 32'h0100A82A; //slt $s5, $t0, $zero
		8'h28: instr = 32'h016CB024; //and $s6, $t3, $t4
		8'h2c: instr = 32'h01284822; //sub $t1, $t1, $t0
		8'h30: instr = 32'h8C1F0004; //lw $ra, 0x0004($zero)
		8'h34: instr = 32'h110BFFFB; //beq $t2, $s0, 0xFFFB
       default:  instr = {32{1'bx}};	// unknown address
	   endcase
endmodule