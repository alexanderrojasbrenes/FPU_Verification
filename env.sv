class arb_env extends uvm_env;

  `uvm_component_utils(arb_env)

  function new (string name = "fifo_env", uvm_component parent = null);
    super.new (name, parent);
  endfunction
  
  virtual arb_intf intf;
  arb_driver arb_drv; // driver
  uvm_sequencer #(arb_item)	arb_seqr; //seqr
  

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // se revisa que la interfase está disponible
    if(uvm_config_db #(virtual arb_intf)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) 
      begin
      `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
    end
    
    // Creacion de un arbitro en la fábrica
    arb_drv = arb_driver::type_id::create ("arb_drv", this); 
    
    // Creacion de un seqr en la fábrica
    arb_seqr = uvm_sequencer#(arb_item)::type_id::create("arb_seqr", this);
    
    
    //uvm_config_db #(virtual fifo_intf)::set (null, "uvm_test_top.*", "VIRTUAL_INTERFACE", intf);    
      
    uvm_report_info(get_full_name(),"End_of_build_phase", UVM_LOW);
    print();

  endfunction

  // Connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    // 	Conexion entre los puertos del driver (seq_item_port) y el del seqr (seq_item_export)
    arb_drv.seq_item_port.connect(arb_seqr.seq_item_export);
  endfunction

endclass