// ============================
// PC Module
// ============================
module PC (
    input clk, rst,             // Clock and reset signals
    input [31:0] PC_next,       // Next program counter value
    output reg [31:0] PC        // Current program counter
);
    always @(posedge clk) begin
        if (rst)
            PC <= PC_next;      // Update PC on clock edge
        else
            PC <= 32'h00000000; // Reset PC to zero
    end
endmodule