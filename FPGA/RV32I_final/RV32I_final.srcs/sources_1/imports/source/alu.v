// ============================
// ALU Module
// ============================
module alu #(
    parameter WIDTH = 32,          // Data width for ALU
    parameter ALU_WIDTH = 3        // Control signal width
) (
    input [WIDTH-1:0] A, B,        // Inputs to the ALU
    input [ALU_WIDTH-1:0] ALUControl, // Control signals for ALU operations

    output [WIDTH-1:0] result,     // ALU result output
    output carry, zero, overflow, negative // Status flags
);
    wire [WIDTH-1:0] A_or_B, A_and_B, A_xor_B, not_B; // Intermediate signals
    wire [WIDTH-1:0] mux_1, mux_2;                   // Multiplexer outputs
    wire [WIDTH-1:0] sum;                            // Result of addition/subtraction
    wire [WIDTH-1:0] slt;                            // Set Less Than result
    wire cout;                                       // Carry-out flag

    // Addition/Subtraction based on ALUControl
    assign mux_1 = (ALUControl[0] == 1'b1) ? ~B : B;
    assign {cout, sum} = A + mux_1 + ALUControl[0];

    // Set Less Than operation
    assign slt = { {WIDTH-1{1'b0}}, sum[WIDTH-1] };

    // Multiplexer for ALU operation selection
    assign mux_2 = (ALUControl[2:0] == 3'b000) ? sum :
                   (ALUControl[2:0] == 3'b001) ? sum :
                   (ALUControl[2:0] == 3'b010) ? A & B : 
                   (ALUControl[2:0] == 3'b011) ? A | B :
                   (ALUControl[2:0] == 3'b101) ? slt : {WIDTH{1'b0}};

    assign result = mux_2;

    // Status flags
    assign zero = &(~result); // Check if result is zero
    assign carry = cout & (~ALUControl[1]);
    assign negative = result[WIDTH-1];
    assign overflow = (~ALUControl[1]) & (sum[WIDTH-1] ^ A[WIDTH-1]) & (~(ALUControl[0] ^ A[WIDTH-1] ^ B[WIDTH-1]));

endmodule