module reg_if_id(
    input clk,
    input reset,
    input [31:0]if_pc,
    input [31:0]if_inst,
    output reg [31:0]id_pc,
    output reg [31:0]id_inst,
    input stop,
    input jump,
    output reg id_have_inst
    );
    always @(posedge clk or negedge reset) begin
        if(~reset | jump)
            id_pc <= 32'b0;
        else if(stop)
            id_pc <= id_pc;
        else
            id_pc <= if_pc;
    end
    
    always @(posedge clk or negedge reset) begin
        if(~reset | jump)
            id_inst <= 32'b0;
        else if(stop)
            id_inst <= id_inst;
        else
            id_inst <= if_inst;
    end
    
    always @(posedge clk or negedge reset) begin
        if(~reset | jump)
            id_have_inst <= 32'b0;
        else if(stop)
            id_have_inst <= id_have_inst;
        else
            id_have_inst <= 1;
    end
endmodule
