`include "fifopkg.sv" 
import fifopkg::*;
`include "fifo_intf.sv"

module fifo_tbtop();
  fifo_intf vif();
  runtest runtest_h=new(vif);
  
  fifo # (
    .DATA_WIDTH(vif.DATA_WIDTH),
    .DEPTH(vif.DEPTH),
    .ADDR_WIDTH(vif.ADDR_WIDTH)
  ) fifo_inst (
    .clk(vif.clk),
    .reset_n(vif.reset_n),
    .write_en(vif.write_en),
    .read_en(vif.read_en),
    .data_in(vif.data_in),
    .data_out(vif.data_out),
    .full(vif.full),
    .empty(vif.empty),
    .almost_full(vif.almost_full),
    .almost_empty(vif.almost_empty),
    .overflow(vif.overflow),
    .underflow(vif.underflow)
  );
  
  
  initial begin
    vif.clk=0;
    vif.reset_n=0;
    vif.write_en=0;
    vif.read_en=0;
    vif.data_in=0;
    vif.data_out_check=0;
  end
  
  initial begin
    runtest_h.run();
  end
  
  
  initial begin
    $dumpfile("file.vcd");
    $dumpvars(0,fifo_tbtop);
    
  end
  
  
  always #5 vif.clk = ~vif.clk;
  
  
  
  

  
endmodule
