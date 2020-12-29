module pktmux #(
  parameter w = 64
  )(
  input pad_pkt,
  input zero_pkt,
  input mgln_pkt,
  input [w-1:0] pkt,
  input [w-1:0] msg_len,
  output reg [w-1:0] o
  );
  
  localparam PAD_PKT = {1'b1, {(w-1){1'b0}}};
  localparam ZERO_PKT = {w{1'b0}};
  
  always @(*)
  begin
    if (pad_pkt)
      o = PAD_PKT;
    else if (zero_pkt)
      o = ZERO_PKT;
    else if (mgln_pkt)
      o = msg_len;
    else
      o = pkt;
  end
endmodule