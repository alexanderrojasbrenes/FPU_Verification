// Test case
program testcase(intf_cnt intf);
  environment env = new(intf);
  int random_delay; // Variable para almacenar el retardo aleatorio
  int iterations; // Variable para almacenar el número de iteraciones de cada operación
  
  initial begin
    env.drvr.reset();
    
    iterations = 50; // Cantidad de iteraciones para cada operación
    
    // Suma
    repeat (iterations) begin
      env.drvr.addition(); // Ejecuta la suma una vez
      random_delay = $urandom_range(0, 50); // Retardo aleatorio entre iteraciones
      #random_delay;
    end

    /*
    // Resta
    repeat (iterations) begin
      env.drvr.substraction(); // Ejecuta la resta una vez
      random_delay = $urandom_range(0, 50);
      #random_delay;
    end
    
    
    // Multiplicación
    repeat (iterations) begin
      env.drvr.multiplication(); // Ejecuta la multiplicación una vez
      random_delay = $urandom_range(0, 50);
      #random_delay;
    end
    
    
    // División
    repeat (iterations) begin
      env.drvr.division(); // Ejecuta la división una vez
      random_delay = $urandom_range(0, 50);
      #random_delay;
    end
    */
    
    
    #100; // Tiempo de espera final antes de finalizar la simulación
    $finish;
  end
endprogram