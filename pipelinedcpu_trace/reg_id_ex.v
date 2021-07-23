module reg_id_ex(
    input clk,
    input reset,
    input id_mem2reg,
    input [1:0]id_pc_sel,
    input id_dram_we,
    input id_Branch,
    input [3:0]id_alu_op,
    input [31:0]id_pc,
    input [31:0]id_imm,
    input [31:0]id_rd1,
    input [31:0]id_op_a,
    input [31:0]id_op_b,
    input [31:0]id_rd2,
    input [31:0]id_RD,
    input id_rf_WE,
    output reg ex_mem2reg,
    output reg [1:0]ex_pc_sel,
    output reg ex_dram_we,
    output reg ex_Branch,
    output reg [3:0]ex_alu_op,
    output reg [31:0]ex_pc,
    output reg [31:0]ex_imm,
    output reg [31:0]ex_rd1,
    output reg [31:0]ex_op_a,
    output reg [31:0]ex_op_b,
    output reg [31:0]ex_rd2,
    output reg [31:0]ex_RD,
    output reg ex_rf_WE,
    input stop,
    input jump,
    input id_have_inst,
    output reg ex_have_inst,
    input id_j_type,
    output reg ex_j_type
    );
    always @(posedge clk or negedge reset) begin
        if(~reset | jump |stop)
            ex_mem2reg <= 1'b0;
        else
            ex_mem2reg <= id_mem2reg;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset | jump |stop)
            ex_pc_sel <= 2'b0; 
        else
            ex_pc_sel <= id_pc_sel;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset | jump |stop)
            ex_dram_we <= 1'b0;
        else
            ex_dram_we <= id_dram_we;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset | jump |stop)
            ex_Branch <= 1'b0;
        else
            ex_Branch <= id_Branch;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset | jump |stop)
            ex_alu_op <= 4'b0;
        else
            ex_alu_op <= id_alu_op;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset | jump |stop)
            ex_pc <= 32'b0;
        else
            ex_pc <= id_pc;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset | jump |stop)
            ex_imm <= 32'b0;
        else
            ex_imm <= id_imm;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset | jump |stop)
            ex_rd1 <= 32'b0;
        else
            ex_rd1 <= id_rd1;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset | jump |stop)
            ex_op_a <= 32'b0;
        else
            ex_op_a <= id_op_a;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset | jump |stop)
            ex_op_b <= 32'b0;
        else
            ex_op_b <= id_op_b;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset | jump |stop)
            ex_rd2 <= 32'b0;
        else
            ex_rd2 <= id_rd2;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset | jump |stop)
            ex_RD <= 32'b0;
        else
            ex_RD <= id_RD;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset | jump |stop)
            ex_rf_WE <= 1'b0;
        else
            ex_rf_WE <= id_rf_WE;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset | jump |stop)
            ex_have_inst <= 1'b0;
        else
            ex_have_inst <= id_have_inst;
    end
    always @(posedge clk or negedge reset) begin
        if(~reset | jump |stop)
            ex_j_type <= 1'b0;
        else
            ex_j_type <= id_j_type;
    end
endmodule
