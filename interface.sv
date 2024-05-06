interface intf_cnt(input clk);
  
  logic [1:0]	rmode;
  logic [2:0]	fpu_op;
  logic [31:0]	opa, opb;
  logic [31:0]	out;
  logic inf, snan, qnan;
  logic ine;
  logic overflow, underflow;
  logic zero;
  logic div_by_zero; 

endinterface
