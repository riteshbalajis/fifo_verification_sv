class empty_test;
  virtual fifo_intf vif;
  
  function new (virtual fifo_intf vif);
    this.vif=vif;
  endfunction
  
  
  
  task empty_test_t();
    begin
      rstgen rstgen_h=new(vif);
      vif.data_out_check = vif.data_out; // grab current output value to check if it changes
      // Call reset
      
      rstgen_h.rstgen_t();
      
      //reset();
     

      // Attempt to write and read simultaneously
      vif.write_en = 1;
      vif.read_en = 1;
      vif.data_in = 16'h1234;
      #10;
      //write_en = 0;
      vif.read_en = 0;
      #10;
      if (vif.data_out != vif.data_out_check) begin
        $error("Simultaneous Read/Write While Empty Test: Data out should be unchanged on first simultaneous read/write");
        vif.error_count++;
      end
      if (!vif.underflow) begin
        $error("Simultaneous Read/Write While Empty Test: Underflow flag should be asserted on first simultaneous read/write");
        vif.error_count++;
      end

      // Verify empty flag clears and almost empty is asserted
      if (vif.empty) begin
        $error("Simultaneous Read/Write While Empty Test: FIFO should not be empty after first write");
        vif.error_count++;
      end
      if (!vif.almost_empty) begin
        $error("Simultaneous Read/Write While Empty Test: FIFO should be almost empty after first write");
        vif.error_count++;
      end

      // Test valid simultaneous read and write
      vif.write_en = 1;
      vif.read_en = 1;
      vif.data_in = 16'h5678;
      #10;
      vif.write_en = 0;
      vif.read_en = 0;
      #10;
      if (vif.data_out != 16'h1234) begin
        $error("Simultaneous Read/Write While Empty Test: Data mismatch on simultaneous read/write: expected 16'h1234, got %0h", vif.data_out);
        vif.error_count++;
      end
      if (vif.empty) begin
        $error("Simultaneous Read/Write While Empty Test: FIFO should not be empty after simultaneous read/write");
        vif.error_count++;
      end
      if (!vif.almost_empty) begin
        $error("Simultaneous Read/Write While Empty Test: FIFO should be almost empty after simultaneous read/write");
        vif.error_count++;
      end
    end
  
  endtask
  
  

  
endclass
