class fpu_agent_active extends uvm_agent;
  `uvm_component_utils(fpu_agent_active)
  
  function new(string name="fpu_agent_active", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  // el agente activo tiene secuencer, driver y monitor
  virtual fpu_intf intf;
  fpu_driver fpu_drv;
  uvm_sequencer #(fpu_item)	fpu_seqr;
  fpu_monitor_wr fpu_mntr_wr;

  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(uvm_config_db #(virtual fpu_intf)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) begin
      `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
    end
    
    fpu_drv = fpu_driver::type_id::create ("fpu_drv", this); 
    
    fpu_seqr = uvm_sequencer#(fpu_item)::type_id::create("fpu_seqr", this);
    
    fpu_mntr_wr = fpu_monitor_wr::type_id::create ("fpu_mntr_wr", this);  
  endfunction
  
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    fpu_drv.seq_item_port.connect(fpu_seqr.seq_item_export); // se conecta sequencer y driver, con puerto implicito 
  endfunction
endclass


// el agente pasivo solo tiene el monitor
class fpu_agent_passive extends uvm_agent;
  `uvm_component_utils(fpu_agent_passive)
  
  
  function new(string name="fpu_agent_passive", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual fpu_intf intf;
  fpu_monitor_rd fpu_mntr_rd;
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(uvm_config_db #(virtual fpu_intf)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) begin
      `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
    end
    
    fpu_mntr_rd = fpu_monitor_rd::type_id::create ("fpu_mntr_rd", this);  
  endfunction

  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

endclass