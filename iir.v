module iir (
    input clk,
    reset_n,
    sleep,
    input signed [3:0] x,
    b0,
    b1,
    a1,
    output reg signed [7:0] y
);

  reg signed  [ 3:0] x_n_1;
  reg signed  [ 7:0] y_n_1;
  wire signed [ 7:0] y_next;
  wire signed [ 7:0] product_b0_x;
  wire signed [ 7:0] product_b1_x_n_1;
  wire signed [11:0] product_a1_y_n_1_full;
  wire signed [ 7:0] feedback_term_scaled;

  assign product_b0_x = b0 * x;
  assign product_b1_x_n_1 = b1 * x_n_1;
  assign product_a1_y_n_1_full = a1 * y_n_1;

  assign feedback_term_scaled = product_a1_y_n_1_full[11:4];

  always @(posedge clk, negedge reset_n) begin
    begin
      if (!reset_n) begin
        x_n_1 <= 4'd0;
        y_n_1 <= 8'd0;
      end else begin
        x_n_1 <= x;
        y_n_1 <= y;
      end
    end
  end
  always @(*) begin
    if (!sleep) begin
      y = product_b0_x + product_b1_x_n_1 + feedback_term_scaled;
    end
  end
endmodule
