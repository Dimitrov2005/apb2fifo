class env_config extends uvm_object;

  `uvm_object_utils(env_config)

   bit has_agent=1;
   bit 	 has_scoreboard=1;
   
   agent_config agent_cfg;
   function new(string name="");
      super.new(name);
   endfunction // new

endclass // env_config