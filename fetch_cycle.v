module fetch_cycle (clk, rst, PCSrcE, PCTargetE, InstrD, PCD, PCPlus4D);
    //inputs and output declaration
    input clk, rst;
    input PCSrcE;
    input [31:0] PCTargetE;
    output [31:0] InstrD;
    output [31:0] PCD, PCPlus4D;

    //declaring interim wires
    wire [31:0] PC_F, PCF, PCPlus4F, InstrF;

    // Declaration of Register
    reg [31:0] InstrF_reg;
    reg [31:0] PCF_reg, PCPlus4F_reg;


    mux PC_Mux (// making PC mux
        .a(PCPlus4F),
        .b(PCTargetE),
        .s(PCSrcE),
        .c(PC_F)
    );
    PC PC(// declaring PC
        .clk(clk),
        .rst(rst),
        .PC(PCF),
        .PC_next(PC_F)
    );
    pc_adder PC_Adder(// making a PC adder
        .a(PCF),
        .b(32'h00000004),
        .c(PCPlus4F)
    );
    instruction_memory Instruction_Memory(// declaring Instruction memory
        .rst(rst),
        .A(PCF),
        .RD(InstrF)
    );

     // Fetch Cycle Register Logic
    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            InstrF_reg <= 32'h00000000;
            PCF_reg <= 32'h00000000;
            PCPlus4F_reg <= 32'h00000000;
        end else begin
            InstrF_reg <= InstrF;
            PCF_reg <= PCF;
            PCPlus4F_reg <= PCPlus4F;
        end
    end


    // Assigning Registers Value to the Output port
    assign  InstrD =  InstrF_reg;
    assign  PCD =  PCF_reg;
    assign  PCPlus4D =  PCPlus4F_reg;
endmodule //fetch cycle