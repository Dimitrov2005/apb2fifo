class Scoreboard extends uvm_scoreboard;

   `uvm_component_utils(Scoreboard)

     uvm_tlm_analysis_fifo#(Transaction) fifo;
   logic [31:0] q[$:255],i;
   int 	       countm=0;
   Transaction tr;

   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction // new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      fifo=new("fifo",this);
   endfunction // build_phase

   
   task run();
      forever 
	begin
	   tr=new("tr");
	   fifo.get(tr);
	  	
	   
	   if((tr.PSELx===1'bx)&&(tr.PENABLE===1'bx)&&(tr.PWRITE===1'bx)&&(tr.PADDR===1'bx))
	     begin   
		`uvm_warning("RST","RESET IN PROGRESS");
	//	q.delete();	   
	     end
	   else if((tr.PSELx==1)&&(tr.PENABLE==1)&&(tr.PWRITE==1)&&(tr.PADDR==0))
	     begin
	      pushFull(tr);
	   `uvm_info("TRWREQ",$sformatf("+++++++ WREQ - %h ++++++",tr.PWDATA), UVM_MEDIUM);	 
	     end
	   
	   else if((tr.PSELx==1)&&(tr.PENABLE==1)&&(tr.PWRITE==0)&&(tr.PADDR==1))
	     begin
	      `uvm_info("TRRREQ",$sformatf("+++++++ RREQ - %h ++++++",tr.PRDATA),UVM_MEDIUM);
	      popEmpt(tr);
	   end
	   
	end 
   endtask // run

   
//********** //push and full function begin\\ **********///
   function void pushFull(Transaction tr); 
     
      if((!tr.PSLVERR)&&((tr.PSELx==1)&&(tr.PENABLE==1)&&(tr.PWRITE==1)&&(tr.PADDR==0)))
	begin 
	   q.push_front(tr.PWDATA);   
	   `uvm_info("TRREC",$sformatf("------SCB TRANS REC  %h qsize= %d--------",tr.PWDATA,q.size()),UVM_MEDIUM);
	end
     else if((q.size()==253) && (tr.PSLVERR))
	begin	  
	   `uvm_warning("SCBF",$sformatf("--FIFO FULL :: PSLVERR %b, Qsize : %d :------",tr.PSLVERR,q.size()));
	end
      else 
      // overwrite logic
      if((tr.PSLVERR==1)&&((tr.PSELx==1)&&(tr.PENABLE==1)&&(tr.PWRITE==1)&&(tr.PADDR==0)))
	begin
	   q[(q.size())-4]=(tr.PWDATA);
	   `uvm_warning("SCBOW",$sformatf("--------OVERWRITE, qdatatoadd =%h ------",tr.PWDATA));
	end
   
   endfunction 
//-------------- //push and full function end\\ -----------\\\

   

//********** //pop and empty function begin\\ **********\\\
   function void popEmpt(Transaction tr);
    
     if((tr.PSLVERR==1)&&((tr.PSELx==1)&&(tr.PENABLE==1)&&(tr.PWRITE==0)&&(tr.PADDR==1)))
	begin
	   `uvm_warning("SCBRWE","--------READ WHILE EMPTY ERROR ------");
	end
      
      i=q.pop_back(); 
     if(tr.PRDATA!=i)
	begin
	   `uvm_warning("SCBD",$sformatf("--------Data Mismatch fifo:%h q:%h ------",tr.PRDATA, i));
	   countm++;
	end
      else  if((q.size()==0)&&(tr.PSLVERR))
	begin
	   `uvm_warning("SCBE",$sformatf("--------FIFO EMPTY :: PSLVERR %b, Qsize : %d------",tr.PSLVERR,q.size()));  
	end
      
   endfunction
 //********** ///popEmptpy function end\\\ ************\\





   
   function void report_phase(uvm_phase phase);
      $display("total mismatches : %d ",countm);
   endfunction // report_phase
   



   
endclass :Scoreboard