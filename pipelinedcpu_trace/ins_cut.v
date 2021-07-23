module ins_cut(
    input [31:0] ins,
    output reg [6:0] opcode,
    output reg [2:0] func3,
    output reg [6:0] func7,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [4:0] rd,
    input jump
    );
    always@(*) begin
    if(jump)begin
        opcode = 7'b0;
        func3 = 3'b0;
        func7 = 7'b0;
        rs1 = 5'b0;
        rs2 = 5'b0;
        rd = 5'b0;        
    end
    else begin
        if(ins[6:0] == 7'b0110011) begin//R-type
            opcode = 7'b0110011;
            func3 = ins[14:12];
            func7 = ins[31:25];
            rs1 = ins[19:15];
            rs2 = ins[24:20];
            rd = ins[11:7];
        end
        else if(ins[6:0] == 7'b0010011 || ins[6:0] == 7'b0000011 || ins[6:0] == 7'b1100111) begin//I-type
            opcode = ins[6:0];
            func7 = ins[31:25];
            func3 = ins[14:12];
            rs1 = ins[19:15];
            rd = ins[11:7];
        end
        else if(ins[6:0] == 7'b0100011)begin//S-type
            opcode = 7'b0100011;
            func3 = ins[14:12];
            rs1 = ins[19:15];
            rs2 = ins[24:20];
        end
        else if(ins[6:0] == 7'b1100011)begin//B-type
            opcode = 7'b1100011;
            func3 = ins[14:12];
            rs1 = ins[19:15];
            rs2 = ins[24:20];
        end
        else if(ins[6:0] == 7'b0110111)begin//U-type
            opcode = 7'b0110111;
            rd = ins[11:7];
        end
         else if(ins[6:0] == 7'b1101111)begin//J-type
            opcode = 7'b1101111;
            rd = ins[11:7];
        end
    end
    end
endmodule
