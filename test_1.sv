class test_basic extends uvm_test; // se corren desde la linea de comandos

  `uvm_component_utils(test_basic) // pone el test en la fábrica
 
  function new (string name="test_basic", uvm_component parent=null); // constructor 
    super.new (name, parent);
  endfunction : new
  
  virtual arb_intf intf;
  arb_env env;  
  
  // build fase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      
   	// se revisa que la interfase está disponible
    if(uvm_config_db #(virtual arb_intf)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0)  
      begin
        `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
      end
      
    env  = arb_env::type_id::create ("env", this);

    // se setea la interfase para todo lo que sea top para abajo (utilizando el asterisco)
    uvm_config_db #(virtual arb_intf)::set (null, "uvm_test_top.*", "VIRTUAL_INTERFACE", intf); 
      
  endfunction
  
  // Se imprime toda la jeraquia 
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_report_info(get_full_name(),"End_of_elaboration", UVM_LOW);
    print();
    
  endfunction : end_of_elaboration_phase

  // Se instancia la secuencia en el test 
  gen_item_seq seq;

  //Run phase
  virtual task run_phase(uvm_phase phase);

    phase.raise_objection (this);

    // Creo la secuencia a través de la fábrica
    seq = gen_item_seq::type_id::create("seq");
    
    seq.randomize();
    seq.start(env.arb_seqr);
    
    phase.drop_objection (this);
  endtask

endclass
