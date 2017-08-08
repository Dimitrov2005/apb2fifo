class agent_config extends uvm_object;
   
   `uvm_object_utils(agent_config)
     virtual iface viface;

   function new(string name="");
      super.new(name);
   endfunction // new


  //---------Passive or Active Agent----- //
   uvm_active_passive_enum is_active=UVM_ACTIVE;

 //------- SCB IN AGENT  --------//

   bit 	     has_scoreboard=0;
endclass:agent_config // agent_config
