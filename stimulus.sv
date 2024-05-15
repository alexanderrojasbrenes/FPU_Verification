class stimulus;
  
  //rand integer iterations;
  integer iterations = 20;
  rand bit [1:0] operation_list []; 
  
  rand integer random_delay; 
  
  rand logic[31:0]  valueA;
  rand logic[31:0]  valueB;
  
  logic[31:0] p_inf = 32'h7F800000;
  logic[31:0] n_inf = 32'hff800000;
  logic[31:0] zero = 32'h00000000;
  
  constraint cst_valueA {valueA[30:23] < 137; valueA[30:23] > 133;}
  constraint cst_valueB {valueB[30:23] < 137; valueB[30:23] > 133;}
  
  //constraint cst_iterations {iterations < 50; iterations > 0;}
  constraint cst_operation_list {operation_list.size() == iterations;}
  constraint cst_random_delay {random_delay < 50; random_delay > 0;}

endclass
