class Transaction extends uvm_sequence_item;
   `uvm_object_utils(Transaction)

     logic PSELx;
   logic   PENABLE;
   logic   PWRITE;
   logic   PSLVERR;
   logic [31:0] PWDATA;
   logic [31:0] PRDATA;
   
   function new(string name="");
      super.new(name);
   endfunction // new
   
endclass // Transaction
