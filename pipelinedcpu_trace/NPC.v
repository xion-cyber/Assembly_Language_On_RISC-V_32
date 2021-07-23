module NPC(
    input [31:0]cur_pc,         //��ǰָ���ַ
    input [1:0]pc_sel,          //ѡ��PC��ֵ�Ŀ����ź�
    input [31:0]pc_imm,         //ƫ����
    input branch,
    input Branch,
    input [31:0 ]rs1,
    output reg [31:0]next_pc,    //��ָ���ַ
    output reg jump
    );
always@(*)begin
    case(pc_sel)
        2'b00:begin
            next_pc = cur_pc+4;
            jump = 0;
        end
        2'b11:begin 
            next_pc = (pc_imm+rs1) & 32'hFFFFFFFE;
            jump = 1;
        end
        2'b01:begin
            if(Branch == 1 && branch == 1) begin
                next_pc = pc_imm;
                jump = 1;
            end
            else begin
                next_pc = cur_pc+4;
                jump = 0;
            end
        end
        2'b10:begin 
            next_pc = pc_imm;
            jump = 1;
        end
        default:next_pc = 0;
    endcase
end
endmodule