module PC (
    input clk, rst,
    input [31:0] PC_next,
    output reg [31:0] PC
);
    always @(posedge clk) begin
        if (rst)
            PC <= PC_next;
        else
            PC <= 32'h00000000;
    end
endmodule
