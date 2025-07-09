class result;
  
  virtual fifo_intf intf;
  
  function new(virtual fifo_intf vif);
    intf=vif;
  endfunction
  
  task run();
    if (intf.error_count == 0) begin
      $display("\n ---> FIFO TEST COMPLETED SUCCESFULLY !!!!! <---\n");
    end
    else begin
      $error(">Test Failed with %0d errors",intf.error_count);
    end
    $finish;
  endtask
  
endclass
