module HazardUnit( input logic RegWriteW, BranchD,
                input logic [4:0] WriteRegW, WriteRegE,
                input logic RegWriteM,MemToRegM,
                input logic [4:0] WriteRegM,
                input logic RegWriteE,MemToRegE,
                input logic [4:0] rsE,rtE,rdE,
                input logic [4:0] rsD,rtD,
                output logic [1:0] ForwardAE,ForwardBE,ForwardCE,
                output logic FlushE,StallD,StallF,ForwardAD, ForwardBD
                 ); // Add or remove input-outputs if necessary
       
	// ********************************************************************
	// Here, write equations for the Hazard Logic.
	// If you have troubles, please study pages ~420-430 in your book.
	// ********************************************************************
  
	
logic lwstall;
        logic branchStall;
        
        always_comb
            begin
            
            if ((rsE != 0) & (rsE == WriteRegM) & RegWriteM)
                ForwardAE = 2'b10;
            else if ((rsE != 0) & (rsE == WriteRegW) & RegWriteW)
                ForwardAE = 2'b01;
            else
                ForwardAE = 2'b00;
            
            if ((rtE != 0) & (rtE == WriteRegM) & RegWriteM)
                ForwardBE = 2'b10;
            else if ((rtE != 0) & (rtE == WriteRegW) & RegWriteW)
                ForwardBE = 2'b01;
            else
                ForwardBE = 2'b00;
                
             if ((rdE != 0) & (rdE == WriteRegM) & RegWriteM)
                  ForwardCE = 2'b10;
              else if ((rdE != 0) & (rdE == WriteRegW) & RegWriteW)
                  ForwardCE = 2'b01;
               else
                  ForwardCE = 2'b00; 
            
            if ((rsD != 0) & (rsD == WriteRegM) & RegWriteM) 
                assign ForwardAD = 1;
            else
                 assign ForwardAD = 0;
            if ((rtD != 0) & (rtD == WriteRegM) & RegWriteM) 
                assign ForwardBD = 1;
            else 
                assign ForwardBD = 0;
            
            if (((rsD == rtE) | (rtD == rtE)) & MemToRegE) 
                assign lwstall = 1;
            else 
                assign lwstall = 0;   
            
            if ((BranchD & RegWriteE & ((WriteRegE == rsD) | WriteRegE == rtD))
                            | (BranchD & MemToRegM & ((WriteRegM == rsD) | (WriteRegM == rtD)))) 
                  assign branchStall = 1;
            else 
                  assign branchStall = 0;
            
            if (lwstall | branchStall) 
                begin
                    StallF = 1;
                    StallD = 1;
                    FlushE = 1;
                end
            else 
                begin
                    StallF = 0;
                    StallD = 0;
                    FlushE = 0;
                end
            end
    endmodule

