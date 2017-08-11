module apb2fifo(
		input 
		PSELx,//selector signal
		PENABLE,
		PADDR, // 0-write 1-read
		PWRITE, // address and control signals end
		PRESETn,
		PCLK,
		[7:0] PWDATA,

		output
		PREADY,
		PSLVERR,
	 	[7:0] PRDATA //data
		);
   
   reg 	   WREQ,RREQ,FULL,EMPTY,PSLVERR;
   
    //registers for write
   reg [7:0] 		   r_PWDATA,PRDATA;
  
   reg 			   r_PADDR, // 0-write 1-read
			   r_PWRITE,
			   r_PENABLE,
			   r_PSELx;
			 
   

  //fifo instance\\
   fifo FIFO(.WREQ(WREQ),
	.WD(r_PWDATA),
	.f(FULL),
	.e(EMPTY),
	.RREQ(RREQ),
	.RD(PRDATA),
	.rst(PRESETn),
	.clkw(PCLK),
	.clkr(PCLK)
	);

always @ (posedge PCLK or negedge PRESETn)
       if (~PRESETn)
       begin
	  r_PWDATA[7:0]<=8'b0;
	  r_PADDR<=0;
	  r_PWRITE<=0;
	  r_PSELx<=0;
          r_PENABLE<=0;
	  PSLVERR<=0;
	  WREQ<=0;
	  RREQ<=0;
       end // if (~PRESETn)
   
       else
	 begin
	    r_PWDATA[7:0]<=PWDATA[7:0];
	    r_PADDR<=PADDR;
	    r_PWRITE<=PWRITE;
	    r_PSELx<=PSELx;
	    r_PENABLE<=PENABLE;
	 end // else: !if(~PRESETn)

   
always @ (*)
    begin
       if(PSELx && PWRITE && (!PADDR))
	 begin 
	    if(FULL)
	      begin
		 PSLVERR<=1;
		 WREQ<=0;
		 RREQ<=0;	 
	      end
	    
	  else if(PENABLE)
	      begin 
		 WREQ<=1;
		 RREQ<=0;
	      end
	 end
       if(PSELx && PADDR &&(!PWRITE))
	 begin
	    if(EMPTY)
	      begin
		 PSLVERR<=1;
		 WREQ<=0;
		 RREQ<=0;	 
	      end
	    
	  else if(PENABLE)
	    begin
	      WREQ<=0;
	      RREQ<=1;
	   end  
       end	 	  
       else 
	 begin 
	    WREQ=0;
	    RREQ=0;
	 end
      
    end
 
assign PREADY=(PENABLE&&PSELx&&!PSLVERR);
//assign PSLVERR = ((FULL&&WREQ)||(EMPTY&&RREQ));
   
endmodule
	
	 
 /*module test ();

   reg   PSELx,//selector signal
	 PENABLE,
	 PADDR, // 0-write 1-read
	 PWRITE, // address and control signals end
	 PRESETn,
	 PCLK;
   reg [31:0] PWDATA;
   
   wire PSLVERR;	 
   wire [31:0] PRDATA; //data
    
   apb2fifo apbController(
			  PSELx,//selector signal
			  PENABLE,
			  PADDR, // 0-write 1-read
			  PWRITE, // address and control signals end
			  PRESETn,
			  PCLK,
			  PWDATA,
			  PSLVERR,
	 		  PRDATA //data
			  );

   always #5 PCLK=~PCLK;
   
   initial
     begin
	PCLK=0;
	PRESETn=1;
	#2 PRESETn=0;
	#2 PRESETn=1;
	PSELx=1;
	PENABLE=1;
	PADDR=0;
	#6 PWRITE=1;
	PWDATA=32'b1;
	#100 $finish();
     end

endmodule // test
*/