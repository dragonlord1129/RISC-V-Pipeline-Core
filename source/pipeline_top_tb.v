// `timescale 1ns / 1ps

module pipeline_top_tb;

    // Inputs
    reg clk;
    reg rst;

    // Instantiate the Unit Under Test (UUT)
    pipeline_top dut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Simulation
    initial begin
        // Initialize inputs
        rst = 0; // Apply reset
        #20;     // Wait for reset to settle

        rst = 1; // Release reset

        // Run simulation for 500ns
        #500;
        $finish;
    end

    // Monitor important signals
    // initial begin
    //     $monitor("Time: %0dns, PC: %h, RegWriteW: %b, ResultW: %h",
    //              $time, dut.fetch.PCD, dut.writeback.RegWriteW, dut.writeback.ResultW);
    // end

    // Dump waveforms for GTKWave
    initial begin
        $dumpfile("pipeline_top_tb.vcd");
        $dumpvars(0, pipeline_top_tb);
    end

endmodule
