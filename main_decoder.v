module main_decoder (
    input [6:0] opcode,
    output RegWrite, MemWrite, ALUSrc, Branch, Jump,
    output [1:0] ImmSrc, ResultSrc, ALUOp
);
    parameter lw = 7'b0000011;     // Load word
    parameter sw = 7'b0100011;     // Store word
    parameter R_type = 7'b0110011; // R-type instructions
    parameter beq = 7'b1100011;    // Branch equal
    parameter jal = 7'b1101111;    // Jump and link
    parameter jalr = 7'b1100111;   // Jump and link register

    assign RegWrite = ((opcode == lw) | (opcode == R_type) | (opcode == jal) | (opcode == jalr)) ? 1'b1 : 1'b0;
    assign MemWrite = (opcode == sw) ? 1'b1 : 1'b0;
    assign ALUSrc = ((opcode == lw) | (opcode == sw) | (opcode == jalr)) ? 1'b1 : 1'b0;
    assign Branch = (opcode == beq) ? 1'b1 : 1'b0;

    assign JumpD = ((opcode == jal) | (opcode == jalr)) ? 1'b1 : 1'b0;

    assign ImmSrc = (opcode == sw) ? 2'b01 :   // S-type immediate
                    (opcode == beq) ? 2'b10 :  // B-type immediate
                    (opcode == jal) ? 2'b11 :  // J-type immediate
                    2'b00;                     // Default (I-type)

    assign ALUOp = ((opcode == lw) | (opcode == sw)) ? 2'b00 : // Load/store
                   (opcode == R_type) ? 2'b10 :               // ALU operations
                   (opcode == beq) ? 2'b01 :                  // Branch
                   2'b00;                                     // Default

    assign ResultSrc = (opcode == lw) ? 2'b01 :  // Memory result
                       (opcode == jal) ? 2'b11 : // PC+4 (Jump link)
                       2'b00;                    // Default (ALU result)
endmodule
