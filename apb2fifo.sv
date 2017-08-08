module apb2fifo(
		input wire 
		PSELx,//selector signal
		PENABLE,
		PADDR, // 0-write 1-read
		PWRITE, // address and control signals end
		PRESETn,
		PCLK,
		[31:0] PWDATA,

		output reg
		PSLVERR,
	 	[31:0] PRDATA //data
		);
   
   bit 			   WREQ,RREQ,FULL,EMPTY;
   
    //registers for write
   reg [31:0] 		   r_PWDATA,	
			   r_PRDATA;
  
 reg 			   r_PADDR, // 0-write 1-read
			   r_PWRITE,
			   r_PSELx,
			   r_PENABLE;

  //fifo instance
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
  begin
     if (~PRESETn)
       begin
	  r_PWDATA[31:0]<=32'b0;
	  r_PADDR<=0;
	  r_PWRITE<=0;
	  r_PSELx<=0;
	  r_PENABLE<=0;
	  WREQ<=0;
	  RREQ<=0;
       end
     else
       begin
	  r_PWDATA[31:0]<=PWDATA[31:0];
	  r_PADDR<=PADDR;
	  r_PWRITE<=PWRITE;
	  r_PSELx<=PSELx;
	  r_PENABLE<=PENABLE;
       end
  end // registering write input

always @(posedge PCLK or posedge PENABLE)
  begin //write logic
     if(r_PSELx && r_PWRITE && (!r_PADDR))
       begin
	  if(FULL)
	    PSLVERR<=1;
	  else
	    PSLVERR<=0;
	  
	  WREQ<=1;
	  RREQ<=0;
       end
  end
   
always @(posedge PCLK or posedge PENABLE)
  begin // read logic
     if(PSELx && r_PADDR &&(!PWRITE))
       begin
	  if(EMPTY)
	    PSLVERR<=1;
	  else
	    PSLVERR<=0;

	  RREQ<=1;
	  WREQ<=0;
       end
     
  end
 
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