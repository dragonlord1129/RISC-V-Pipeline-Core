module main_decoder (
    input [6:0] opcode,
    output RegWrite, MemWrite, ResultSrc, ALUSrc, branch,
    output [1:0] ImmSrc, ALUOp
);
    parameter lw = 7'b0000011;
    parameter sw = 7'b0100011;
    parameter R_type = 7'b0110011;
    parameter beq = 7'b1100011;

    

    assign RegWrite = ((opcode == lw) | (opcode == R_type)) ? 1'b1 : 1'b0;
    assign MemWrite = (opcode == sw) ? 1'b1 : 1'b0;
    assign ResultSrc = (opcode == lw) ? 1'b1 : 1'b0;
    assign ALUSrc = ((opcode == lw) | (opcode == sw)) ? 1'b1 : 1'b0;
    assign branch = (opcode == beq) ? 1'b1 : 1'b0;

    assign ImmSrc = (opcode == sw) ? 2'b01 :
                    (opcode == beq) ? 2'b10 : 2'b00;
    assign ALUOp = ((opcode == lw) | (opcode == sw)) ? 2'b00 :
                    (opcode == R_type) ? 2'b10 :
                    (opcode == beq) ? 2'b01 : 2'b00;
endmodule
