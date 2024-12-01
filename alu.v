module alu #(
    parameter WIDTH = 32,
    parameter ALU_WIDTH = 3
) (
    input [WIDTH-1:0] A, B,
    input [ALU_WIDTH-1:0] ALUControl,
    
    output [WIDTH-1:0] result,
    output carry, zero, overflow, negative
);
    wire [WIDTH-1:0] A_or_B, A_and_B, A_xor_B, not_B;
    wire [WIDTH-1:0] mux_1, mux_2;
    wire [WIDTH-1:0] sum;
    wire [WIDTH-1:0] slt;
    wire cout;

    assign A_and_B = A & B;
    assign A_or_B = A | B;
    assign A_xor_B = A ^ B;
    assign not_B = ~B;
    

    assign mux_1 = (ALUControl[0] == 1'b1) ? not_B : B; // Selects between B and ~B based on ALUControl[0].
    assign {cout, sum} = A + mux_1 + ALUControl[0]; // Performs addition or subtraction based on ALUControl[0].
    
    /* Explanation:
        If ALUControl[0] == 0:
            - mux_1 = B (since ALUControl[0] == 0, mux_1 selects B directly).
            - sum = A + B + 0, which simplifies to A + B. So, when ALUControl[0] is 0, the operation is standard addition.

        If ALUControl[0] == 1:
            - mux_1 = ~B (since ALUControl[0] == 1, mux_1 selects the bitwise negation of B, or "not_B").
            - sum = A + ~B + 1.
            - This is equivalent to A + 2's complement of B, which gives us A - B.
    */

    // Set Less Than operation
    assign slt = { {WIDTH-1{1'b0}}, sum[WIDTH-1] };  // Setting only the least significant bit based on the sign of sum

    // Multiplexer for ALU operation selection
    assign mux_2 = (ALUControl[2:0] == 3'b000) ? sum :
                   (ALUControl[2:0] == 3'b001) ? sum :
                   (ALUControl[2:0] == 3'b010) ? A_and_B : 
                   (ALUControl[2:0] == 3'b011) ? A_or_B :
                   (ALUControl[2:0] == 3'b101) ? slt : {WIDTH{1'b0}};
    
    assign result = mux_2;

    // Flags assignment 
    assign zero = &(~result); // Reduction AND checks if all bits in result are 0
    assign carry = cout & (~ALUControl[1]);
    assign negative = result[WIDTH-1];
    assign overflow = (~ALUControl[1]) & (sum[WIDTH-1] ^ A[WIDTH-1]) & (~(ALUControl[0] ^ A[WIDTH-1] ^ B[WIDTH-1]));

endmodule