module sha2ipucpath(
  input clk,
  input rst_b,
  input lst_pkt, // signal from the message deliverer when a new message is available;
  input [2:0] idx, // signal from the data path signifying what is the NEXT write location in the register file;
  output reg st_pkt, // signals the data path to store the current packet, given by the message delivere;
  output reg pad_pkt, // signals the data path to store a pad packet;
  output reg zero_pkt, // signals the data path to store a zero packet;
  output reg mgln_pkt, // signals the data path to store a message length packet;
  output reg blk_val, // signals the Hash engine when a new block is available;
  output reg msg_end // signals the Hash engine when the message was fully transmitted;
  );
  
  // the control path of the IPU can be described as a Mealy FSM;
  
  // defining constants for states;
  localparam START_ST = 7'b0000001;
  localparam RX_PKT_ST = 7'b0000010;
  localparam PAD_ST = 7'b0000100;
  localparam ZERO_ST = 7'b0001000;
  localparam MGLN_ST = 7'b0010000;
  localparam MSG_END_ST = 7'b0100000;
  localparam STOP_ST = 7'b1000000;
  
  
  // defining state transitions;
  reg [6:0] st;
  reg [6:0] st_nxt;
  
  always @(*)
    case (st)
      START_ST:
        if (lst_pkt) st_nxt = PAD_ST;
        else st_nxt = RX_PKT_ST;
      RX_PKT_ST:
        if (lst_pkt) st_nxt = PAD_ST;
        else st_nxt = RX_PKT_ST;
      PAD_ST:
        if (idx != 7) st_nxt = ZERO_ST;
        else st_nxt = MGLN_ST;
      ZERO_ST:
        if (idx != 7) st_nxt = ZERO_ST;
        else st_nxt = MGLN_ST;
      MGLN_ST:
        st_nxt = MSG_END_ST;
      MSG_END_ST:
        st_nxt = STOP_ST;
      STOP_ST:
        st_nxt = STOP_ST;
    endcase
  
  // defining outputs for every (state, input) combination;
  /** 
  * some outputs don't depend on the input, only on the current state and are set as soon as the machine enters the corresponding state;
  * that is why, when reaching PAD_ST, ZERO_ST or MGLN_ST, the appropriate outputs are instantly set and corresponding packet is added to the register file,
  * making idx point to the next write location;
  * the packet outputs will still retain their value until the next clock cycle though, so do not get confused about why these outputs seem delayed or just seem to mess up with you;
  **/
  always @(*)
  begin
    {st_pkt, pad_pkt, zero_pkt, mgln_pkt, blk_val, msg_end} = 0;
    case (st)
      START_ST:
        st_pkt = 1'b1;
      RX_PKT_ST:
      begin
        st_pkt = 1'b1;
        if (idx == 0) blk_val = 1'b1;
      end
      PAD_ST:
      begin
        st_pkt = 1'b1;
        pad_pkt = 1'b1;
        if (idx == 0) blk_val = 1'b1;
      end
      ZERO_ST:
      begin
        zero_pkt = 1'b1;
        st_pkt = 1'b1;
      end
      MGLN_ST:
      begin
        mgln_pkt = 1'b1;
        st_pkt = 1'b1;
      end
      MSG_END_ST:
      begin
        blk_val = 1'b1;
        msg_end = 1'b1;
      end
      STOP_ST:
      begin
        // no output is activated here;
      end
    endcase
  end
  
  // moving machine to next state;
  always @ (posedge clk, negedge rst_b)
  begin
    if (!rst_b)
      st <= START_ST;
    else
      st <= st_nxt;
  end
endmodule 
    