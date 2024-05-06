module top();
  reg clk = 0;
  initial // clock generator
  forever #5 clk = ~clk;
   
  // Interface
  intf_cnt intf(clk);

  fpu uut(.clk(clk), 
          .rmode      (intf.rmode), 
          .fpu_op     (intf.fpu_op),
          .opa        (intf.opa), 
          .opb        (intf.opb), 
          .out        (intf.out), 
          .inf        (intf.inf),
          .snan       (intf.snan),
          .qnan       (intf.qnan), 
          .ine        (intf.ine),
          .overflow   (intf.overflow),
          .underflow  (intf.underflow),
          .zero       (intf.zero),
          .div_by_zero(intf.div_by_zero));

  initial begin
    $dumpfile("verilog.vcd");
    $dumpvars(0);
  end

  testcase test(intf);
endmodule
