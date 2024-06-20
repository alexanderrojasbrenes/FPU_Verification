import uvm_pkg::*;

module top_hdl();
  reg clk = 0;
  initial // clock generator
  forever #5 clk = ~clk;
   
  // Interface
  fpu_intf intf(clk);
  
  // DUT connection
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
  
  //FPU instance goes here

initial begin
  $dumpfile("dump.vcd"); 
  $dumpvars;
   
  uvm_config_db #(virtual fpu_intf)::set (null, "uvm_test_top", "VIRTUAL_INTERFACE", intf);
  	
end
  
endmodule