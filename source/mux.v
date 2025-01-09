module mux (a,b,s,c);

    input [31:0]a,b;
    input s;
    output [31:0]c;

    assign c = (~s) ? a : b ;
    
endmodule

// ============================
// Multiplexer for 3 Inputs
// ============================
module mux_3_by_1 (
    input [31:0] a, b, c,      // Inputs: three 32-bit data lines
    input [1:0] s,             // Select signal (2 bits)
    output [31:0] d            // Output: Selected data line
);

    assign d = (s == 2'b00) ? a : 
               (s == 2'b01) ? b : 
               (s == 2'b10) ? c : 32'h00000000; // Default case

endmodule