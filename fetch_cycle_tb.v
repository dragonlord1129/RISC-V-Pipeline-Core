module fetch_cycle_tb();

    reg clk, rst, PCSrcE;
    reg [31:0] PCTargetE;
    wire [31:0] InstrD, PCD, PCPlus4D;

    fetch_cycle dut (
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

    always begin
        clk = ~clk;
        #50;
    end

    //Providing stimulus
    initial begin
        rst <= 1'b0;
        clk <= 1'b1;
        #200;
        rst <= 1'b1;
        PCSrcE <= 1'b0;
        PCTargetE <= 32'd0;
        #500;
        $finish;
    end
    
    initial begin
        $dumpfile("stuff.vcd");
        $dumpvars(0, fetch_cycle_tb);
    end

endmodule