`include "mux.v"
module writeback_cycle (clk, rst, RegWriteW, ResultSrcW, ALUResultW, ReadDataW, RD_W, RD_W_W,
ResultW, RegWriteW_W);
    input clk, rst, RegWriteW, 
    input [1:0] ResultSrcW;
    input [4:0] RD_W;
    input [31:0] ALUResultW, ReadDataW;

    output [31:0] ResultW; 
    output RegWriteW_W;
    output [4:0] RD_W_W;

    reg [4:0] RD_W_R;
    reg RegWriteW_R;
    reg [31:0] ResultW_R;

    wire [31:0] ResultW_X;
    
    mux mux(
        .a(ALUResultW),
        .b(ReadDataW),
        .s(ResultSrcW),
        .c(ResultW_X)
    );

    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            ResultW_R <= 32'd0;
            RD_W_R <= 5'd0;
            RegWriteW_R = 1'b0;
        end else begin
            ResultW_R <= ResultW_X;
            RD_W_R <= RD_W;
            RegWriteW_R = RegWriteW;
        end
    end

    assign ResultW = ResultW_R;
    assign RD_W_W = RD_W_R;
    assign RegWriteW = RegWriteW_W;

endmodule //writeback_cycle