// ============================
// Sign Extend Module
// ============================
module sign_extend (
    input [31:0] In,           // Input immediate value
    input [1:0] ImmSrc,        // Immediate type selector
    output [31:0] Imm_Ext      // Sign-extended immediate value
);
    assign Imm_Ext =  (ImmSrc == 2'b00) ? {{20{In[31]}},In[31:20]} : 
                     (ImmSrc == 2'b01) ? {{20{In[31]}},In[31:25],In[11:7]} : 32'h00000000; 
endmodule