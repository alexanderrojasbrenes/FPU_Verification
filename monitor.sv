class monitor;
  scoreboard sb;
  virtual intf_cnt intf;

  logic [31:0] sb_value;
  int err_count;
          
  function new(virtual intf_cnt intf,scoreboard sb);
    this.intf = intf;
    this.sb = sb;
  endfunction
          
  task check();
    err_count = 0;
    forever
      begin
        @ (intf.out)
        if (intf.out != 0)
        begin
        sb_value = sb.store.pop_back();
          if( sb_value != intf.out) begin // Get expected value from scoreboard and compare with DUT output
            $display(" * ERROR * DUT data is %h :: SB data is %h ", intf.out ,sb_value );
            err_count++;
          end
          else begin
            $display(" * PASS * DUT data is %h :: SB data is %h ", intf.out ,sb_value );
          end
        end
      end
  endtask
endclass
