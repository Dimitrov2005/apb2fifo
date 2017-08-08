`include "syncMemDual.v"


module fifo(WREQ,WD,f,e,RREQ,RD,rst,clkw,clkr);
   
   input WREQ,RREQ;
   input clkw,clkr,rst;
   input [31:0] WD;
   output [31:0] RD;
   output 	f,e;
   reg 		f,e;
   reg [31:0] 	RD;	
   reg [32:0] 	A1,A2;

   //memory
   sync_mem memory(
		   .A1(A1),
		   .A2(A2),
		   .WD1(WD),
		   .WD2(),
		   .WE1(WREQ),
		   .WE2(RREQ),
		   .RD1(),
		   .RD2(RD),
		   .clk1(clkw),
		   .clk2(clkr)
		   );
   
   
   always @(*)
     begin 				
	if(A1[31:0]==A2[31:0] && A1[32]!=A2[32])
	  f=1;

	else    f=0;
	
     end
   always @(*)
     begin
	if((A1[31:0]==A2[31:0]) && (A1[32]==A2[32]))
	  e=1;
	else    e=0;
     end
   
  always @(negedge rst)
     begin	
	if(~rst) 
	   A1 <= 33'b00000000;	
	  A2 <= 33'b00000000;
     end
   
   always @(posedge clkw)
     begin : Write	
	 if(WREQ&&(f==0))
	  A1<=A1+1;
	
     end

   always @(posedge clkr)
     begin : Read
	 if(RREQ&&(e==0))
	  A2<=A2+1;
     end		

   
   
   
endmodule
/*
 module test_FIFO ();

 reg WREQ,RREQ;
 reg clkw,clkr,rst;
 reg [7:0] WD;
 wire [7:0] RD;
 wire f,e;
 
 fifo DUT(WREQ,WD,f,e,RREQ,RD,rst,clkw,clkr);
 
 initial begin
 rst=1;
 clkw=1;
 clkr=0;
 #5 rst=0;
 WREQ=1;
 RREQ=0;
 WD=8'b00000100;
	end
 always fork 
 #5clkw=~clkw;
 clkr=~clkr;
 #5 WD=WD+1;
 #5 WREQ=~WREQ;
 //	#5 RREQ=~RREQ;
 
 
	join
 endmodule
 
 
 */	





