class overflow_test;
  
  virtual fifo_intf vif;
  
  function new (virtual fifo_intf vif);
    this.vif=vif;
  endfunction
  
  task overflow_test_t();
    begin
      // Fill the FIFO completely
      for (int i = 0; i < vif.DEPTH; i++) begin
        vif.write_en = 1;
        vif.data_in = i;
        #10;
        vif.write_en = 0;
        #10;
      end

      // Attempt to write additional data
      vif.write_en = 1;
      vif.data_in = 16'hFFFF;
      #10;
      vif.write_en = 0;
      if (!vif.overflow) begin
        $error("Overflow Test: Overflow flag should be asserted");
        vif.error_count++;
      end

      // Read out all values and verify
      for (int i = 0; i < vif.DEPTH; i++) begin
        vif.read_en = 1;
        #10;
        vif.read_en = 0;
        if (vif.data_out != i) begin
          $error("Overflow Test: Data mismatch at index %0d: expected %0d, got %0d", i, i,vif.data_out);
          vif.error_count++;
        end
        #10;
      end

      // Ensure the overflowed value is not in the FIFO
      vif.read_en = 1;
      #10;
      vif.read_en = 0;
      if (!vif.empty) begin
        $error("Overflow Test: FIFO should be empty after reading all values");
        vif.error_count++;
      end
    end
  endtask
endclass
