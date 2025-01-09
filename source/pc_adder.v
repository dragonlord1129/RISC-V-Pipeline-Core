// ============================
// PC Adder Module
// ============================
module pc_adder (
    input [31:0] a, b,           // Inputs to the adder
    output [31:0] c              // Sum output
);
    assign c = a + b;            // Perform addition
endmodule