module prod (
  input clk,
  input rst_b,
  output reg val,
  output reg [7:0] data
  );

  /* pattern:
   * generating data for 3-5 clock cycles (valid signal high);
   * waiting for 1-4 clock cycles (valid signal low);
   */

  integer k;
  always @(posedge clk, negedge rst_b)
  begin
    if (rst_b == 0)
      begin
        val <= 0;
        data <= 0; // 8'b00000000;
        k <= 1;
    end
    else
    begin
      k <= k - 1;
      if (k == 1)
      begin
        if (val == 1)
        begin
          val <= 0;
          k <= $urandom_range(1, 4);
        end
        else
        begin
          val <= 1;
          k <= $urandom_range(3, 5);
        end
      end
      if (val == 1)
        data <= $urandom_range(0, 5);
    end
  end
endmodule
