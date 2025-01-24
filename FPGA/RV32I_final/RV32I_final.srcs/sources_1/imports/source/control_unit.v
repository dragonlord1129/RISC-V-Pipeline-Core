// ============================
// Control Unit Module
// ============================
module control_unit (
    input [6:0] opcode, funct7, // Opcode and function fields from instruction
    input [2:0] funct3,         // Function field from instruction
    output RegWrite, ALUSrc, MemWrite, Branch, Jump, // Control signals
    output [1:0] ImmSrc, ResultSrc,                 // Immediate and result source controls
    output [2:0] ALUControl                          // ALU control signals
);
    wire [1:0] ALUOp; // Internal signal for ALU operation

    // Main decoder instance
    main_decoder main_decoder (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .Jump(Jump),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp)
    );

    // ALU decoder instance
    alu_decoder alu_decoder (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .opcode(opcode),
        .ALUControl(ALUControl)
    );
endmodule