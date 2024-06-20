// Sequence Item 
class arb_item extends uvm_sequence_item;
  rand integer random_delay;
  rand logic[1:0] operation;
  
  rand logic[31:0]  valueA; 
  rand logic[31:0]  valueB;
  
  rand logic[31:0]  valueA2; // Para el test 2
  rand logic[31:0]  valueB2; // Para el test 2
  
  logic[31:0]  out_at;			//FIXME: Crear sequence item solo para la salida  
  
  constraint infinity_bias_A {valueA2 inside {32'h7F800000, 32'hFF800000};}
  
  constraint infinity_bias_B {valueB2 inside {32'h7F800000, 32'hFF800000};}
  
  constraint cst_valueA {valueA[30:23] < 137; valueA[30:23] > 133;}
  constraint cst_valueB {valueB[30:23] < 137; valueB[30:23] > 133;}

  constraint cst_random_delay {random_delay < 12; random_delay > 4;}
  
  `uvm_object_utils_begin(arb_item)
  	`uvm_field_int (valueA, UVM_DEFAULT)
    `uvm_field_int (valueB, UVM_DEFAULT)
  	`uvm_field_int (valueA2, UVM_DEFAULT)
    `uvm_field_int (valueB2, UVM_DEFAULT)
    `uvm_field_int (random_delay, UVM_DEFAULT)
  	`uvm_field_int (operation, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "arb_item");
    super.new(name);
  endfunction
endclass

// Generador de secuencias
class gen_item_seq extends uvm_sequence;
  `uvm_object_utils(gen_item_seq)
  function new(string name="gen_item_seq");
    super.new(name);
  endfunction

  rand int num; 	// Config total number of items to be sent

  constraint c1 { num inside {[10:20]}; } // numero de iteraciones

  virtual task body();
    arb_item f_item = arb_item::type_id::create("f_item"); // se crea el item desde la fábrica
    for (int i = 0; i < num; i ++) begin
        start_item(f_item);
      
        f_item.randomize(); 
      
      `uvm_info("SEQ", $sformatf("\n\n\nGenerate new item: "), UVM_LOW)
    	f_item.print();
      
        finish_item(f_item);
    end
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask
endclass


// Driver 
class arb_driver extends uvm_driver #(arb_item); // se especifica eñ tipo de item que puede manejar

  `uvm_component_utils (arb_driver) // se mete la en fábrica
  function new (string name = "arb_driver", uvm_component parent = null);
    super.new (name, parent);
  endfunction

  virtual arb_intf intf;

  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    if(uvm_config_db #(virtual arb_intf)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) begin
      `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
    end
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
      arb_item f_item;
      
      `uvm_info("DRV", $sformatf("Wait for item from sequencer"), UVM_LOW)
      
      seq_item_port.get_next_item(f_item);
      
      // Se mantienen los task que ya teniamos en el primer proyecto
      fork
        drive_fpu(f_item);
      join
      
      seq_item_port.item_done();
    end
  endtask

  // Reset method
  task reset();  
    @ (posedge intf.clk);
    intf.opa = 0;
    intf.opb = 0;
    intf.rmode = 0;
    intf.fpu_op = 0;
  endtask


  task addition(arb_item f_item);
    @(posedge intf.clk); 
    intf.rmode = 0;
    intf.fpu_op = 0;
    intf.opa = f_item.valueA;
    intf.opb = f_item.valueB;
  endtask


  task substraction(arb_item f_item);
    @(posedge intf.clk); 
    intf.rmode = 0;
    intf.fpu_op = 1;
    intf.opa = f_item.valueA;
    intf.opb = f_item.valueB;
  endtask


  task multiplication(arb_item f_item);
    @(posedge intf.clk); 
    intf.rmode = 0;
    intf.fpu_op = 2;
    intf.opa = f_item.valueA;
    intf.opb = f_item.valueB;
  endtask  


  task division(arb_item f_item);
    @ (posedge intf.clk); 
    intf.rmode = 0;
    intf.fpu_op = 3;
    intf.opa = f_item.valueA;
    intf.opb = f_item.valueB; 
  endtask


  task drive_fpu(arb_item f_item);
    @ (posedge intf.clk);
    case (f_item.operation)
      0: addition(f_item);
      1: substraction(f_item);
      2: multiplication(f_item);
      3: division(f_item);
    endcase
    repeat (f_item.random_delay) @(posedge intf.clk);
  endtask 
endclass