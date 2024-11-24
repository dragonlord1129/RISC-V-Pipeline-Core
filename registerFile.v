module registerFile (
    input clk, rst,
    input [4:0] rs1, rs2, rd,
    input writeEnable,
    input [31:0] writeData,
    output [31:0] readData1, readData2
);
    reg [31:0] x [31:0];

    assign readData1 = (~rst) ? x[rs1] : 32'h00000000;
    assign readData2 = (~rst) ? x[rs2] : 32'h00000000;

    always @(posedge clk) begin
        if (~rst && writeEnable)
            x[rd] <= writeData;
    end
endmodule
