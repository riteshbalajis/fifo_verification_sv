class underflow_test;
  virtual fifo_intf vif;
  
  
  function new (virtual fifo_intf vif);
    this.vif=vif;
  endfunction
  
  
  
  task underflow_test_t();
    begin
      rstgen rstgen_h=new(vif);
      vif.data_out_check = vif.data_out;
      // Load a single value
      vif.write_en = 1;
      vif.data_in = 16'hA5A5;
      #10;
      vif.write_en = 0;
      #10;
      
      //reset
      
      rstgen_h.rstgen_t();
		
      // Attempt to read while empty
      vif.read_en = 1;
      #10;
      vif.read_en = 0;
      if (!vif.underflow) begin
        $error("Underflow Test: Underflow flag should be asserted");
        vif.error_count++;
      end
      if (vif.data_out != vif.data_out_check) begin
        $error("Underflow Test: Data out should be unchanged from last read value when underflow occurs.");
        vif.error_count++;
      end
      //else $warning("Read Data %0d", data_out);
    end

  endtask
endclass
