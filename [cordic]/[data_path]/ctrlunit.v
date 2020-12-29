module ctrlunit (
  input clk,
  input rst_b,
  input [3:0] itr,
  input bgn,
  output reg init,
  output reg ld,
  output reg fin
  );

  localparam WAIT_ST = 3'b001;
  localparam EXEC_ST = 3'b010;
  localparam END_ST = 3'b100;

  reg [2:0] st;
  reg [2:0] st_nxt;
  
  always @(*)
    case (st)
      WAIT_ST: if (bgn) st_nxt = EXEC_ST;
              else st_nxt = WAIT_ST;
      EXEC_ST: if (itr == 15) st_nxt = END_ST;
              else st_nxt = EXEC_ST;
      END_ST: st_nxt = WAIT_ST;
    endcase

  always @(*)
  begin
    {init, ld, fin} = 3'b0;
    case (st)
      WAIT_ST: if (bgn) begin init = 1'b1; ld = 1'b1; end
      EXEC_ST: ld = 1'b1;
      END_ST: fin = 1'b1;
    endcase
  end

  always @(posedge clk, negedge rst_b)
  begin
    if (!rst_b)
      st <= WAIT_ST;
    else
      st <= st_nxt;
  end
endmodule
