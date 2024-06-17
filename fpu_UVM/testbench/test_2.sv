class test_basic2 extends test_basic;

  `uvm_component_utils(test_basic2)
  
  function new (string name="test_basic2", uvm_component parent=null);
    super.new (name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
  	 
     // Get handle to the singleton factory instance
    uvm_factory factory = uvm_factory::get();
    
    super.build_phase(phase);
    
    //factory to override 'base_agent' by 'child_agent' by name
    factory.set_type_override_by_name("arb_item", "arb_item2");

    // Print factory configuration
    factory.print();
  endfunction
endclass


// Sequence Item 
class arb_item2 extends uvm_sequence_item;
  rand integer random_delay;
  rand logic[1:0] operation;
  //rand logic[1:0] rmode_at;
  
  logic[31:0]  valueA;
  logic[31:0]  valueB;
  
  rand logic[31:0]  vA;
  rand logic[31:0]  vB;
  
  logic[31:0] p_inf = 32'h7F800000;
  logic[31:0] n_inf = 32'hff800000;
  logic[31:0] zero = 32'h00000000;
  
  constraint distribution {
    vA dist {p_inf :/ 90,  vA :/ 10};
  };
  
  logic[31:0]  out_at;	//FIXME: Crear sequence item solo para la salida  
  
  //constraint cst_valueA {vA[30:23] < 137; vA[30:23] > 133;}
  constraint cst_valueB {vB[30:23] < 137; vB[30:23] > 133;}

  constraint cst_random_delay {random_delay < 12; random_delay > 4;}
  
  `uvm_object_utils_begin(arb_item2)
  	`uvm_field_int (vA, UVM_DEFAULT)
    `uvm_field_int (vB, UVM_DEFAULT)
    `uvm_field_int (random_delay, UVM_DEFAULT)
  	`uvm_field_int(operation, UVM_DEFAULT)
  `uvm_object_utils_end
 
  function new(string name = "arb_item2");
    super.new(name);
  endfunction
endclass