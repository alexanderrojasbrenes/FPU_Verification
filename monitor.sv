class monitor;
  scoreboard sb;
  virtual intf_cnt intf;

  logic [31:0] sb_value;
  int err_count;
  bit scbd_flag;
          
  function new(virtual intf_cnt intf,scoreboard sb);
    this.intf = intf;
    this.sb = sb;
  endfunction
          
  task check();
    err_count = 0;
    scbd_flag = 1;
    
    forever
    begin
      @ (intf.out)
      
      if (intf.out == 0 && scbd_flag != 0)
        begin
          scbd_flag = 0;
        end
        
      else if (scbd_flag == 0)
      begin
        sb_value = sb.store.pop_back();
          if (sb_value != intf.out) // Get expected value from scoreboard and compare with DUT output
          begin 
            $display("* ERROR * DUT data is %h :: SB data is %h ", intf.out ,sb_value );
            $display("* ERROR * DUT data is %f :: SB data is %f ", $bitstoshortreal(intf.out), $bitstoshortreal(sb_value));
            err_count++;
          end
      
          else 
          begin
            $display("* PASS * DUT data is %h :: SB data is %h ", intf.out ,sb_value );
            $display("* PASS * DUT data is %f :: SB data is %f ", $bitstoshortreal(intf.out), $bitstoshortreal(sb_value));
          end
      end
     end
  endtask
endclass