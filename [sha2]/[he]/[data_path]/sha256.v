// Macros defined for conciseness when dealing with difficul to read part-select operators;
`define WORD(SIGNAL, INDEX) \
  SIGNAL[255-32*(INDEX):224-32*(INDEX)]

`define H(INDEX) \
  WORD(h, INDEX)

module sha256(
  input [31:0] mgblk,
  output [255:0] h
  );
  
  // to be completed;
endmodule