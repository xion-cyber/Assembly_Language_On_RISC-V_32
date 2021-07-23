module reg_ex_mem(
    input ex_mem2reg,
    input ex_dram_we,
    input [31:0]ex_result,
    input [31:0]ex_rd2,
    input ex_rf_WE,
    input clk,
    input reset,
    input [31:0]ex_RD,
    output reg [31:0]mem_RD,
    output reg mem_mem2reg,
    output reg mem_dram_we,
    output reg [31:0]mem_result,
    output reg [31:0]mem_rd2,
    output reg mem_rf_WE,
    input ex_have_inst,
    output reg mem_have_inst,
    input ex_j_type,
    output reg mem_j_type,
    input [31:0]ex_pc,
    output reg [31:0]mem_pc
    );
    always @(posedge clk or negedge reset) begin
        if(~reset)
            mem_mem2reg <= 32'b0;
        else
            mem_mem2reg <= ex_mem2reg;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset)
            mem_RD <= 32'b0;
        else
            mem_RD <= ex_RD;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset)
            mem_dram_we <= 32'b0;
        else
            mem_dram_we <= ex_dram_we;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset)
            mem_result <= 32'b0;
        else
            mem_result <= ex_result;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset)
            mem_rd2 <= 32'b0;
        else
            mem_rd2 <= ex_rd2;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset)
            mem_rf_WE <= 1'b0;
        else
            mem_rf_WE <= ex_rf_WE;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset)
            mem_have_inst <= 1'b0;
        else
            mem_have_inst <= ex_have_inst;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset)
            mem_j_type <= 1'b0;
        else
            mem_j_type <= ex_j_type;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset)
            mem_pc <= 1'b0;
        else
            mem_pc <= ex_pc;
    end
endmodule
