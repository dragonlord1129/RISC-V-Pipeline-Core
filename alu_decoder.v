module alu_decoder (
    input [1:0] ALUOp,
    input [6:0] funct7,opcode,
    input [2:0] funct3,

    output reg [2:0] ALUControl
);
    parameter add = 3'b000;
    parameter sub = 3'b001;
    parameter slt = 3'b101; // set less than
    parameter OR = 3'b011;
    parameter AND = 3'b010;

    wire [1:0] concatenation;

    assign concatenation = {opcode[5], funct7[5]};
    assign ALUControl = (ALUOP == 2'b00) ? add : // performs lw, sw operation
                        (ALUOP == 2'b01) ? sub : //performs beq operation
                        ((ALUOP == 2'b10) & (funct3 == 3'b010)) ? slt : // performs slt operation
                        ((ALUOP == 2'b10) & (funct3 == 3'b110)) ? OR : // performs OR operation
                        ((ALUOP == 2'b10) & (funct3 == 3'b111)) ? AND : // performs AND operation
                        ((ALUOP == 2'b10) & (funct3 == 3'b000) & (concatenation == 2'b11)) ? sub : // performs sub operation
                        ((ALUOP == 2'b10) & (funct3 == 3'b000) & (concatenation != 2'b11)) ? add : 3'b000;// performs add operation    
endmodule