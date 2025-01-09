// ============================
// ALU Decoder Module
// ============================
module alu_decoder (
    input [1:0] ALUOp,          // ALU operation code from control unit
    input [6:0] funct7, opcode, // Function and opcode fields from instruction
    input [2:0] funct3,         // Function field from instruction
    output [2:0] ALUControl     // ALU control signals
);
    parameter add = 3'b000;    // Add operation
    parameter sub = 3'b001;    // Subtract operation
    parameter slt = 3'b101;    // Set less than
    parameter OR  = 3'b011;    // OR operation
    parameter AND = 3'b010;    // AND operation

    wire [1:0] concatenation;  // Concatenated signals for specific operations

    // Determine ALUControl based on ALUOp and instruction fields
    assign concatenation = {opcode[5], funct7[5]};
    assign ALUControl = (ALUOp == 2'b00) ? add : // lw, sw operations
                        (ALUOp == 2'b01) ? sub : // beq operation
                        ((ALUOp == 2'b10) & (funct3 == 3'b010)) ? slt : // slt operation
                        ((ALUOp == 2'b10) & (funct3 == 3'b110)) ? OR :  // OR operation
                        ((ALUOp == 2'b10) & (funct3 == 3'b111)) ? AND : // AND operation
                        ((ALUOp == 2'b10) & (funct3 == 3'b000) & (concatenation == 2'b11)) ? sub : // sub operation
                        ((ALUOp == 2'b10) & (funct3 == 3'b000) & (concatenation != 2'b11)) ? add : // add operation
                        3'b000; // Default
endmodule