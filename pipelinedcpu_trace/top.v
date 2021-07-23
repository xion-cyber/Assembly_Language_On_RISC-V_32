/* verilator lint_off UNOPTFLAT */
module top(
    input clk,
    input rst_n,
    output debug_wb_have_inst,
    output [31:0]debug_wb_pc,
    output debug_wb_ena,
    output [4:0]debug_wb_reg,
    output [31:0]debug_wb_value
    );
    
   wire [31:0]ins;
   wire [31:0]result;
   wire dram_we;
   wire [31:0]rD2;
   wire [31:0]RD;
   wire [31:0]if_pc;
   mini_rv mini_rv_u(
    .clk(clk),
    .reset(rst_n),
    .mem_rdata(RD),
    .if_inst(ins),
    .mem_result(result),
    .mem_dram_we(dram_we),
    .mem_rd2(rD2),
    .wb_pc(debug_wb_pc),
    .debug_wb_have_inst(debug_wb_have_inst),
    .wb_rf_WE(debug_wb_ena),
    .wb_RD(debug_wb_reg),
    .wb_data(debug_wb_value),
    .if_pc(if_pc)
   );
   
    inst_mem imem(
      .a(if_pc[17:2]),         // input wire [13 : 0] a
      .spo(ins)                 // output wire [31 : 0] spo
    );
    
    data_mem dmem(
      .clk(clk),            // input wire clk
      .a(result[17:2]),     // input wire [13 : 0] a
      .we(dram_we),             // input wire we
      .d(rD2),                  // input wire [31 : 0] d
      .spo(RD)                  // output wire [31 : 0] spo
    );
    
endmodule