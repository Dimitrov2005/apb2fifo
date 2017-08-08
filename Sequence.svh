class Sequence extends uvm_sequence#(Transaction);
   `uvm_object_utils(Sequence)

     Transaction tr;
      int num =1;
     //  logic FULL,EMPTY; ?????
     
     function new(string name ="");
	super.new(name);
     endfunction // new

      task body()
	 repeat(num)
	   begin
	      tr=new("");
	      assert (tr.randomize());
	      start_item(tr);
	      finish_item(tr);
	      
  end
	 
endtask // body

   endclass // Sequence
