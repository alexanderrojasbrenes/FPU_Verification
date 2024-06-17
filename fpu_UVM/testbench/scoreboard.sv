`uvm_analysis_imp_decl( _drv )
`uvm_analysis_imp_decl( _mon ) 

class fpu_scoreboard extends uvm_scoreboard;
    `uvm_component_utils (fpu_scoreboard)

    function new (string name, uvm_component parent=null);
		super.new (name, parent);
	endfunction
  
	// puertos de acceso al scoreboard de tipo 
  	uvm_analysis_imp_drv #(arb_item, fpu_scoreboard) fpu_drv;
  	uvm_analysis_imp_mon #(arb_item, fpu_scoreboard) fpu_mon;
  
	// modelo de referencia de la fpu
  	logic [31:0] ref_model [$];  
  
	function void build_phase (uvm_phase phase);
      fpu_drv = new ("fpu_drv", this);
      fpu_mon = new ("fpu_mon", this);
	endfunction
  
	//push
    // Recibe la información generada en el Driver y se encarga de predecir el valor de la operación
  	virtual function void write_drv (arb_item item);
      case (item.operation)
        0: 
          item.out_at = $shortrealtobits($bitstoshortreal(item.valueA) + $bitstoshortreal(item.valueB)); 
        1: 
          item.out_at = $shortrealtobits($bitstoshortreal(item.valueA) - $bitstoshortreal(item.valueB)); 
        2: 
          item.out_at = $shortrealtobits($bitstoshortreal(item.valueA) * $bitstoshortreal(item.valueB)); 
        3: 
          item.out_at = $shortrealtobits($bitstoshortreal(item.valueA) / $bitstoshortreal(item.valueB)); 
      endcase
      
      `uvm_info ("sb", $sformatf("Data received = 0x%0h", item.out_at), UVM_LOW)
      ref_model.push_back(item.out_at);
	endfunction
  
  	// Revisa el valor obtenido en el DUT con el del modelo de referencia 
    virtual function void write_mon (arb_item item);
      `uvm_info ("sb", $sformatf("Data received = 0x%0h", item.out_at), UVM_LOW)
    
      if (item.out_at !== ref_model.pop_front()) begin
      	`uvm_error("SB error", "Data mismatch");
      end 
      
      else begin 
        `uvm_info("SB PASS", $sformatf("Data received = 0x%0h", item.out_at), UVM_LOW);
      end 
    endfunction

	virtual task run_phase (uvm_phase phase);
		
	endtask

	virtual function void check_phase (uvm_phase phase);

	endfunction
endclass