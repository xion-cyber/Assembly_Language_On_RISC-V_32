module ALU(
    input [31:0]A,
    input [31:0]B,
    input [4:0]op,
    output reg [31:0]result,
    output reg branch
    );
    reg [31:0]temp;
    always@(*)
    begin
        case(op)
            4'b0000:begin//add or jal or jalr or lw or sw
                result = A + B;
            end    
            4'b0001:begin//sub
                result = A - B;
            end
            4'b0010:begin//and
                result = A & B;
            end
            4'b0011:begin//or
                result = A | B;
            end
            4'b0100:begin//xor
                result = A ^ B;
            end
            4'b0101:begin//sll
                temp = B[0]?{A[30:0],1'b0}:A;
                temp = B[1]?{temp[29:0],2'b0}:temp;
                temp = B[2]?{temp[27:0],4'b0}:temp;
                temp = B[3]?{temp[23:0],8'b0}:temp;
                temp = B[4]?{temp[15:0],16'b0}:temp;
                result =temp;
            end
            4'b0110:begin//srl
                temp = B[0]?{1'b0,A[31:1]}:A;
                temp = B[1]?{2'b0,temp[31:2]}:temp;
                temp = B[2]?{4'b0,temp[31:4]}:temp;
                temp = B[3]?{8'b0,temp[31:8]}:temp;
                temp = B[4]?{16'b0,temp[31:16]}:temp;
                result =temp;
            end
            4'b0111:begin//sra
                temp = B[0]?{A[31],A[31:1]}:A;
                temp = B[1]?{{2{temp[31]}},temp[31:2]}:temp;
                temp = B[2]?{{4{temp[31]}},temp[31:4]}:temp;
                temp = B[3]?{{8{temp[31]}},temp[31:8]}:temp;
                temp = B[4]?{{16{temp[31]}},temp[31:16]}:temp;
                result =temp;
            end
            4'b1000:begin//beq
                branch = (A == B)?1:0;
            end
            4'b1001:begin//bne
                branch = (A == B)?0:1;
            end
            4'b1010:begin//blt
                result = A-B;
                if(result[31]==1)
                    branch = 1;
                else
                    branch = 0;
            end
            4'b1011:begin///bge
                result = A-B;
                if(result[31]==1)
                    branch = 0;
                else
                    branch = 1;
            end
            4'b1100:begin//lui
                result = {B[19:0],{12{1'b0}}};
            end
            default : result = 1'b0;
        endcase
    end
endmodule
