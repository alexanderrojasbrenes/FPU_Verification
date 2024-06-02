class arb_item extends uvm_sequence_item;

  //Add a sequence item definition
  
  // ******* Stimulus ******* //
  //rand integer iterations;
  integer iterations = 10;
  rand bit [1:0] operation_list []; 
  
  rand integer random_delay; 
  
  rand logic[31:0]  valueA;
  rand logic[31:0]  valueB;
  
  logic[31:0] p_inf = 32'h7F800000;
  logic[31:0] n_inf = 32'hff800000;
  logic[31:0] zero = 32'h00000000;
  
  constraint cst_valueA {valueA[30:23] < 137; valueA[30:23] > 133;}
  constraint cst_valueB {valueB[30:23] < 137; valueB[30:23] > 133;}
  
  //constraint cst_valueA {valueA[30:23] < 193; valueA[30:23] > 160;}
  //constraint cst_valueB {valueB[30:23] < 193; valueB[30:23] > 160;}
  
  //constraint cst_iterations {iterations < 50; iterations > 0;}
  constraint cst_operation_list {operation_list.size() == iterations;}
  constraint cst_random_delay {random_delay < 50; random_delay > 0;}
  
  // ******* Stimulus ******* //
  
  `uvm_object_utils_begin(arb_item)
  
  `uvm_object_utils_end

  function new(string name = "arb_item");
    super.new(name);
  endfunction
endclass




// Generador de items
class gen_item_seq extends uvm_sequence;
  `uvm_object_utils(gen_item_seq)
  function new(string name="gen_item_seq");
    super.new(name);
  endfunction

  rand int num; 	// Config total number of items to be sent

  constraint c1 { num inside {[2:5]}; } // numero de iteraciones

  virtual task body();
    arb_item f_item = arb_item::type_id::create("f_item"); // se crea el item desde la fábrica
    for (int i = 0; i < num; i ++) begin
        start_item(f_item);
    	f_item.randomize();
    	`uvm_info("SEQ", $sformatf("Generate new item: "), UVM_LOW)
    	f_item.print();
        finish_item(f_item);
      //`uvm_do(f_item); // hace los tres pasos en una sola línea 
    end
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask
endclass



class arb_driver extends uvm_driver #(arb_item); // se especifica eñ tipo de item que puede manejar

  `uvm_component_utils (arb_driver) // se mete la en fábrica
   function new (string name = "fifo_driver", uvm_component parent = null);
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
      //Drive tasks here // Se mantienen los task que ya teniamos en el primer proyecto
      fork
        //reset();
        addition(f_item);
        substraction(f_item);
        multiplication(f_item);
        division(f_item);
      join
      seq_item_port.item_done();
    end
  endtask
  
  task reset();  // Reset method
    //$display("Executing reset\n");
    @ (posedge intf.clk);
    intf.opa = 0;
    intf.opb = 0;
    intf.rmode = 0;
    intf.fpu_op = 0;
  endtask
  
  task addition(arb_item f_item);
    @(posedge intf.clk); // sincronizacion, no es un  "always"
    if(f_item.randomize()) 
    //$display("Executing addition\n");
    //$display("Driving valueA: %f in the DUT\n", $bitstoshortreal(valueA));
    //$display("Driving valueB: %f in the DUT\n", $bitstoshortreal(valueB)); 

    intf.rmode = 0;
    intf.fpu_op = 0;
    intf.opa = f_item.valueA;
    intf.opb = f_item.valueB;

    // Se guarda floatA + floatB en sb, pero en su representacion de IEEE 754
    //sb.store.push_front($shortrealtobits($bitstoshortreal(valueA) + $bitstoshortreal(valueB))); // Pasar los operandos al sb y hacer la operación ahí 
  endtask
  
  task substraction(arb_item f_item);
   @(posedge intf.clk); 
   if(f_item.randomize())
   //$display("Executing substraction\n");
   //$display("Driving valueA: %f in the DUT\n", $bitstoshortreal(valueA));
   //$display("Driving valueB: %f in the DUT\n", $bitstoshortreal(valueB));

   intf.rmode = 0;
   intf.fpu_op = 1;
   intf.opa = f_item.valueA;
   intf.opb = f_item.valueB;
   //sb.store.push_front($shortrealtobits($bitstoshortreal(valueA) - $bitstoshortreal(valueB)));
  endtask
  
  task multiplication(arb_item f_item);
    @(posedge intf.clk); 
    if(f_item.randomize())
    //$display("Executing multiplication\n");
    //$display("Driving valueA: %f in the DUT\n", $bitstoshortreal(valueA));
    //$display("Driving valueB: %f in the DUT\n", $bitstoshortreal(valueB));

    intf.rmode = 0;
    intf.fpu_op = 2;
    intf.opa = f_item.valueA;
    intf.opb = f_item.valueB;
    //sb.store.push_front($shortrealtobits($bitstoshortreal(valueA) * $bitstoshortreal(valueB)));
  endtask  
  
  task division(arb_item f_item);
    @ (posedge intf.clk); 
    if(f_item.randomize())
    //$display("Executing multiplication\n");
    //$display("Driving valueA: %f in the DUT\n", $bitstoshortreal(valueA));
    //$display("Driving valueB: %f in the DUT\n", $bitstoshortreal(valueB));

    intf.rmode = 0;
    intf.fpu_op = 3;
    intf.opa = f_item.valueA;
    intf.opb = f_item.valueB; 
    //sb.store.push_front($shortrealtobits($bitstoshortreal(valueA) / $bitstoshortreal(valueB)));
  endtask
  
  task random_operations(arb_item f_item);
    @ (posedge intf.clk);
    if(f_item.randomize())
    for (int i = 0; i < f_item.iterations; i++) //i hasta el número de iteraciones que se escogió
        begin
          if(f_item.operation_list[i] == 0) // suma
            begin
              addition(f_item);
              #f_item.random_delay;
            end

          else if(f_item.operation_list[i] == 1) // resta
            begin
              substraction(f_item); 
              #f_item.random_delay;
            end

          else if(f_item.operation_list[i] == 2) // multiplicación
            begin
              multiplication(f_item); 
              #f_item.random_delay;
            end

          else if(f_item.operation_list[i] == 3) // división
            begin
              division(f_item); 
              #f_item.random_delay;
            end  
        end
  endtask 
  
  /*
  task extreme_cases(integer op);
    sti = new();
    @ (posedge intf.clk); 
    if(sti.randomize()) 
      if(op == 0) // suma
        begin
          addition(sti.p_inf, sti.p_inf);
          #sti.random_delay;
        end

    else if(op == 1) // resta
      begin
        substraction(sti.n_inf, sti.p_inf); 
        #sti.random_delay;
      end

    else if(op == 2) // multiplicación
      begin
        multiplication(sti.valueA, sti.p_inf); 
        #sti.random_delay;
      end

    else if(op == 3) // división
      begin
        division(sti.valueA, sti.p_inf); 
        #sti.random_delay;
      end        	
  endtask
  */
  
endclass
