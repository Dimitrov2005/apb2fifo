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

	   wait(viface.PRESETn==0);
	   seq_item_port.get_next_item(tr);
	   @(posedge viface.PCLK)
	     if(viface.PRESETn)
	       begin
		  viface.PSELx=x;
		  viface.PENABLE=x;
		  viface.PWRITE=x;
		  viface.PADDR=x;
	       end
	     else
	       begin
		  viface.PSELx=tr.PSELx;
		  viface.PENABLE=tr.PENABLE;
		  viface.PWRITE=tr.PWRITE;
		  viface.PADDR=tr.PADDR;
		  viface.PWDATA=tr.PWDATA;
	       end // else: !if(viface.PRESETn)
	   seq_item_port.item_done();
	end // forever begin
   endtask

endclass // Driver
