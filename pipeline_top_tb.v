`timescale 1ns / 1ps

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
        rst = 1; // Apply reset
        #20;     // Wait for some time

        rst = 0; // Release reset

        // Provide test stimulus (if required, like loading instruction memory or other setup)
        // Test sequence example:
        // - Load specific instructions into instruction memory (manual setup might be needed)
        // - Observe outputs for correctness

        #200;    // Simulate for 200ns
        
        $stop;   // End simulation
    end

    // Optionally monitor signals (use $monitor or $display for debugging)
    initial begin
        $monitor("Time: %0dns, clk = %b, rst = %b", $time, clk, rst);
    end

    // GTKWave setup
    initial begin
        $dumpfile("pipeline_top_tb.vcd"); // Specify the dump file name
        $dumpvars(0, pipeline_top_tb);   // Dump all variables in this module
    end

endmodule
