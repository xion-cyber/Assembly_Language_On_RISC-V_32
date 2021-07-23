module mini_rv(
    input clk,
    input reset,
    input [31:0]mem_rdata,
    input [31:0]if_inst,
    output [31:0]mem_result,
    output mem_dram_we,    
    output [31:0] mem_rd2,
    output [31:0] wb_pc,
    output debug_wb_have_inst,
    output wb_rf_WE,
    output [4:0]wb_RD,
    output [31:0]wb_data,
    output [31:0]if_pc
    );
    wire stop;
    wire jump;
    wire id_re1;
    wire id_re2;
    //------------------------------------IF-----------------------------
    wire [31:0]next_pc;
    PC pc(
        .clk(clk),              //clock
        .reset(reset),            //复位
        .next_pc(next_pc),  //新指令地址
        .cur_pc(if_pc),    //新指令地址
        .stop(stop),
        .jump(jump)
    );
    //------------------------------------ID-----------------------------
    wire id_rf_WE;
    wire [4:0]wR;
    wire [6:0]op;
    wire [2:0]func3;
    wire [6:0]func7;
    wire [4:0]rR1;
    wire [4:0]rR2;
    wire [3:0]alu_op;
    wire alub_sel;
    wire id_j_type;
    wire [2:0] imm_sel;
    wire [4:0]id_RD;
    wire [31:0]id_inst;
    wire [31:0]id_pc;
    wire [31:0]id_op_a;
    wire [31:0]id_op_b;
    wire [31:0]id_imm;
    wire [31:0]id_rd1;
    wire [31:0]id_rd2;
    wire [1:0]id_pc_sel;
    wire [3:0]id_alu_op;
    wire id_Branch;
    wire id_dram_we;
    wire id_mem2reg;
    wire id_have_inst;
    assign id_op_a = id_rd1;
    assign id_op_b = alub_sel ? id_rd2:id_imm;
    assign id_RD = wR;
    
    reg_if_id IF_ID(
    .clk(clk),
    .reset(reset),
    .if_pc(if_pc),
    .if_inst(if_inst),
    .id_pc(id_pc),
    .id_inst(id_inst),
    .stop(stop),
    .jump(jump),
    .id_have_inst(id_have_inst)
    );
    
    imm IMM(
        .cur_pc(id_pc),
        .ins(id_inst),
        .imm_sel(imm_sel),
        .imm_i(id_imm)
    );
    
    ins_cut CUT(
        .ins(id_inst),
        .opcode(op),
        .func3(func3),
        .func7(func7),
        .rs1(rR1),
        .rs2(rR2),
        .rd(wR),
        .jump(jump)
    );
    
    controlunit control(
        .opcode(op),
        .func3(func3),
        .func7(func7),
        .npc_op(id_pc_sel),
        .rf_we(id_rf_WE),
        .alu_op(id_alu_op),
        .alub_sel(alub_sel),
        .Branch(id_Branch),
        .imm_sel(imm_sel),
        .dram_we(id_dram_we),
        .j_type(id_j_type),
        .mem2reg(id_mem2reg),
        .id_re1(id_re1),
        .id_re2(id_re2),
        .jump(jump)
    );
    
    //------------------------------EX----------------------------------
    wire ex_mem2reg;
    wire [1:0]ex_pc_sel;
    wire ex_dram_we;
    wire ex_Branch;
    wire [3:0]ex_alu_op;
    wire [31:0]ex_pc;
    wire [31:0]ex_imm;
    wire [31:0]ex_rd1;
    wire [31:0]ex_rd2;
    wire [31:0]ex_RD;
    wire branch;
    wire [31:0]ex_op_a;
    wire [31:0]ex_op_b;
    wire [31:0]ex_result;
    wire [31:0]ex_rf_WE;
    wire ex_have_inst;
    wire ex_j_type;
    
    reg_id_ex ID_EX(
        .clk(clk),
        .reset(reset),
        .id_mem2reg(id_mem2reg),
        .id_pc_sel(id_pc_sel),
        .id_dram_we(id_dram_we),
        .id_Branch(id_Branch),
        .id_alu_op(id_alu_op),
        .id_pc(id_pc),
        .id_imm(id_imm),
        .id_rd1(id_rd1),
        .id_op_a(id_op_a),
        .id_op_b(id_op_b),
        .id_rd2(id_rd2),
        .id_RD(id_RD),
        .id_rf_WE(id_rf_WE),
        .ex_mem2reg(ex_mem2reg),
        .ex_pc_sel(ex_pc_sel),
        .ex_dram_we(ex_dram_we),
        .ex_Branch(ex_Branch),
        .ex_alu_op(ex_alu_op),
        .ex_pc(ex_pc),
        .ex_imm(ex_imm),
        .ex_rd1(ex_rd1),
        .ex_op_a(ex_op_a),
        .ex_op_b(ex_op_b),
        .ex_rd2(ex_rd2),
        .ex_RD(ex_RD),
        .ex_rf_WE(ex_rf_WE),
        .stop(stop),
        .jump(jump),
        .ex_have_inst(ex_have_inst),
        .id_have_inst(id_have_inst),
        .id_j_type(id_j_type),
        .ex_j_type(ex_j_type)
    );

    ALU alu(
        .A(ex_op_a),
        .B(ex_op_b),
        .op(ex_alu_op),
        .result(ex_result),
        .branch(branch)
    );
    
    NPC npc(
        .cur_pc(ex_pc),
        .pc_sel(ex_pc_sel),
        .pc_imm(ex_imm),
        .branch(branch),
        .Branch(ex_Branch),
        .rs1(ex_rd1),
        .next_pc(next_pc),
        .jump(jump)
    );
    
    //----------------------------------------MEM----------------------------
    wire [31:0]mem_RD;
    wire mem_mem2reg;
    wire [31:0]mem_wreg;
    wire mem_rf_WE;
    wire mem_have_inst;
    wire mem_j_type;
    wire [31:0]mem_pc;
    assign mem_wreg = mem_mem2reg?mem_rdata:mem_result;
    reg_ex_mem EX_MEM(
        .ex_mem2reg(ex_mem2reg),
        .ex_dram_we(ex_dram_we),
        .ex_result(ex_result),
        .ex_rd2(ex_rd2),
        .ex_rf_WE(ex_rf_WE),
        .clk(clk),
        .reset(reset),
        .ex_RD(ex_RD),
        .mem_RD(mem_RD),
        .mem_mem2reg(mem_mem2reg),
        .mem_dram_we(mem_dram_we),
        .mem_result(mem_result),
        .mem_rd2(mem_rd2),
        .mem_rf_WE(mem_rf_WE),
        .ex_have_inst(ex_have_inst),
        .mem_have_inst(mem_have_inst),
        .ex_j_type(ex_j_type),
        .mem_j_type(mem_j_type),
        .ex_pc(ex_pc),
        .mem_pc(mem_pc)
    );
    //----------------------------------------WB-----------------------------
    wire [31:0]wb_wreg;
    wire wb_j_type;
    assign wb_data = wb_j_type?wb_pc+4:wb_wreg;
    reg_mem_wb MEM_WB(
        .mem_RD(mem_RD),
        .mem_wreg(mem_wreg),
        .mem_rf_WE(mem_rf_WE),
        .wb_wreg(wb_wreg),
        .wb_RD(wb_RD),
        .wb_rf_WE(wb_rf_WE),
        .clk(clk),
        .reset(reset),
        .mem_have_inst(mem_have_inst),
        .wb_have_inst(debug_wb_have_inst),
        .mem_j_type(mem_j_type),
        .wb_j_type(wb_j_type),
        .mem_pc(mem_pc),
        .wb_pc(wb_pc)
    );
    
    RF regfile(
        .clk(clk),
        .reset(reset),
        .rR1(rR1),
        .rR2(rR2),
        .wR(wb_RD),
        .WE(wb_rf_WE),
        .wD(wb_data),
        .rD1(id_rd1),
        .rD2(id_rd2)
    );
    //-------------------------TEST_HAZARD------------------------------------
    test_hazard test(
        .id_rs1(rR1),
        .id_rs2(rR2),
        .ex_RD(ex_RD),
        .mem_RD(mem_RD),
        .wb_RD(wb_RD),
        .ex_rf_WE(ex_rf_WE),
        .mem_rf_WE(mem_rf_WE),
        .wb_rf_WE(wb_rf_WE),
        .id_re1(id_re1),
        .id_re2(id_re2),
        .stop(stop)
    );
endmodule