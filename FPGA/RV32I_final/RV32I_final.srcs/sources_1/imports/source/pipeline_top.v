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


module pipeline_top (clk, rst, next, Result);
    input clk, rst, next;
    output [3:0] Result;

    // Internal wire declarations
    wire PCSrcE, RegWriteW, RegWriteE, RegWriteM, ALUSrcE, MemWriteE, MemWriteM, BranchE, JumpE;
    wire [1:0] ResultSrcE, ResultSrcW, ResultSrcM, ForwardAE, ForwardBE;
    wire [2:0] ALUControlE;
    wire [4:0] RDW, RD_E, RD_M, RD_W, RS1_E, RS2_E, RS1_E_H, RS2_E_H, RD_W_W;
    wire [31:0] PCTargetE, InstrD, PCD, PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W, ResultW, RD1_E, RD2_E, Imm_Ext_E, PCE;
    wire [31:0] ALUResultM, ALUResultM_E, ALUResultW, WriteDataM, ReadDataW;

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
        .RDW(RD_W), 
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
        .RS2_E(RS2_E),
        .PCPlus4E(PCPlus4E),
        .JumpE(JumpE)
    );

    execute_cycle execute (
        .clk(clk), 
        .rst(rst), 
        .ALUSrcE(ALUSrcE), 
        .MemWriteE(MemWriteE), 
        .MemWriteM(MemWriteM),
        .RegWriteE(RegWriteE),
        .RegWriteM(RegWriteM),
        .BranchE(BranchE), 
        .JumpE(JumpE),
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
        .ALUResultM_E(ALUResultM), 
        .WriteDataM(WriteDataM),
        .PCE(PCE),
        .PCPlus4E(PCPlus4E),
        .PCPlus4M(PCPlus4M),
        .ResultSrcE(ResultSrcE),
        .ResultSrcM(ResultSrcM),
        .ResultW(ResultW),
        .RS1_E_H(RS1_E_H),
        .RS2_E_H(RS2_E_H)
    );

    memory_cycle memory (
        .clk(clk), 
        .rst(rst), 
        .MemWriteM(MemWriteM), 
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .ResultSrcM(ResultSrcM),
        .ResultSrcW(ResultSrcW),
        .ALUResultM(ALUResultM),
        .ALUResultW(ALUResultW),
        .WriteDataM(WriteDataM), 
        .ReadDataW(ReadDataW),
        .RD_M(RD_M),
        .RD_W(RD_W),
        .PCPlus4M(PCPlus4M),
        .PCPlus4W(PCPlus4W)
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
        .ResultSrcW(ResultSrcW)
    );

    hazard_unit hazard (
        .rst(rst),
        .RS1_E(RS1_E_H), 
        .RS2_E(RS2_E_H), 
        .ForwardAE(ForwardAE), 
        .ForwardBE(ForwardBE), 
        .RD_M(RD_M), 
        .RegWriteW(RegWriteW),
        .RegWriteM(RegWriteM),
        .RD_W(RD_W)
    );
    wire [31:0] done;
    assign done = (rst) ? ResultW[31:0] : 32'd0;
    reg flag;
    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) flag <= 1'b0;
        else if(rst == 1'b1 && done == 32'd8) flag = 1'b1;
    end
    
assign Result = ((flag) & (next)) ? 4'd15:
                ((flag) & (~next))? (4'd8 & ResultW[3:0]) : 4'd0;
endmodule // pipeline_top
