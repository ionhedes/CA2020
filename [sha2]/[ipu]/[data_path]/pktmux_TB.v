module pktmux_TB;
  reg pad_pkt;
  reg zero_pkt;
  reg mgln_pkt;
  reg [63:0] pkt;
  reg [63:0] msg_len;
  wire [63:0] o;
  
  // instancing the unit under test module, pktmux;
  pktmux #(.w(64)) pktmux_inst(.pad_pkt(pad_pkt), .zero_pkt(zero_pkt), .mgln_pkt(mgln_pkt), .pkt(pkt), .msg_len(msg_len), .o(o));
  
  // monitoring the changes in the variables;
  initial
  begin
     $monitor("t=%3d, pad_pkt=%b, zero_pkt=%d, mgln_pkt=%b, o=%64b", $time, pad_pkt, zero_pkt, mgln_pkt, o);
  end
  
  // generating dummy values for the packet and message length ports;
  initial
  begin
    pkt = 45;
    msg_len = 64;
  end
  
  // generating all the possible combinations of entries;
  integer i; // must be declared outside the initial block, else the block must be named;
  initial
  begin
    {pad_pkt, zero_pkt, mgln_pkt} = 3'b0;
    for (i = 0; i < 4; i = i+1)
    begin
      # 25 {pad_pkt, zero_pkt, mgln_pkt} = (i == 3) ? (3'b0) : (1 << i);
    end
  end
endmodule