module memory_cycle (clk, rst, RegWriteM, ResultSrcM, MemWriteM, ALUResultM, WriteDataM, RD_M, PCPlus4M,
RegWriteW, ResultSrcW, ALUResultW, ReadDataW, RD_W, PCPlus4W
);

    input clk, rst;
    input RegWriteM, MemWriteM;
    input [1:0] ResultSrcM;
    input [31:0] ALUResultM, WriteDataM, PCPlus4M;
    input [4:0] RD_M;
    
    output RegWriteW;
    output [1:0] ResultSrcW;
    output [31:0] ALUResultW, ReadDataW, PCPlus4W;
    output [4:0] RD_W;

    reg RegWriteM_R;
    reg [1:0] ResultSrcM_R;
    reg [31:0] ALUResultM_R, ReadDataM_R, PCPlus4M_R;
    reg [4:0] RD_M_R;

    wire [31:0] ReadDataM_W;    

    data_memory data_memory(
        .clk(clk),
        .rst(rst),
        .writeEnable(MemWriteM),
        .writeData(WriteDataM),
        .A(ALUResultM),
        .RD(ReadDataM_W)
    );

    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            RegWriteM_R <= 1'b0;
            ResultSrcM_R <= 2'b00;
            ALUResultM_R <= 32'd0;
            ReadDataM_R <= 32'd0;
            PCPlus4M_R <= 32'd0;
            RD_M_R <= 32'd0;
        end else begin
            RegWriteM_R <= RegWriteM;
            ResultSrcM_R <= ResultSrcM;
            ALUResultM_R <= ALUResultM;
            ReadDataM_R <= ReadDataM_W;
            PCPlus4M_R <= PCPlus4M;
            RD_M_R <= RD_M;
        end
    end
    
    assign RegWriteW = RegWriteM_R;
    assign ResultSrcW = ResultSrcM_R;
    assign RD_W = RD_M_R;
    assign PCPlus4W = PCPlus4M_R;
    assign ALUResultW = ALUResultM_R;
    assign ReadDataW = ReadDataM_R;
endmodule //memory_cycle