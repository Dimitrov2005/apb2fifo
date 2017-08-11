module top;
  import uvm_pkg::*;
   import pack_all::*; 
`include "uvm_macros.svh"
 
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
			  .PREADY(iface.PREADY),
			  .PSLVERR(iface.PSLVERR),
	 		  .PRDATA(iface.PRDATA) //data
			  );
   initial
     begin
	PCLK=0;
	PRESETn=1;
	#1ps PRESETn=0;
	#5ps PRESETn=1;
	
     end
  
 always #5ps PCLK=~PCLK;

   initial 
     begin
	uvm_config_db #(virtual iface)::set  (null,"","viface",viface);
       // run_test("testF");
	run_test("my_test");
	#1000ps $finish();
     end

   
endmodule:top // top
