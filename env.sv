class environment;
  driver drvr;
  scoreboard sb;
  monitor mntr;
  virtual intf_cnt intf;
           
  function new(virtual intf_cnt intf);
    $display("Creating environment");
    this.intf = intf;
    sb = new();
    drvr = new(intf,sb);
    mntr = new(intf,sb);
    fork 
      mntr.check(); // task de chequeo activo durante toda la prueba
      				// por eso el fork
    join_none
  endfunction
           
endclass