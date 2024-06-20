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
    factory.set_type_override_by_name("gen_item_seq", "gen_item_seq2");

    // Print factory configuration
    factory.print();
  endfunction
endclass

// Generador de secuencias
class gen_item_seq2 extends gen_item_seq;
  `uvm_object_utils(gen_item_seq2)
  function new(string name="gen_item_seq2");
    super.new(name);
  endfunction

  virtual task body();   
    fpu_item f_item = fpu_item::type_id::create("f_item"); // se crea el item desde la fábrica
    
    // Caso 1: inf + inf = inf
    start_item(f_item);
    f_item.randomize() with {f_item.operation == 0; f_item.valueA2 == 32'h7F800000; f_item.valueB2 == 32'h7F800000;};
    f_item.valueA = f_item.valueA2; 
    f_item.valueB = f_item.valueB2;
    `uvm_info("SEQ", $sformatf("\n\n\nGenerate new item: "), UVM_LOW)
    f_item.print();
    finish_item(f_item);
   
    // Caso 2: -inf - inf = -inf
    start_item(f_item);
    f_item.randomize() with {f_item.operation == 1; f_item.valueA2 == 32'hff800000; f_item.valueB2 == 32'h7F800000;}; 
    f_item.valueA = f_item.valueA2; 
    f_item.valueB = f_item.valueB2;
    `uvm_info("SEQ", $sformatf("\n\n\nGenerate new item: "), UVM_LOW)
    f_item.print();
    finish_item(f_item);
   
    // Caso 3: n / [+-]inf = [+-]zero
    start_item(f_item);
    f_item.randomize() with {f_item.operation == 3; f_item.valueB2 == 32'h7F800000;}; 
    f_item.valueB = f_item.valueB2;
    `uvm_info("SEQ", $sformatf("\n\n\nGenerate new item: "), UVM_LOW)
    f_item.print();
    finish_item(f_item);
    
    // Caso 4: [+-]n x inf = [+-] inf
    start_item(f_item);
    f_item.randomize() with {f_item.operation == 2; f_item.valueB2 == 32'hff800000;}; 
    f_item.valueB = f_item.valueB2;
    `uvm_info("SEQ", $sformatf("\n\n\nGenerate new item: "), UVM_LOW)
    f_item.print();
    finish_item(f_item);
    
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask
endclass