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

    output [31:0] ResultW,     // Final result to be written back to the register file
    output RegWriteW_W,        // Write enable signal for the register file
    output [4:0] RD_W_W        // Destination register for the writeback stage
);

    // Internal Registers
    reg [4:0] RD_W_R;          // Register for holding destination register
    reg RegWriteW_R;           // Register for holding write enable signal
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
    // Sequential Logic for Pipeline Registers
    // ============================
    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
            // Reset all registers to default values
            ResultW_R <= 32'd0;
            RD_W_R <= 5'd0;
            RegWriteW_R <= 1'b0;
        end else begin
            // Update registers with incoming values
            ResultW_R <= ResultW_X;
            RD_W_R <= RD_W;
            RegWriteW_R <= RegWriteW;
        end
    end

    // ============================
    // Assigning Outputs
    // ============================
    assign ResultW = ResultW_R; // Final result output
    assign RD_W_W = RD_W_R;     // Destination register output
    assign RegWriteW_W = RegWriteW_R; // Write enable signal output

endmodule // writeback_cycle