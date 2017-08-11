class Sequence extends uvm_sequence#(Transaction);
   `uvm_object_utils(Sequence)

     Transaction tr;
      int num =259;
      bit FULL,EMPTY;
     
     function new(string name ="");
	super.new(name);
     endfunction // new

      task body();
	 repeat(num)
	   begin
	      tr=new("");
	      assert (tr.randomize());
	      
	      start_item(tr);
	      if(!EMPTY&&FULL)
	      begin
		 assert (tr.randomize() with {tr.PSELx==1;
					   tr.PENABLE==1;
					   tr.PADDR==1;
					   tr.PWRITE==0;})
		 else `uvm_fatal("FER","Randomization failed");
              end
	      else 
		begin
	       assert (tr.randomize() with {tr.PSELx==1;
					   tr.PENABLE==1;
					   tr.PADDR==0;
					   tr.PWRITE==1;})
		 else `uvm_fatal("FER","Randomization failed");

	      end
	      finish_item(tr);$display("%b sel : %b enable : %b Addr :%b err : %b Pwrite ", tr.PSELx,tr.PENABLE,!tr.PADDR,tr.PSLVERR,tr.PWRITE);
	      get_response(tr);
	      FULL=(tr.PSELx&&tr.PENABLE&&(!tr.PADDR)&&tr.PSLVERR&&tr.PWRITE);
	      EMPTY=(tr.PSELx&&tr.PENABLE&&(tr.PADDR)&&tr.PSLVERR&&(!tr.PWRITE)); $display("%b FULL : %b EMPTY ", FULL,EMPTY);
	  end
	 
endtask // body

   endclass // Sequence
