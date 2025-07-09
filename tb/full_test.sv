class full_test;
  
  virtual fifo_intf vif;
  
  function new (virtual fifo_intf vif);
    this.vif=vif;
  endfunction
  
  
  
  task full_test_t();
    
      //reset();
      rstgen rstgen_h=new(vif);
      rstgen_h.rstgen_t();

      // Write FIFO to full
        vif.write_en = 1;
    for (int i = 0; i <vif.DEPTH ; i++) begin 
          vif.data_in = i;
          #10;
        end

        vif.write_en = 0;
        vif.data_out_check =vif.data_in; 
        #10;
      // Verify full flag is set
    if (!vif.full) $error("Simultaneous Read/Write While Full Test: FIFO should be full");

        // Enable simultaneous read and write
        vif.write_en = 1;
        vif.read_en = 1;
        vif.data_in = 16'h9ABC;
        #10;
        vif.write_en = 0;
        #10;
        
        // check to see if overflow is triggered
    if (!vif.overflow) begin
          $error("Simultaneous Read/Write While Full Test: Overflow flag should be asserted on first simultaneous read/write");
          vif.error_count++;
        end
        
        vif.write_en = 1;
    for (int k = 0; k <vif.DEPTH+5; k++) begin
          #10;
      if (k == vif.DEPTH-3 && vif.data_out != vif.data_out_check) begin 
            $error("Simultaneous Read/Write While Full Test: Data out should be match saved value, %x. Instead a value was written while overflow was asserted: %x.", vif.data_out_check, vif.data_out);
            vif.error_count++;
          end
      else if (k > vif.DEPTH-3 && vif.data_out != vif.data_in) begin
            $error("Simultaneous Read/Write While Full Test: Data out should be match continuous input value, %x, after overflow is cleared and simultaneous read/write is allowed.", vif.data_in);
            vif.error_count++;
          end
        end
        vif.write_en = 0;
        vif.read_en = 0;
        
    //end
  endtask
  
  
endclass
