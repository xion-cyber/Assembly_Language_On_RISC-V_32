module test_hazard(
    input [6:0]id_rs1,
    input [6:0]id_rs2,
    input [31:0]ex_RD,
    input [31:0]mem_RD,
    input [31:0]wb_RD,
    input ex_rf_WE,
    input mem_rf_WE,
    input wb_rf_WE,
    input id_re1,
    input id_re2,
    output stop
    );
    wire stop_id_ex_1;
    assign stop_id_ex_1 = ((id_rs1 == ex_RD) & ex_rf_WE & id_re1) &&id_rs1;
    wire stop_id_ex_2;
    assign stop_id_ex_2 = ((id_rs2 == ex_RD) & ex_rf_WE & id_re2) &&id_rs2;
    wire stop_id_mem_1;
    assign stop_id_mem_1 = ((id_rs1 == mem_RD) & mem_rf_WE & id_re1) &&id_rs1;
    wire stop_id_mem_2;
    assign stop_id_mem_2 = ((id_rs2 == mem_RD) & mem_rf_WE & id_re2) &&id_rs2;
    wire stop_id_wb_1;
    assign stop_id_wb_1 = ((id_rs1 == wb_RD) & wb_rf_WE & id_re1) &&id_rs1;
    wire stop_id_wb_2;
    assign stop_id_wb_2 = ((id_rs2 == wb_RD) & wb_rf_WE & id_re2) &&id_rs2;
    
    assign stop = stop_id_ex_1 | stop_id_ex_2 | stop_id_mem_1 | stop_id_mem_2 | stop_id_wb_1 | stop_id_wb_2;
endmodule

