class driver;
  stimulus sti;
  scoreboard sb;
 
  virtual intf_cnt intf;
        
  function new(virtual intf_cnt intf,scoreboard sb);
    this.intf = intf;
    this.sb = sb;
  endfunction
        
  task reset(); // Reset method
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
      
      sb.store.push_front($shortrealtobits($bitstoshortreal(sti.valueA) + $bitstoshortreal(sti.valueB))); // Se guarda floatA + floatB en sb, pero en su representacion de IEEE 754
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

endclass
