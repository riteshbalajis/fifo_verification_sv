class runtest;
  
  virtual fifo_intf vif;
  
  function new (virtual fifo_intf vif);
    this.vif=vif;
  endfunction
  
  task run();
    rstgen rstgen_h=new(vif);
    write_readtest write_readtest_h=new(vif);
    underflow_test underflow_test_h=new(vif);
    overflow_test overflow_test_h=new(vif);
    empty_test empty_test_h=new(vif);
    full_test full_test_h=new(vif);
    result result_h=new(vif);
    reset_test reset_test_h=new(vif);
    
    //test run task
    rstgen_h.rstgen_t();
    reset_test_h.run();
    write_readtest_h.write_readtest_t();
    underflow_test_h.underflow_test_t();
    overflow_test_h.overflow_test_t();
    empty_test_h.empty_test_t();
    full_test_h.full_test_t();
    result_h.run();
    
    
  endtask
endclass
