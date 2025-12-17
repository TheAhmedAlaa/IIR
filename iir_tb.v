module iir_tb ();
  reg signed [3:0] a1, b1, b0, x;
  reg clk, reset_n;
  wire signed [7:0] y, y_exp;
  integer i, j;
  integer correct = 0;
  integer false = 0;
  iir DUT (
      .clk(clk),
      .reset_n(reset_n),
      .x(x),
      .b0(b0),
      .b1(b1),
      .a1(a1),
      .y(y)
  );
  IIR_golden_model GM (
      .clk(clk),
      .rst_n(reset_n),
      .x(x),
      .b0(b0),
      .b1(b1),
      .a1(a1),
      .y(y_exp)
  );
  initial begin
    clk = 0;
    forever begin
      #5 clk = !clk;
    end
  end
  initial begin
    b0 = 0;
    b1 = 0;
    a1 = 0;
    x = 0;
    reset_n = 0;
    @(negedge clk);
    reset_n = 1;
    @(negedge clk);
    //begin case 1
    x  = 5;
    b0 = 3;
    b1 = 0;
    a1 = 4;
    repeat (10) @(negedge clk);  //test case 1 //waiting for steady state
    x = 0;
    repeat (10) @(negedge clk);  //reseting x to 0 and y to 0
    //begin case 2
    x  = 5;
    b0 = 2;
    b1 = -2;
    a1 = -4;
    repeat (10) @(negedge clk);  //test case 2 waiting for steady state
    x = 0;
    repeat (10) @(negedge clk);  //reseting x to 0 and y to 0
    //begin of case 3
    x  = 5;
    b0 = 3;
    b1 = 3;
    a1 = 7;
    @(negedge clk);  //test case 3 waiting for steady state 
    x = 0;
    repeat (10) @(negedge clk);  //reseting x to 0 and y to 0
    //begin of case 4 
    b0 = 1;
    b1 = 1;
    a1 = 4;
    //the toggle between x=2 and x=6 for 10 clk cycles 
    for (i = 0; i < 10; i = i + 1) begin
      if (i % 2 == 0) begin
        x = 2;
      end else x = 6;
      @(negedge clk);
    end
    @(negedge clk);  //end of test case 4
    x = 0;
    repeat (10) @(negedge clk);  //reseting x to 0 and y to 0
    //begin of test case 5
    b0 = 7;
    b1 = 7;
    a1 = 6;
    x  = 7;
    repeat (10) @(negedge clk);  //waiting for steady state 
    //FOR EXTRA VERIFICATION BETWEEN GOLDEN MODEL AND DUT NOW TEST MORE RANDOM INPUTS
    for (j = 0; j < 100; j = j + 1) begin
      x = $random;
      b0 = $random;
      b1 = $random;
      a1 = $random;
      reset_n = $random;
      @(negedge clk);
    end
    $stop;
  end

  always @(posedge clk) begin
    if (y === y_exp) begin
      $display("****************************PASS*****************************");
      $display("Inputs:");
      $display("  x   = %0h", x);
      $display("  b0  = %0h", b0);
      $display("  b1  = %0h", b1);
      $display("  a1  = %0h", a1);
      $display("Outputs:");
      $display("  y       = %0h", y);
      $display("  expected= %0h", y_exp);
      $display("********************************");
      correct = correct + 1;
    end else begin
      $display("************* FAIL *************");
      $display("Inputs:");
      $display("  x   = %0h", x);
      $display("  b0  = %0h", b0);
      $display("  b1  = %0h", b1);
      $display("  a1  = %0h", a1);
      $display("Outputs:");
      $display("  y       = %0h", y);
      $display("  expected= %0h", y_exp);
      $display("********************************");
      false = false + 1;
    end
    $display("Correct_value=%0d", correct);
    $display("False_value=%0d", false);
  end
endmodule


