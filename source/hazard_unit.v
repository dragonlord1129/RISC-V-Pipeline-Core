module hazard_unit (
    rst, RS1_E, RS2_E, ForwardAE, ForwardBE, RD_M, RegWriteW, RegWriteM, RD_W);

    input rst, RegWriteW, RegWriteM;
    input [4:0] RS1_E, RS2_E, RD_M, RD_W;
    
    output [1:0] ForwardAE, ForwardBE;

    assign ForwardAE = (rst == 1'b0) ? 2'b00 : 
                       ((RegWriteM == 1'b1) & (RD_M != 5'h00) & (RD_M == RS1_E)) ? 2'b10 :
                       ((RegWriteW == 1'b1) & (RD_W != 5'h00) & (RD_W == RS1_E)) ? 2'b01 : 2'b00;
                       
    assign ForwardBE = (rst == 1'b0) ? 2'b00 : 
                       ((RegWriteM == 1'b1) & (RD_M != 5'h00) & (RD_M == RS2_E)) ? 2'b10 :
                       ((RegWriteW == 1'b1) & (RD_W != 5'h00) & (RD_W == RS2_E)) ? 2'b01 : 2'b00;               


endmodule //hazard_unit