// `timescale 1ns / 1ps

module pipeline_top_tb;

    reg clk=0, rst;
    wire [31:0] Result;
    
    always begin
        clk = ~clk;
        #50;
    end

    initial begin
        rst <= 1'b0;
        #200;
        rst <= 1'b1;
        #1000;
        $finish;    
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0);
    end

    pipeline_top dut (.clk(clk), .rst(rst), .Result(Result));
endmodule