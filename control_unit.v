module control_unit (
    input [6:0] opcode, funct7,
    input [2:0] funct3,
    output RegWrite, ALUSrc, MemWrite, Branch, Jump,
    output [1:0] ImmSrc, ResultSrc,
    output [2:0] ALUControl
);
    wire [1:0] ALUOp; // Internal signal for ALUOp

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
        .ALUOp(ALUOp) // Outputs ALUOp
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
