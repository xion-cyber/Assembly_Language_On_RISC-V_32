module PC(
    input clk,              //clock
    input reset,            //��λ
    input [31:0]next_pc,  //��ָ���ַ
    output reg [31:0]cur_pc,    //��ָ���ַ
    input stop,
    input jump
    );

always@(posedge clk or negedge reset)
begin
    if(!reset)
        begin
            cur_pc <= 32'h0000_0000;
        end    
    else
        begin
            if(jump) begin
                cur_pc <= next_pc;
            end    
            else if(stop)
                cur_pc <= cur_pc;
            else begin
                cur_pc <= cur_pc+4;
            end
        end
end    
endmodule

