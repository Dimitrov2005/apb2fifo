class Agent extends uvm_agent;
  `uvm_component_utils(Agent)
    Driver drv;
   Monitor mon;
   Sequencer seq;
   uvm_analysis_port#(Transaction) aportA;
   agent_config agent_cfg;

   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction // new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      aportA=new("aportA",this);

      if(!uvm_config_db#(agent_config)::get
	 (this,"","agent_cfg",agent_cfg))
	begin
	   `uvm_error("ACNF","Agent config not found");
	end

      drv=Driver::type_id::create("drv",this);
      seq=Sequencer::type_id::create("seq",this);
      mon=Monitor::type_id::create("mon",this);
   endfunction // build_phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      mon.viface=agent_cfg.viface;
      mon.aportM.connect(aportA);
      drv.seq_item_port.connect(seq.seq_item_export);
      drv.viface=agent_cfg.viface;
   endfunction // connect_phase

endclass // Agent

    