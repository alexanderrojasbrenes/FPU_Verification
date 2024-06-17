class fpu_env extends uvm_env;

  `uvm_component_utils(fpu_env)

  function new (string name = "fpu_env", uvm_component parent = null);
    super.new (name, parent);
  endfunction
  
  virtual arb_intf intf;
  
  // Se definen los agentes
  fpu_agent_active fpu_ag_active; 
  fpu_agent_passive fpu_ag_passive;
  
  // Se define el scoreboard
  fpu_scoreboard fpu_sb;		

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(uvm_config_db #(virtual arb_intf)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) begin
      `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
    end
    
    // se crean los tres objetos, dos agentes y scoreboard
    fpu_ag_active = fpu_agent_active::type_id::create ("fpu_ag_active", this);
    fpu_ag_passive = fpu_agent_passive::type_id::create ("fpu_ag_passive", this);
    fpu_sb = fpu_scoreboard::type_id::create ("fpu_sb", this);    
      
    uvm_report_info(get_full_name(),"End_of_build_phase", UVM_LOW);
    print();

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    // Conecta monitor del agente activo al modelo de referencia 
    fpu_ag_active.fpu_mntr_wr.mon_analysis_port.connect(fpu_sb.fpu_drv); 
    
    // Conecta el monitor del agente pasivo al scoreboard
    fpu_ag_passive.fpu_mntr_rd.mon_analysis_port.connect(fpu_sb.fpu_mon); 
  endfunction

endclass