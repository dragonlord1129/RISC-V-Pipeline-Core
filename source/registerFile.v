// ============================
// Register File Module
// ============================
module registerFile (
    input clk, rst,             // Clock and reset signals
    input [4:0] rs1, rs2, rd,   // Register addresses
    input writeEnable,          // Write enable signal
    input [31:0] writeData,     // Data to write to register
    output [31:0] readData1, readData2 // Data read from registers
);
    reg [31:0] x [31:0];        // Register array

    assign readData1 = (~rst) ? x[rs1] : 32'h00000000;
    assign readData2 = (~rst) ? x[rs2] : 32'h00000000;

    always @(posedge clk) begin
        if (~rst && writeEnable)
            x[rd] <= writeData;
    end
endmodule