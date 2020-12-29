module cordicdpath (
  input clk,
  input rst_b,
  input [15:0] theta, // argument of cos;
  input bgn, // begin signal given by control path;
  output fin, // end signal given to control path;
  output [15:0] cos // container for cos approximation;
  );
  
  // auxilliary functions;
  function [15:0] Mux(input s, input [15:0] d1, d0);
    begin
      Mux = (s) ? d1 : d0;
     end
  endfunction
  
  function [15:0] AritShiftR(input [15:0] i, input [3:0] p);
    reg [31:0] t;
    begin
      t = {{16{i [15]}}, i} >> p;
      AritShiftR = t[15:0];
    end
  endfunction
  
  function [15:0] AddSub(input add, input [15:0] a, b);
    begin
      AddSub = Mux(add, a+b, a-b);
    end
  endfunction
  
  // necessary interconnections;
  wire [15:0] x; // container for the state variable x - holds the partial result of cos(theta);
  wire [15:0] y; // container for the state variable y;
  wire [15:0] z; // angular error between theta and the angle at the current iteration (given in radians);
  wire [15:0] atan; // container for the atan constant for the iteration in progress;
  
  // signals for interfacing with the data path controller;
  wire ld;
  wire init;
  wire [3:0] itr;
  
  // necessary instances;
  /*
   * 3x register - one for each state variable (X, Y, Z);
   * 3x 2-input multiplexers (simulated here using a function) - for loading the state variables in the initialization phase;
   * 3x AddSum modules (simulated here using a function) - for updating the state variables in every round;
   * 1x counter - for keeping track of the rounds;
   * 1x control unit for the data path - for controlling a cycle of 16 rounds (this is NOT the Control Path of the Cordic architecture, it just controls
   *                                                                           the internal process, after the Control Path activates the Data Path);
   * (you might want to ask why this is not the control path though);
   * 1x ROM module - for storing atan() constants;
   *
   * Note: for conciseness, the containers of the register instance ports incorporate Mux modules and AddSum modules;
   */
  rgst #(.w(16)) rgst_instx(.clk(clk), .rst_b(rst_b), .ld(ld), .clr(1'd0), .q(x), .d(Mux(init, 16'h26dd, AddSub(z [15], x, AritShiftR(y, itr)))));
  rgst #(.w(16)) rgst_insty(.clk(clk), .rst_b(rst_b), .ld(ld), .clr(1'd0), .q(y), .d(Mux(init, 16'h0, AddSub(~z [15], y, AritShiftR(x,itr)))));
  rgst #(.w(16)) rgst_instz(.clk(clk), .rst_b(rst_b), .ld(ld), .clr(1'd0), .q(z), .d(Mux(init, theta, AddSub(z [15], z, atan))));
  cntr #(.w(4))  cntr_inst(.clk(clk), .rst_b(rst_b), .clr(init), .c_up(ld & ~init), .q(itr));
  rom #(.aw(4), .dw(16), .file("atan_cst.txt")) rom_inst(.clk(clk), .rst_b(rst_b), .addr(itr), .data(atan));
  ctrlunit ctrlunit_inst(.clk(clk), .rst_b(rst_b), .itr(itr), .bgn(bgn), .init(init), .ld(ld), .fin(fin));
  
  assign cos = x;
endmodule