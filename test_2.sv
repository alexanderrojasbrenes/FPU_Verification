program testcase(intf_cnt intf);
  environment env = new(intf);
  
  initial
  begin
    env.drvr.reset();
    env.drvr.write(100);
    env.drvr.reset();
    env.drvr.write(100);
  end
endprogram