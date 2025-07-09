class write_readtest;
  
  virtual fifo_intf vif;
  
  function new (virtual fifo_intf vif);
    this.vif=vif;
  endfunction
  
  
  task write_readtest_t();
    begin
      // Write values from 0 to DEPTH-1
      for (int i = 0; i < vif.DEPTH; i++) begin
        vif.write_en = 1;
        vif.data_in = i;
        #10;
        vif.write_en = 0;
        #10;
      end

      // Check full flag
      if (!vif.full) begin
        $error("Basic Write/Read Test: FIFO should be full");
        vif.error_count++;
      end

      // Read values back and verify
      for (int i = 0; i < vif.DEPTH; i++) begin
        vif.read_en = 1;
        #10;
        vif.read_en = 0;
        if (vif.data_out != i) begin
          $error("Basic Write/Read Test: Data mismatch at index %0d: expected %0d, got %0d", i, i, vif.data_out);
          vif.error_count++;
        end
        #10;
      end

      // Check empty flag
      if (!vif.empty) begin
        $error("Basic Write/Read Test: FIFO should be empty");
        vif.error_count++;
      end

      // Check overflow and underflow flags
      if (vif.overflow) begin
        $error("Basic Write/Read Test: FIFO should not overflow");
        vif.error_count++;
      end
      if (vif.underflow) begin
        $error("Basic Write/Read Test: FIFO should not underflow");
        vif.error_count++;
      end
    end
  endtask
  
endclass
