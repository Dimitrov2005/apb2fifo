class Sequencer extends uvm_sequencer #(Transaction);
   `uvm_component_utils (Sequencer)

     function new(string name, uvm_component parent);
	super.new(name,parent);
     endfunction // new

endclass // Sequencer
