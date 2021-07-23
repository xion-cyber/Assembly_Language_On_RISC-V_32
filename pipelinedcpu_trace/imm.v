module imm(
    input [31:0]cur_pc,
    input [31:0]ins,
    input [2:0]imm_sel,
    output reg [31:0]imm_i
    );
    always@(*) begin
        if(imm_sel == 3'b000) begin//I-type
            imm_i = {{20{ins[31]}},ins[31:20]};
        end
        else if(imm_sel == 3'b001)begin//S-type
            imm_i = {{20{ins[31]}},ins[31:25],ins[11:7]};
        end
        else if(imm_sel == 3'b010)begin//B-type
            imm_i = {{19{ins[31]}},ins[31],ins[7],ins[30:25],ins[11:8],1'b0}+cur_pc;
        end
        else if(imm_sel == 3'b011)begin//U-type
            imm_i = {{12{1'b0}},ins[31:12]};
        end
        else if(imm_sel == 3'b100)begin//J-type
            imm_i = {{11{ins[31]}},ins[31],ins[19:12],ins[20],ins[30:21],1'b0}+cur_pc;
        end
        else begin
            imm_i = cur_pc;
        end
    end
endmodule
