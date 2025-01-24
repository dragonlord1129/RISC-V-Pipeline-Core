// ============================
// Writeback Cycle Module
// ============================
module writeback_cycle (
    input clk, rst,            // Clock and Reset signals
    input RegWriteW,           // Write enable signal from the memory stage
    input [1:0] ResultSrcW,    // Select signal for result source
    input [4:0] RD_W,          // Destination register from the memory stage
    input [31:0] ALUResultW,   // ALU result from the memory stage
    input [31:0] ReadDataW,    // Data read from memory
    input [31:0] PCPlus4W,     // PC+4 value from memory stage

    output [31:0] ResultW     // Final result to be written back to the register file
);

    // Internal Registers

    reg [31:0] ResultW_R;      // Register for holding the final result

    // Internal Wire
    wire [31:0] ResultW_X;     // Wire to hold the multiplexer output

    // ============================
    // Multiplexer to Select Result Source
    // ============================
    mux_3_by_1 mux_3_by_1 (
        .a(ALUResultW),        // Input A: ALU result
        .b(ReadDataW),         // Input B: Memory read data
        .c(PCPlus4W),          // Input C: PC+4 value
        .s(ResultSrcW),        // Select signal
        .d(ResultW_X)          // Output: Selected result
    );

    // ============================
    // Assigning Outputs
    // ============================
    assign ResultW = ResultW_X; // Final result output

endmodule // writeback_cycle