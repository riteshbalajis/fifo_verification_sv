class reset_test;
  
  virtual fifo_intf vif;
 
  function new(virtual fifo_intf vif);
    this.vif=vif;
  endfunction
  
  task run();
   
    vif.reset_n=0;
    
    if(vif.reset_n==0 && ({vif.full,vif.empty,vif.almost_full,vif.almost_empty,vif.overflow,vif.underflow}!={6'b010100})) begin
      $error(" ---> Reset Test Failed <---");
      vif.error_count+=1;
    end
    
    vif.reset_n=1;
  endtask
endclass
