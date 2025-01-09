// ============================
// Instruction Memory Module
// ============================
module instruction_memory (
    input rst,                   // Reset signal
    input [31:0] A,              // Address to fetch instruction
    output [31:0] RD             // Instruction read
);
    reg [31:0] memory [1023:0]; // Instruction memory array

    assign RD = (rst == 1'b0) ? 32'h00000000 : memory[A];

    initial begin
        $readmemh("memfile.hex", memory); // Load instructions from file
    end
endmodule