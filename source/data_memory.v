// ============================
// Data Memory Module
// ============================
module data_memory (
    input [31:0] A, writeData,  // Address and data to write
    input clk, rst, writeEnable,// Clock, reset, and write enable signals
    output [31:0] RD            // Data read from memory
);
    reg [31:0] data_memory [1023:0]; // Memory array

    assign RD = (rst) ? data_memory[A] : 32'h00000000;

    always @(posedge clk) begin
        if (writeEnable)
            data_memory[A] <= writeData;
    end
    integer i;
    initial begin
        for(i =0; i<1023; i++) begin
            data_memory[i] <= 32'd0;
        end
    end
endmodule