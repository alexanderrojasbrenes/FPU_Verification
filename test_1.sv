program testcase(intf_cnt intf);
  environment env = new(intf);
         
  initial
    begin
    env.drvr.reset();
      env.drvr.addition(2);
    
      #100; $finish;
    end
endprogram
