`include "fetch_cycle.v"
`include "decode_cycle.v"
`include "execute_cycle.v"
`include "memory_cycle.v"
`include "writeback_cycle.v"
`include "hazard_unit.v"

`include "control_unit.v"
`include "registerFile.v"
`include "sign_extend.v"
`include "alu_decoder.v"
`include "main_decoder.v"
`include "alu.v"
`include "mux.v"
`include "pc_adder.v"
`include "data_memory.v"
`include "PC.v"
`include "instruction_memory.v"

module pipeline_top (clk, rst);
    input clk, rst;

    // Internal wire declarations
    wire PCSrcE, RegWriteW, RegWriteE, RegWriteM, ALUSrcE, MemWriteE, MemWriteM, BranchE;
    wire [1:0] ResultSrcE, ResultSrcW, ForwardAE, ForwardBE;
    wire [2:0] ALUControlE;
    wire [4:0] RDW, RD_E, RD_M, RD_W, RS1_E, RS2_E, RD_W_W;
    wire [31:0] PCTargetE, InstrD, PCD, PCPlus4D, PCPlus4W, ResultW, RD1_E, RD2_E, Imm_Ext_E, PCE;
    wire [31:0] ALUResultM, ALUResultW, WriteDataM, ReadDataW;

    // Instantiate pipeline stages
    fetch_cycle fetch (
        .clk(clk), 
        .rst(rst), 
        .PCSrcE(PCSrcE), 
        .PCTargetE(PCTargetE), 
        .InstrD(InstrD), 
        .PCD(PCD), 
        .PCPlus4D(PCPlus4D)
    );

    decode_cycle decode (
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
        .RS1_E(RS1_E), 
        .RS2_E(RS2_E)
    );

    execute_cycle execute (
        .clk(clk), 
        .rst(rst), 
        .ALUSrcE(ALUSrcE), 
        .MemWriteE(MemWriteE), 
        .RegWriteE(RegWriteE),
        .RegWriteM(RegWriteM),
        .BranchE(BranchE), 
        .ALUControlE(ALUControlE), 
        .RD1_E(RD1_E), 
        .RD2_E(RD2_E), 
        .RD_M(RD_M),
        .Imm_Ext_E(Imm_Ext_E), 
        .RD_E(RD_E), 
        .RS1_E(RS1_E), 
        .RS2_E(RS2_E),
        .ForwardAE(ForwardAE), 
        .ForwardBE(ForwardBE), 
        .PCTargetE(PCTargetE), 
        .PCSrcE(PCSrcE),
        .ALUResultM(ALUResultM), 
        .WriteDataM(WriteDataM)
    );

    memory_cycle memory (
        .clk(clk), 
        .rst(rst), 
        .MemWriteM(MemWriteM), 
        .RegWriteM(RegWriteM),
        .ALUResultM(ALUResultM), 
        .WriteDataM(WriteDataM), 
        .ReadDataW(ReadDataW),
        .RD_M(RD_M)
    );

    writeback_cycle writeback (
        .clk(clk), 
        .rst(rst), 
        .ReadDataW(ReadDataW), 
        .ResultW(ResultW), 
        .RegWriteW(RegWriteW),
        .ALUResultW(ALUResultW),
        .PCPlus4W(PCPlus4W),
        .RD_W(RD_W),
        .ResultSrcW(ResultSrcW),
        .RegWriteW_W(RegWriteW_W),
        .RD_W_W(RD_W_W)
    );

    hazard_unit hazard (
        .rst(rst),
        .RS1_E(RS1_E), 
        .RS2_E(RS2_E), 
        .ForwardAE(ForwardAE), 
        .ForwardBE(ForwardBE), 
        .RD_M(RD_M), 
        .RegWriteM(RegWriteM),
        .RD_W_W(RD_W_W)
    );

endmodule // pipeline_top
