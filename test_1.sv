// Test case
program testcase(intf_cnt intf);
  environment env = new(intf);
  int random_delay; // Variable para almacenar el retardo aleatorio
  int iterations; // Variable para almacenar el número de iteraciones de cada operación
  
  initial begin
    env.drvr.reset();
    
    env.drvr.random_operations(); 
    
    #100; // Tiempo de espera final antes de finalizar la simulación
    $finish;
  end
endprogram
