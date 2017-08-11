class Transaction extends uvm_sequence_item;
   `uvm_object_utils(Transaction)

   rand logic PSELx;
   rand logic   PENABLE;
   rand logic   PWRITE;
   rand logic [7:0] PWDATA;
   rand logic PADDR;
   logic   PSLVERR;
   logic   PREADY;
   logic [7:0] PRDATA;
   
   function new(string name="");
      super.new(name);
   endfunction // new
   
endclass // Transaction
