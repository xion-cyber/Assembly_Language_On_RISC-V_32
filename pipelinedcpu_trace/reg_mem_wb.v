module reg_mem_wb(
    input [31:0]mem_RD,
    input [31:0]mem_wreg,
    input mem_rf_WE,
    output reg [31:0]wb_wreg,
    output reg [31:0]wb_RD,
    output reg wb_rf_WE,
    input clk,
    input reset,
    input mem_have_inst,
    output reg wb_have_inst,
    input mem_j_type,
    output reg wb_j_type,
    input [31:0]mem_pc,
    output reg [31:0]wb_pc
    );
    always @(posedge clk or negedge reset) begin
        if(~reset)
            wb_RD <= 32'b0;
        else
            wb_RD <= mem_RD;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset)
            wb_wreg <= 32'b0;
        else
            wb_wreg <= mem_wreg;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset)
            wb_rf_WE <= 1'b0;
        else
            wb_rf_WE <= mem_rf_WE;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset)
            wb_have_inst <= 1'b0;
        else
            wb_have_inst <= mem_have_inst;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset)
            wb_j_type <= 1'b0;
        else
            wb_j_type <= mem_j_type;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset)
            wb_pc <= 1'b0;
        else
            wb_pc <= mem_pc;
    end
endmodule
