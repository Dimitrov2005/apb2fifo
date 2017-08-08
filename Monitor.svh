class Monitor extends uvm_monitor;
   `uvm_component_utils(Monitor)

     virtual iface viface;
   uvm_analysis_port#(Transaction)aportM;

   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction // new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      aportM=new("aportM",this);
   endfunction // build_phase

   task run_phase(uvm_phase phase);
      forever
	begin
	   // sample signals from the viface
	   wait(viface.PRESETn);
	   
	   @(posedge viface.PCLK)
	     tr=Transaction::type_id::create("tr");
	   tr.PSELx=viface.PSELx;
	   tr.PENABLE=viface.PENABLE;
	   tr.PADDR=viface.PADDR;
	   tr.PWRITE=viface.PWRITE;
	   tr.PSLVERR=viface.PSLVERR;
	   tr.PWDATA=viface.PWDATA;
	   tr.PRDATA=viface.PRDATA;
	  
	   aportM.write(tr);
	   
	end // forever begin

   endtask // run_phase

endclass // Monitor
