module data_memory (
    input [31:0] A, writeData,
    input clk, rst, writeEnable,
    output [31:0] RD
);
    reg [31:0] data_memory [1023:0];

    assign RD = (rst) ? data_memory[A] : 32'h00000000;

    always @(posedge clk) begin
        if (writeEnable)
            data_memory[A] <= writeData;
    end
endmodule
