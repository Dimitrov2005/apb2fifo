interface iface(input logic PCLK,PRESETn);
   
   logic PSELx
	 PENABLE,
	 PADDR, // 0-write 1-read
	 PWRITE, // address and control signals end
	 PSLVERR;
   
   logic [31:0] PWDATA,//data
		PRDATA;

endinterface;