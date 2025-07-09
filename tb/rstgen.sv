class rstgen;
  
  virtual fifo_intf vif;
  
  function new (virtual fifo_intf vif);
    this.vif=vif;
  endfunction
  
  task rstgen_t();
    #10 vif.reset_n = 0;
  	#10 vif.reset_n = 1;


  endtask
  
endclass
