class driver;
  stimulus sti;
  scoreboard sb;
 
  virtual intf_cnt intf;
        
  function new(virtual intf_cnt intf,scoreboard sb);
    this.intf = intf;
    this.sb = sb;
  endfunction
        
  task reset();  // Reset method
    $display("Executing reset\n");
    @ (posedge intf.clk);
    intf.opa = 0;
    intf.opb = 0;
    intf.rmode = 0;
    intf.fpu_op = 0;
  endtask
  
  task addition(logic [31:0] valueA, logic [31:0] valueB);
    sti = new();
    @ (posedge intf.clk); // sincronizacion, no es un  "always"
    if(sti.randomize()) // Generate stimulus: Se pone 'if' por que el randomize puede fallar si tiene constraints que no cumple
      $display("Executing addition\n");
      $display("Driving valueA: %f in the DUT\n", $bitstoshortreal(valueA));
      $display("Driving valueB: %f in the DUT\n", $bitstoshortreal(valueB)); 
      
      intf.rmode = 0;
      intf.fpu_op = 0;
      intf.opa = valueA;
      intf.opb = valueB;
    
      // Se guarda floatA + floatB en sb, pero en su representacion de IEEE 754
      sb.store.push_front($shortrealtobits($bitstoshortreal(valueA) + $bitstoshortreal(valueB))); 
  endtask
  
  task substraction(logic [31:0] valueA, logic [31:0] valueB);
    sti = new();
    @ (posedge intf.clk); 
    if(sti.randomize()) 
      $display("Executing substraction\n");
      $display("Driving valueA: %f in the DUT\n", $bitstoshortreal(valueA));
      $display("Driving valueB: %f in the DUT\n", $bitstoshortreal(valueB));
  
      intf.rmode = 0;
      intf.fpu_op = 1;
      intf.opa = valueA;
      intf.opb = valueB;
      sb.store.push_front($shortrealtobits($bitstoshortreal(valueA) - $bitstoshortreal(valueB)));
  endtask
  
  task multiplication(logic [31:0] valueA, logic [31:0] valueB);
    sti = new();
    @ (posedge intf.clk); 
    if(sti.randomize()) 
      $display("Executing multiplication\n");
      $display("Driving valueA: %f in the DUT\n", $bitstoshortreal(valueA));
      $display("Driving valueB: %f in the DUT\n", $bitstoshortreal(valueB));

      intf.rmode = 0;
      intf.fpu_op = 2;
      intf.opa = valueA; 
      intf.opb = valueB; 
      sb.store.push_front($shortrealtobits($bitstoshortreal(valueA) * $bitstoshortreal(valueB)));
  endtask  
  
  task division(logic [31:0] valueA, logic [31:0] valueB);
    sti = new();
    @ (posedge intf.clk); 
    if(sti.randomize()) 
    $display("Executing multiplication\n");
    $display("Driving valueA: %f in the DUT\n", $bitstoshortreal(valueA));
    $display("Driving valueB: %f in the DUT\n", $bitstoshortreal(valueB));

    intf.rmode = 0;
    intf.fpu_op = 3;
    intf.opa = valueA; 
    intf.opb = valueB; 
    sb.store.push_front($shortrealtobits($bitstoshortreal(valueA) / $bitstoshortreal(valueB)));
  endtask
  
  task random_operations();
    sti = new();
    @ (posedge intf.clk); 
    if(sti.randomize()) 
      
    for (int i; i < sti.iterations; i++) //i hasta el número de iteraciones que se escogió
    begin
      if(sti.operation_list[i] == 0) // suma
      begin
        addition(sti.valueA, sti.valueB);
        #sti.random_delay;
      end
      
      else if(sti.operation_list[i] == 1) // resta
      begin
        substraction(sti.valueA, sti.valueB); 
        #sti.random_delay;
      end
      
      else if(sti.operation_list[i] == 2) // multiplicación
      begin
        multiplication(sti.valueA, sti.valueB); 
        #sti.random_delay;
      end
      
      else if(sti.operation_list[i] == 3) // división
      begin
        division(sti.valueA, sti.valueB); 
        #sti.random_delay;
      end  
    end
  endtask 
  
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
endclass
