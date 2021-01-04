module fsm (
  input clk,
  input rst_b,
  input A5,
  input I6,
  output reg u5,
  output reg u8,
  output reg O3,
  output reg O4
  );
  
  localparam S_D2 = 5'b00001;
  localparam S_K4 = 5'b00010;
  localparam S_U9 = 5'b00100;
  localparam S_A2 = 5'b01000;
  localparam S_R5 = 5'b10000;
  
  reg [4:0] st;
  reg [4:0] st_nxt;
  
  // combinational always block generating next state;
  always @(*)
  begin
    case (st)
      S_D2: if (~A5 && ~I6) st_nxt = S_U9;
            else st_nxt = S_A2; // same as (A5 || I6);
      S_K4: if (A5 && ~I6) st_nxt = S_D2;
            else st_nxt = S_U9; // same as (~A5 || I6);
      S_U9: if (A5 || ~I6) st_nxt = S_U9;
            else st_nxt = S_D2; // same as (~A5 && I6);
      S_A2: if (A5 || I6) st_nxt = S_A2;
            else st_nxt = S_D2; // same as (~A5 && ~I6);
      S_R5: if (~A5 || I6) st_nxt = S_A2;
            else st_nxt = S_D2; // same as (A5 && ~I6);
    endcase
  end
  
  // combinational always block generating output;
  always @(*)
  begin
    {u5, u8, O3, O4} = 4'b0000;
    case (st)
      S_D2: if (~A5 && ~I6) O3 = 1'b1;
            else {u5, u8, O3} = 3'b111;
      S_K4: if (~A5 || I6) {u5, u8, O3, O4} = 4'b1111;
      S_U9: u5 = 1'b1;
      S_A2: if (A5 || I6) {u5, u8, O3} = 3'b111;
      S_R5: if (~A5 || I6) u8 = 1'b1;
            else u5 = 1'b1;
    endcase
  end
  
  // sequential always block transitioning through states;
  always @(posedge clk, negedge rst_b)
  begin
    if (!rst_b)
      st <= S_D2;
    else
      st <= st_nxt;
  end
endmodule

module fsm_TB;
  reg clk;
  reg rst_b;
  reg A5;
  reg I6;
  wire u5;
  wire u8;
  wire O3;
  wire O4;
  
  localparam CLK_PERIOD = 100;
  localparam RUNNING_CYCLES = 24;
  localparam RST_DURATION = 150;
  
  // instancing UUT;
  fsm inst(.clk(clk), .rst_b(rst_b), .A5(A5), .I6(I6), .u5(u5), .u8(u8), .O3(O3), .O4(O4));
  
  // generating clock signal;
  initial
  begin
    clk = 1'b1;
    repeat (RUNNING_CYCLES*2) #(CLK_PERIOD/2) clk = ~clk;
  end
  
  // generating asynchronous reset signal;
  initial
  begin
    rst_b = 1'b0;
    #RST_DURATION rst_b = 1'b1;
  end
  
  // generating A5 signal;
  initial
  begin
    A5 = 1'b0;
    #(CLK_PERIOD*2) A5 = ~A5; // 1
    #(CLK_PERIOD/2) A5 = ~A5; // 0
    #(CLK_PERIOD/2) A5 = ~A5; // 1
    #(CLK_PERIOD/2) A5 = ~A5; // 0
    #(CLK_PERIOD) A5 = ~A5; // 1
    #(CLK_PERIOD/2) A5 = ~A5; // 0 
    #(CLK_PERIOD/2) A5 = ~A5; // 1 
    #(CLK_PERIOD) A5 = ~A5; // 0
    #(CLK_PERIOD) A5 = ~A5; // 1
    #(CLK_PERIOD) A5 = ~A5; // 0
    #(CLK_PERIOD) A5 = ~A5; // 1
    #(CLK_PERIOD/2) A5 = ~A5; // 0
    #(CLK_PERIOD) A5 = ~A5; // 1
    #(CLK_PERIOD/2) A5 = ~A5; // 0
    #(CLK_PERIOD*3/2) A5 = ~A5; // 1
    #(CLK_PERIOD*3/2) A5 = ~A5; // 0
    #(CLK_PERIOD/2) A5 = ~A5; // 1
    #(CLK_PERIOD/2) A5 = ~A5; // 0
    #(CLK_PERIOD/2) A5 = ~A5; // 1
    #(CLK_PERIOD*2) A5 = ~A5; // 0
    #(CLK_PERIOD) A5 = ~A5; // 1
    #(CLK_PERIOD*3/2) A5 = ~A5; // 0
    #(CLK_PERIOD/2) A5 = ~A5; // 1
    #(CLK_PERIOD*3/2) A5 = ~A5; // 0
    #(CLK_PERIOD/2) A5 = ~A5; // 1
    #(CLK_PERIOD/2) A5 = ~A5; // 0
  end
  
  // generating I6 signal;
  initial
  begin
    I6 = 1'b0;
    #(CLK_PERIOD*3/2) I6 = ~I6; // 1
    #(CLK_PERIOD*3/2) I6 = ~I6; // 0
    #(CLK_PERIOD) I6 = ~I6; // 1
    #(CLK_PERIOD/2) I6 = ~I6; // 0
    #(CLK_PERIOD) I6 = ~I6; // 1
    #(CLK_PERIOD*3/2) I6 = ~I6; // 0
    #(CLK_PERIOD/2) I6 = ~I6; // 1
    #(CLK_PERIOD/2) I6 = ~I6; // 0
    #(CLK_PERIOD/2) I6 = ~I6; // 1
    #(CLK_PERIOD*2) I6 = ~I6; // 0
    #(CLK_PERIOD) I6 = ~I6; // 1
    #(CLK_PERIOD*3/2) I6 = ~I6; // 0
    #(CLK_PERIOD/2) I6 = ~I6; // 1
    #(CLK_PERIOD/2) I6 = ~I6; // 0
    #(CLK_PERIOD/2) I6 = ~I6; // 1
    #(CLK_PERIOD*4) I6 = ~I6; // 0
    #(CLK_PERIOD/2) I6 = ~I6; // 1
    #(CLK_PERIOD*3/2) I6 = ~I6; // 0
    #(CLK_PERIOD) I6 = ~I6; // 1
    #(CLK_PERIOD/2) I6 = ~I6; // 0
    #(CLK_PERIOD/2) I6 = ~I6; // 1
    #(CLK_PERIOD) I6 = ~I6; // 0
  end
endmodule