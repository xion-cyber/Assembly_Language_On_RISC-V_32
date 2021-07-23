module controlunit(
    input [6:0]opcode,
    input [2:0]func3,
    input [6:0]func7,
    output reg [1:0] npc_op,
    output reg rf_we,
    output reg [3:0]alu_op,
    output reg alub_sel,
    output reg Branch,
    output reg [2:0]imm_sel,
    output reg dram_we,
    output reg j_type,
    output reg mem2reg,
    output reg id_re1,
    output reg id_re2,
    input jump
    );
    always@(*)begin
    if(jump)begin
        npc_op = 2'b00;
        rf_we = 1'b0;
        alub_sel = 1'b0;
        Branch = 1'b0;
        dram_we = 1'b0;
        mem2reg = 1'b0;
        j_type = 1'b0;
        id_re1 = 1'b0;
        id_re2 = 1'b0;
        alu_op = 4'b0000;
    end
    else begin
        if(opcode == 7'b0110011)begin//R-type
            npc_op = 2'b00;
            rf_we = 1'b1;
            alub_sel = 1'b1;
            Branch = 1'b0;
            dram_we = 1'b0;
            mem2reg = 1'b0;
            j_type = 1'b0;
            id_re1 = 1'b1;
            id_re2 = 1'b1;
            case(func3)
                3'b000: begin//add
                    case(func7)
                        7'b0000000:begin
                            alu_op = 4'b0000;
                        end
                        7'b0100000:begin
                            alu_op = 4'b0001;
                        end
                    endcase
                end
                3'b111:begin//and
                    alu_op = 4'b0010;
                end
                3'b110:begin//or
                    alu_op = 4'b0011;
                end
                3'b100:begin//xor
                    alu_op = 4'b0100;
                end
                3'b001:begin//sll
                    alu_op = 4'b0101;
                end
                3'b101:begin
                    case(func7)
                        7'b0000000:begin//srl
                            alu_op = 4'b0110;
                        end
                        7'b0100000:begin//sra
                            alu_op = 4'b0111;
                        end
                    endcase
                end
            endcase
        end
        else if(opcode == 7'b0010011) begin//I-type
            npc_op = 2'b00;
            rf_we = 1'b1;
            imm_sel = 3'b000;
            alub_sel = 1'b0;
            Branch = 1'b0;
            dram_we = 1'b0;  
            mem2reg = 1'b0;
            j_type = 1'b0;  
            id_re1 = 1'b1;
            id_re2 = 1'b0;  
            case(func3)
                3'b000: begin//add
                    alu_op = 4'b0000;
                end
                3'b111:begin//and
                    alu_op = 4'b0010;
                end
                3'b110:begin//or
                    alu_op = 4'b0011;
                end
                3'b100:begin
                    alu_op = 4'b0100;
                end
                3'b001:begin
                    alu_op = 4'b0101;
                end
                3'b101:begin
                    case(func7)
                        7'b0000000:begin
                            alu_op = 4'b0110;
                        end
                        7'b0100000:begin
                            alu_op = 4'b0111;
                        end
                    endcase
                end
            endcase
        end
        else if(opcode == 7'b0000011) begin//lw
            npc_op = 2'b00;
            rf_we = 1'b1;
            imm_sel = 2'b000;
            alub_sel = 1'b0;
            Branch = 1'b0;
            alu_op = 4'b0000;
            dram_we = 1'b0;
            mem2reg = 1'b1;
            j_type = 1'b0;
            id_re1 = 1'b1;
            id_re2 = 1'b0;
        end
        else if(opcode == 7'b1100111) begin//jalr
            npc_op = 2'b11;
            rf_we = 1'b1;
            imm_sel = 2'b000;
            alub_sel = 1'b0;
            Branch = 1'b0;
            alu_op = 4'b0000;
            dram_we = 1'b0;    
            j_type = 1'b1;
            id_re1 = 1'b1;
            id_re2 = 1'b0;        
        end
        else if(opcode == 7'b0100011) begin//sw
            npc_op = 2'b00;
            rf_we = 1'b0;
            imm_sel = 3'b001;
            alub_sel = 1'b0;
            Branch = 1'b0;
            alu_op = 4'b0000;
            dram_we = 1'b1; 
            mem2reg = 1'b1; 
            j_type = 1'b0;    
            id_re1 = 1'b1;
            id_re2 = 1'b1;      
        end
        else if(opcode == 7'b1100011) begin//B-type
            npc_op = 2'b01;
            rf_we = 1'b0;
            imm_sel = 3'b010;
            alub_sel = 1'b1;
            Branch = 1'b1;
            dram_we = 1'b0;
            id_re1 = 1'b1;
            id_re2 = 1'b1;
            case(func3)
                3'b000:begin//beq
                    alu_op = 4'b1000;
                end
                3'b001:begin//bne
                    alu_op = 4'b1001;
                end
                3'b100:begin//blt
                    alu_op = 4'b1010;
                end
                3'b101:begin//bge
                    alu_op = 4'b1011;
                end
                default:alu_op = 4'b0000;
            endcase
        end
        else if(opcode == 7'b0110111) begin//lui
            npc_op = 2'b00;
            rf_we = 1'b1;
            imm_sel = 3'b011;
            Branch = 1'b0;
            dram_we = 1'b0;
            alu_op = 4'b1100;
            mem2reg = 1'b0;
            alub_sel = 1'b0;
            j_type = 1'b0;
            id_re1 = 1'b0;
            id_re2 = 1'b0;
        end
        else if(opcode == 7'b1101111) begin//jal
            npc_op = 2'b10;
            rf_we = 1'b1;
            imm_sel = 3'b100;
            Branch = 1'b0;
            dram_we = 1'b0;
            alu_op = 4'b0000;
            alub_sel = 1'b0;
            j_type = 1'b1; 
            id_re1 = 1'b0;
            id_re2 = 1'b0;
        end
    end
    end  
endmodule
