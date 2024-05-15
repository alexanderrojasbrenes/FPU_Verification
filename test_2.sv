// Test case
program testcase(intf_cnt intf);
  environment env = new(intf);
  
  initial begin
    env.drvr.reset();
    
    // inf + inf = inf
    env.drvr.extreme_cases(0);
    
    // -inf - inf = -inf
    env.drvr.extreme_cases(1);
    
    // n / [+-]inf = [+-]zero
    env.drvr.extreme_cases(3); // Se coloca aquí, ya que por ahora mejora la forma en la que se ven las ondas (no se confunden resultados)
    
    // [+-]n x inf = [+-] inf
    env.drvr.extreme_cases(2);
    
    #100; // Tiempo de espera final antes de finalizar la simulación
    $finish;
  end
endprogram