`include "control_unit.v"
`include "registerFile.v"
`include "sign_extend.v"
module decode_cycle (clk, rst,  InstrD, PCD, PCPlus4D, RegWriteW, RDW, ResultW,  RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE,  ALUControlE, RD1_E, RD2_E, Imm_Ext_E, RD_E, PCE, PCPlus4E, RS1_E, RS2_E);

    input clk, rst;
    input [4:0] RDW;
    input [31:0] InstrD, PCD, PCPlus4D, ResultW;
    input RegWriteW;

    output RegWriteE,ALUSrcE,MemWriteE,ResultSrcE,BranchE;
    output [2:0] ALUControlE;
    output [31:0] RD1_E, RD2_E, Imm_Ext_E;
    output [4:0] RS1_E, RS2_E, RD_E;
    output [31:0] PCE, PCPlus4E;

    wire RegWriteD, ALUSrcD, MemWriteD, ResultSrcD, BranchD;
    wire [1:0] ImmSrcD;
    wire [2:0] ALUControlD;
    wire [31:0] readData1_D, readData2_D, Imm_Ext_D;

    reg RegWriteD_R, ALUSrcD_R, MemWriteD_R, BranchD_R, ResultSrcD_R;
    reg [2:0] ALUControlD_R;
    reg [31:0] readData1_D_R, readData2_D_R, Imm_Ext_D_R;
    reg [4:0] RD_D_R, RS1_D_R, RS2_D_R;
    reg [31:0] PCD_R, PCPlus4D_R;


    control_unit control_unit( 
        .opcode(InstrD[6:0]),
        .RegWrite(RegWriteD),
        .ImmSrc(ImmSrcD),
        .ALUSrc(ALUSrcD),
        .MemWrite(MemWriteD),
        .ResultSrc(ResultSrcD),
        .Branch(BranchD),
        .funct3(InstrD[14:12]),
        .funct7(InstrD[31:25]),
        .ALUControl(ALUControlD)
    );
    registerFile registerFile(
        .clk(clk),
        .rst(rst),
        .writeEnable(RegWriteW), //WE#
        .rs1(InstrD[19:15]), //A1
        .rs2(InstrD[24:20]), //A2
        .rd(RDW), //a#
        .writeData(ResultW), //WD3
        .readData1(readData1_D), //RD1
        .readData2(readData2_D) //RD2
    );
    sign_extend sign_extend(
        .In(InstrD),
        .ImmSrc(ImmSrcD),
        .Imm_Ext(Imm_Ext_D)
    );

    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            RegWriteD_R <= 1'b0;
            ALUSrcD_R <= 1'b0;
            MemWriteD_R <= 1'b0;
            ResultSrcD_R <= 1'b0;
            BranchD_R <= 1'b0;
            ALUControlD_R <= 3'b000;
            readData1_D_R <= 32'h00000000; 
            readData2_D_R <= 32'h00000000; 
            Imm_Ext_D_R <= 32'h00000000;
            RD_D_R <= 5'h00;
            PCD_R <= 32'h00000000; 
            PCPlus4D_R <= 32'h00000000;
            RS1_D_R <= 5'h00;
            RS2_D_R <= 5'h00;
        end
        else begin
            RegWriteD_R <= RegWriteD;
            ALUSrcD_R <= ALUSrcD;
            MemWriteD_R <= MemWriteD;
            ResultSrcD_R <= ResultSrcD;
            BranchD_R <= BranchD;
            ALUControlD_R <= ALUControlD;
            RD1_D_R <= RD1_D; 
            RD2_D_R <= RD2_D; 
            Imm_Ext_D_R <= Imm_Ext_D;
            RD_D_R <= InstrD[11:7];
            PCD_R <= PCD; 
            PCPlus4D_R <= PCPlus4D;
            RS1_D_R <= InstrD[19:15];
            RS2_D_R <= InstrD[24:20];
        end
    end

    // Output asssign statements
    assign RegWriteE = RegWriteD_R;
    assign ALUSrcE = ALUSrcD_R;
    assign MemWriteE = MemWriteD_R;
    assign ResultSrcE = ResultSrcD_R;
    assign BranchE = BranchD_R;
    assign ALUControlE = ALUControlD_R;
    assign RD1_E = RD1_D_R;
    assign RD2_E = RD2_D_R;
    assign Imm_Ext_E = Imm_Ext_D_R;
    assign RD_E = RD_D_R;
    assign PCE = PCD_R;
    assign PCPlus4E = PCPlus4D_R;
    assign RS1_E = RS1_D_R;
    assign RS2_E = RS2_D_R;
endmodule //decode_cycle