`include "fetch_cycle.v"
`include "decode_cycle.v"
`include "execute_cycle.v"
`include "memory_cycle.v"
`include "writeback_cycle.v"

module pipeline_top (clk, rst);
    input clk, rst; 

    wire PCSrcE, RegWriteW, RegWriteE, RegWriteM, RegWriteW, RegWriteW_W, ALUSrcE, MemWriteE, MemWriteM, ResultSrcE, ResultSrcW, ResultSrcM, BranchE;
    wire [1:0] ALUControlE;
    wire [4:0] RDW, RD_E, RD_M, RD_W, RD_W_W,  RS1_E, RS2_E;
    wire [31:0] PCTargetE, InstrD, PCD, PCPlus4D, PCPlus4M, PCPlus4E, ResultW, RD1_E, RD2_E, Imm_Ext_E, PCE;
    wire [31:0] ALUResultM, WriteDataM, PCPlus4W, ReadDataW, ALUResultW;

    fetch_cycle fetch(
        .clk(clk), 
        .rst(rst), 
        .PCSrcE(PCSrcE), 
        .PCTargetE(PCTargetE), 
        .InstrD(InstrD), 
        .PCD(PCD), 
        .PCPlus4D(PCPlus4D)
    );

    decode_cycle decode(
        .clk(clk), 
        .rst(rst),  
        .InstrD(InstrD), 
        .PCD(PCD), 
        .PCPlus4D(PCPlus4D), 
        .RegWriteW(RegWriteW), 
        .RDW(RDW), 
        .ResultW(ResultW), 
        .RegWriteE(RegWriteE), 
        .ALUSrcE(ALUSrcE), 
        .MemWriteE(MemWriteE), 
        .ResultSrcE(ResultSrcE), 
        .BranchE(BranchE), 
        .ALUControlE(ALUControlE), 
        .RD1_E(RD1_E), 
        .RD2_E(RD2_E), 
        .Imm_Ext_E(Imm_Ext_E), 
        .RD_E(RD_E), 
        .PCE(PCE), 
        .PCPlus4E(PCPlus4E), 
        .RS1_E(RS1_E), 
        .RS2_E(RS2_E)
    );

    execute_cycle execute(
        .clk(clk),
        .rst(rst),
        .RegWriteE(RegWriteE), 
        .ALUSrcE(ALUSrcE), 
        .MemWriteE(MemWriteE), 
        .ResultSrcE(ResultSrcE), 
        .BranchE(BranchE), 
        .ALUControlE(ALUControlE), 
        .RD1_E(RD1_E), 
        .RD2_E(RD2_E), 
        .Imm_Ext_E(Imm_Ext_E), 
        .RD_E(RD_E), 
        .PCE(PCE), 
        .PCPlus4E(PCPlus4E),
        .ALUResultM(ALUResultM), 
        .WriteDataM(WriteDataM), 
        .PCTargetE(PCTargetE), 
        .PCPlus4M(PCPlus4M),
        .RD_M(RD_M),
        .RegWriteM(RegWriteM), 
        .MemWriteM(MemWriteM), 
        .PCSrcE(PCSrcE),
        .ResultSrcM(ResultSrcM)
    );

    memory_cycle memory(
        .clk(clk), 
        .rst(rst), 
        .RegWriteM(RegWriteM), 
        .ResultSrcM(ResultSrcM), 
        .MemWriteM(MemWriteM), 
        .ALUResultM(ALUResultM), 
        .WriteDataM(WriteDataM), 
        .RD_M(RD_M), 
        .PCPlus4M(PCPlus4M),
        .RegWriteW(RegWriteW), 
        .ResultSrcW(ResultSrcW), 
        .ALUResultW(ALUResultW), 
        .ReadDataW(ReadDataW), 
        .RD_W(RD_W), 
        .PCPlus4W(PCPlus4W)
    );

    writeback_cycle writeback(
        .clk(clkWriteDataM), 
        .rst(rst), 
        .RegWriteW(RegWriteW), 
        .ResultSrcW(ResultSrcW), 
        .ALUResultW(ALUResultW), 
        .ReadDataW(ReadDataW), 
        .RD_W(RD_W),
        .RD_W_W(RD_W_W),
        .ResultW(ResultW), 
        .RegWriteW_W(RegWriteW_W)
    );

endmodule //pipeline_top