// Test case
program testcase(intf_cnt intf);
  environment env = new(intf);
  
  initial begin
    env.drvr.reset();
    
    env.drvr.random_operations();
    
    #100; // Tiempo de espera final antes de finalizar la simulación
    $finish;
  end
endprogram
