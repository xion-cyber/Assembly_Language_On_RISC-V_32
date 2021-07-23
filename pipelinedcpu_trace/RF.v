module RF(
        input clk,          //clock
        input reset,
        input [4:0] rR1,    //rs1地址
        input [4:0] rR2,    //rs2地址
        input [4:0] wR,     //rd地址
        input WE,
        input [31:0] wD,    //rd数据
        output  [31:0] rD1,  //rs1数据
        output  [31:0] rD2   //rs2数据
    );
    reg [31:0] regfile[0:31];

    assign rD1 = regfile[rR1];
    assign rD2 = regfile[rR2];
    
    always @ (posedge clk or negedge reset)begin
    if(reset == 1)begin
        if(WE == 1'b1)begin
            if(wR == 0)
                regfile[0] <= 32'd0;
            else
                regfile[wR] <= wD;
        end
        else begin
            regfile[wR] <= regfile[wR];
            regfile[0]<= 0;
        end
    end
    end
 endmodule