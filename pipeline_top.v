`include "fetch_cycle.v"
`include "decode_cycle.v"
`include "execute_cycle.v"
`include "memory_cycle.v"
`include "writeback_cycle.v"

module pipeline_top (clk, rst);

    fetch_cycle fetch(
        .clk(clk), 
        .rst(rst), 
        .PCSrcE(), 
        .PCTargetE(), 
        .InstrD(), 
        .PCD(), 
        .PCPlus4D()
    );

    decode_cycle decode(
        .clk(clk), 
        .rst(rst),  
        .InstrD(), 
        .PCD(), 
        .PCPlus4D(), 
        .RegWriteW(), 
        .RDW(), 
        .ResultW(), 
        .RegWriteE(), 
        .ALUSrcE(), 
        .MemWriteE(), 
        .ResultSrcE(), 
        .BranchE(), 
        .ALUControlE(), 
        .RD1_E(), 
        .RD2_E(), 
        .Imm_Ext_E(), 
        .RD_E(), 
        .PCE(), 
        .PCPlus4E(), 
        .RS1_E(), 
        .RS2_E()
    );

    execute_cycle execute(
        .clk(clk),
        .rst(rst)
        .RegWriteE(), 
        .ALUSrcE(), 
        .MemWriteE(), 
        .ResultSrcE(), 
        .BranchE(), 
        .ALUControlE(), 
        .RD1_E(), 
        .RD2_E(), 
        .Imm_Ext_E(), 
        .RD_E(), 
        .PCE(), 
        .PCPlus4E(),
        .ALUResultM(), 
        .WriteDataM(), 
        .PCTargetE(), 
        .PCPlus4M(),
        .RD_M(),
        .RegWriteM(), 
        .MemWriteM(), 
        .PCSrcE(),
        .ResultSrcM()
    );

    memory_cycle memory(
        .clk(clk), 
        .rst(rst), 
        .RegWriteM(), 
        .ResultSrcM(), 
        .MemWriteM(), 
        .ALUResultM(), 
        .WriteDataM(), 
        .RD_M(), 
        .PCPlus4M(),
        .RegWriteW(), 
        .ResultSrcW(), 
        .ALUResultW(), 
        .ReadDataW(), 
        .RD_W(), 
        .PCPlus4W()
    );

    writeback_cycle writeback(
        .clk(clk), 
        .rst(rst), 
        .RegWriteW(), 
        .ResultSrcW(), 
        .ALU_ResultW(), 
        .ReadDataW(), 
        .RD_W(),
        .ResultW(), 
        .RegWriteW_W()
    );

endmodule //pipeline_top