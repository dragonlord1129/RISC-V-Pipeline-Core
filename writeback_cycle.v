module writeback_cycle (
    clk, rst, RegWriteW, ResultSrcW, ALUResultW, ReadDataW, PCPlus4W, RD_W, RD_W_W,
    ResultW, RegWriteW_W
);
    input clk, rst, RegWriteW;
    input [1:0] ResultSrcW;
    input [4:0] RD_W;
    input [31:0] ALUResultW, ReadDataW, PCPlus4W;

    output [31:0] ResultW; 
    output RegWriteW_W;
    output [4:0] RD_W_W;

    reg [4:0] RD_W_R;
    reg RegWriteW_R;
    reg [31:0] ResultW_R;

    wire [31:0] ResultW_X;
    
    // Multiplexer instantiation
    mux_3_by_1 mux_3_by_1(
        .a(ALUResultW),
        .b(ReadDataW),
        .c(PCPlus4W),
        .s(ResultSrcW),
        .d(ResultW_X)  // Use intermediate wire
    );

    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
            ResultW_R <= 32'd0;
            RD_W_R <= 5'd0;
            RegWriteW_R <= 1'b0;  // Use non-blocking assignment
        end else begin
            ResultW_R <= ResultW_X;
            RD_W_R <= RD_W;
            RegWriteW_R <= RegWriteW;
        end
    end

    // Assign outputs
    assign ResultW = ResultW_R;
    assign RD_W_W = RD_W_R;
    assign RegWriteW_W = RegWriteW_R;

endmodule // writeback_cycle
