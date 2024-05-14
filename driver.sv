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
  
  
  task addition();
      sti = new();
      @ (posedge intf.clk); // sincronizacion, no es un  "always"
      if(sti.randomize()) // Generate stimulus Se pone 'if' por que el randomize puede fallar si tiene constraints que no cumple
        $display("Executing addition\n");
        $display("Driving 0x%d valueA in the DUT\n", sti.valueA[30:23]);
        $display("	as float: %f valueA in the DUT\n", $bitstoshortreal(sti.valueA)); // convierte el valorA de 32 bits a un flotante
        $display("Driving 0x%d valueB in the DUT\n", sti.valueB[30:23]);
      	$display("	as float: %f valueB in the DUT\n", $bitstoshortreal(sti.valueB));
        
        intf.rmode = 0;
       	intf.fpu_op = 0;
        intf.opa = sti.valueA;
        intf.opb = sti.valueB;
      
      // Se guarda floatA + floatB en sb, pero en su representacion de IEEE 754
      sb.store.push_front($shortrealtobits($bitstoshortreal(sti.valueA) + $bitstoshortreal(sti.valueB))); 
  endtask
  
  
  task substraction();
      sti = new();
      @ (posedge intf.clk); 
      if(sti.randomize()) 
        $display("Executing substraction\n");
      	$display("Driving 0x%d valueA in the DUT\n", sti.valueA[30:23]);
        $display("	as float: %f valueA in the DUT\n", $bitstoshortreal(sti.valueA));

        $display("Driving 0x%d valueB in the DUT\n", sti.valueB[30:23]);
      	$display("	as float: %f valueB in the DUT\n", $bitstoshortreal(sti.valueB));

        intf.rmode = 0;
        intf.fpu_op = 1;
        intf.opa = sti.valueA; 
        intf.opb = sti.valueB; 
        sb.store.push_front($shortrealtobits($bitstoshortreal(sti.valueA) - $bitstoshortreal(sti.valueB)));
  endtask
  
  
  task multiplication();
      sti = new();
      @ (posedge intf.clk); 
      if(sti.randomize()) 
        $display("Executing multiplication\n");
      	$display("Driving 0x%d valueA in the DUT\n", sti.valueA[30:23]);
        $display("	as float: %f valueA in the DUT\n", $bitstoshortreal(sti.valueA));

        $display("Driving 0x%d valueB in the DUT\n", sti.valueB[30:23]);
      	$display("	as float: %f valueB in the DUT\n", $bitstoshortreal(sti.valueB));

        intf.rmode = 0;
      	intf.fpu_op = 2;
        intf.opa = sti.valueA; 
        intf.opb = sti.valueB; 
        sb.store.push_front($shortrealtobits($bitstoshortreal(sti.valueA) * $bitstoshortreal(sti.valueB)));
  endtask
      
  
  task division();
        sti = new();
        @ (posedge intf.clk); 
        if(sti.randomize()) 
        $display("Executing multiplication\n");
      	$display("Driving 0x%d valueA in the DUT\n", sti.valueA[30:23]);
        $display("	as float: %f valueA in the DUT\n", $bitstoshortreal(sti.valueA));

        $display("Driving 0x%d valueB in the DUT\n", sti.valueB[30:23]);
      	$display("	as float: %f valueB in the DUT\n", $bitstoshortreal(sti.valueB));

        intf.rmode = 0;
      	intf.fpu_op = 3;
        intf.opa = sti.valueA; 
        intf.opb = sti.valueB; 
        sb.store.push_front($shortrealtobits($bitstoshortreal(sti.valueA) / $bitstoshortreal(sti.valueB)));
  endtask
  
  
  task random_operations();
        sti = new();
        @ (posedge intf.clk); 
        if(sti.randomize()) 
        
       	for (int i; i < sti.iterations; i++) //i hasta el número de iteraciones que se escogió
        begin
          if(sti.operation_list[i] == 0) // suma
          begin
            addition();
          	#sti.random_delay;
          end
          
          else if(sti.operation_list[i] == 1) // resta
          begin
            substraction(); 
          	#sti.random_delay;
          end
          
          else if(sti.operation_list[i] == 2) // multiplicación
          begin
            multiplication(); 
          	#sti.random_delay;
          end
          
          else if(sti.operation_list[i] == 3) // división
          begin
            division(); 
          	#sti.random_delay;
          end            
        end
  endtask 

  task extreme_cases(input integer op, input logic valueA, input logic valueB);
      sti = new();
      @ (posedge intf.clk); 
      if(sti.randomize()) 
        if(op == 0) // suma
          begin
            addition();
            #sti.random_delay;
          end
            
      else if(op == 1) // resta
            begin
              substraction(); 
              #sti.random_delay;
            end
            
      else if(op == 2) // multiplicación
            begin
              multiplication(); 
              #sti.random_delay;
            end
            
      else if(op == 3) // división
            begin
              division(); 
          #sti.random_delay;
        end
      
endtask 
endclass
