class my_test extends uvm_test;
   `uvm_component_utils(my_test)
     Environment env;
   env_config env_cfg;
   agent_config agent_cfg;
   Sequence seq;
      function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction // new 
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      env_cfg=env_config::type_id::create("env_cfg",this);
      agent_cfg=agent_config::type_id::create("agent_cfg",this);
      
      if(!uvm_config_db#(virtual iface)::get
         (this,"","viface",agent_cfg.viface))
	begin
	 `uvm_error("TINF","base_test iface1 not found");
	end
      env_cfg.agent_cfg=agent_cfg;  
      
      uvm_config_db#(env_config)::set
	    (this,"*","env_cfg",env_cfg);

	    env=Environment::type_id::create("env",this);
	    
   endfunction // build_phase

      task run_phase(uvm_phase phase);
	 
    seq=seq::type_id::create("seq",this);
     
     //override the number of transactions,default=1    
	 seq.num=500;
     //override the number of transactions
	 
	 phase.raise_objection(this);
	 
	 seq.start(env.agent.seq);
	 
	 phase.drop_objection(this);
      endtask


 endclass:my_test // base_test
	    