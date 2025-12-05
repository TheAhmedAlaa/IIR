module IIR_golden_model ( clk, rst_n, sleep, x, a1, b0, b1, y );

    input clk, rst_n, sleep ;
    input signed [3:0] x, a1, b0, b1 ;
    output reg signed [7:0] y ;

    reg signed [3:0] x_reg ;
    wire signed [7:0] x_b0 ;
    wire signed [7:0] x_reg_b1 ;
    reg signed [7:0] y_reg ;
    wire signed [7:0] y_reg_a1_excluding_4_LSBs ;
    wire signed [11:0] y_reg_a1 ;

        always @(posedge clk or negedge rst_n) begin
            if (~ rst_n) begin
                x_reg <= 0 ;
                y_reg <= 0 ;
            end 
            else begin
                x_reg <= x ;
                y_reg <= y ;
            end
        end

        always @(*) begin
            if (~sleep) begin
                y = x_b0 + x_reg_b1 + y_reg_a1_excluding_4_LSBs  ;
            end 
        end


    assign x_b0 = x * b0 ;
    assign x_reg_b1 = x_reg * b1 ;
    assign y_reg_a1 = y_reg * a1 ;
    assign y_reg_a1_excluding_4_LSBs = y_reg_a1 [11:4] ;
    
endmodule