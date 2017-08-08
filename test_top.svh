module top;
  import uvm_pkg::*; 
`include "uvm_macros.svh"
   import pack::*;
   bit PCLK,PRESETn;
   iface iface1(PCLK,PRESETn);
   virtual iface viface=iface1;

   //instantiate the APB2fifo controller
   
    apb2fifo apbController(
			  .PSELx(iface.PSELx),//selector signal
			  .PENABLE(iface.PENABLE),
			  .PADDR(iface.PADDR), // 0-write 1-read
			  .PWRITE(iface.PWRITE), // address and control signals end
			  .PRESETn(iface.PRESETn),
			  .PCLK(iface.PCLK),
			  .PWDATA(iface.PWDATA),
			  .PSLVERR(iface.SLVERR),
	 		  .PRDATA(iface.PRDATA) //data
			  );
   initial
     begin
	clk=0;
	rst=1;
	#1ps rst=0;
	#1ps rst=1;
     end
  
 always #5ps clk=~clk;

   initial 
     begin
	uvm_config_db #(virtual iface)::set  (null,"","viface",viface);
       // run_test("testF");
	run_test("my_test");
     end

   
endmodule:top // top
