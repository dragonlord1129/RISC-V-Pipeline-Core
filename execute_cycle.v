`include "alu.v"
`include "mux.v"
`include "pc_adder.v"

module execute_cycle(
    input clk, rst,
    input [31:0] RD1_E, RD2_E, RD_E, PCE, PCPlus4E, Imm_Ext_E,
    input RegWriteE, ALUSrcE, MemWriteE, BranchE, JumpE,
    input [1:0] ResultSrcE,
    input [2:0] ALUControlE,
    input [4:0] RS1_E, RS2_E,
    input [1:0] ForwardAE, ForwardBE,
    input [31:0] ResultW, ALUResultM,

    output [31:0] ALUResultM, WriteDataM, PCTargetE, PCPlus4M,
    output [4:0] RD_M,
    output RegWriteM, MemWriteM, PCSrcE,
    output [1:0] ResultSrcM,
    output [4:0] RS1_E_H, RS2_E_H
);

    // Intermediate registers
    reg [31:0] ALUResultE_R, WriteDataE_R, PCPlus4E_R;
    reg [4:0] RD_E_R;
    reg RegWriteE_R, MemWriteE_R;
    reg [1:0] ResultSrcE_R;

    // Intermediate wires
    wire [31:0] SrcAE, SrcBE, WriteDataE, ResultE, SrcBE_M;
    wire ZeroE;

    mux_3_by_1 SrcAEMux(
        .a(RD1_E),
        .b(ResultW),
        .c(ALUResultM),
        .s(ForwardAE),
        .d(SrcAE)
    );
    mux_3_by_1 SrcBEMux(
        .a(RD2_E),
        .b(ResultW),
        .c(ALUResultM),
        .s(ForwardBE),
        .d(SrcBE_M)
     );
    // Multiplexer to select ALU B input
    mux mux_1(
        .a(SrcBE_M),
        .b(Imm_Ext_E),
        .s(ALUSrcE),
        .c(SrcBE)
    );

    // ALU for computation
    alu alu(
        .A(SrcAE),
        .B(SrcBE),
        .result(ResultE),
        .ALUControl(ALUControlE),
        .overflow(),
        .carry(),
        .zero(ZeroE),
        .negative()
    );

    // PC adder for branch target
    pc_adder pc_adder(
        .a(PCE),
        .b(Imm_Ext_E),
        .c(PCTargetE)
    );

    // Sequential logic to register outputs
    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
            ALUResultE_R <= 32'd0;
            WriteDataE_R <= 32'd0;
            RegWriteE_R <= 1'b0;
            MemWriteE_R <= 1'b0;
            ResultSrcE_R <= 2'b00;
            PCPlus4E_R <= 32'd0;
            RD_E_R <= 5'd0;
        end else begin
            ALUResultE_R <= ResultE;
            WriteDataE_R <= SrcBE_M;
            RegWriteE_R <= RegWriteE;
            MemWriteE_R <= MemWriteE;
            ResultSrcE_R <= ResultSrcE;
            PCPlus4E_R <= PCPlus4E;
            RD_E_R <= RD_E;
        end
    end

    // Combinational logic for other outputs

    assign WriteDataE = RD2_E;
    assign PCSrcE = (ZeroE & BranchE) | JumpE;

    assign RD_M = RD_E_R;
    assign RegWriteM = RegWriteE_R;
    assign ResultSrcM = ResultSrcE_R;
    assign ALUResultM = ALUResultE_R;
    assign PCPlus4M = PCPlus4E_R;
    assign MemWriteM = MemWriteE_R;
    assign WriteDataM = WriteDataE_R;
    assign RS1_E_H = RS1_E;
    assign RS2_E_H = RS2_E;
endmodule
