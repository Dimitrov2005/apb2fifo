class Driver extends uvm_driver#(Transaction);
   `uvm_component_utils (Driver)

     virtual iface viface;

   function new(string name,uvm_component parent);
      super.new(name,parent);
   endfunction // new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction // build_phase

   task run_phase(uvm_phase phase);
      Transaction tr;
      forever
	begin

	   wait(viface.PRESETn==1);
	   seq_item_port.get_next_item(tr);
	   @(posedge viface.PCLK)
	     @(posedge viface.PCLK);
		viface.PADDR=tr.PADDR; 
	        viface.PSELx=tr.PSELx;
		viface.PWDATA=tr.PWDATA; 
		viface.PWRITE=tr.PWRITE;
	        tr.PSLVERR=viface.PSLVERR;
	   @(posedge viface.PCLK)
	     viface.PENABLE=tr.PENABLE;
	   @(posedge viface.PCLK)
	     begin
	        viface.PSELx=0;
		viface.PENABLE=0;
	     end
	   seq_item_port.item_done(tr);
	end // forever begin
   endtask

endclass // Driver
