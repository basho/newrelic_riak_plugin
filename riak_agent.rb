#!/usr/bin/env ruby
require "rubygems"
require "bundler/setup"
require "newrelic_plugin"
require "rest-client"
require "json"

module RiakAgent

  class Agent < NewRelic::Plugin::Agent::Base
    agent_guid "DROP_GUID_FROM_PLUGIN_HERE"
    agent_config_options :host, :port
    agent_human_labels("Riak") { "#{host}:#{port}" }

    def setup_metrics
      @vnode_gets = NewRelic::Processor::EpochCounter.new
	  @vnode_puts = NewRelic::Processor::EpochCounter.new
	  @vnode_index_reads = NewRelic::Processor::EpochCounter.new
	  @vnode_index_writes = NewRelic::Processor::EpochCounter.new
	  @vnode_index_writes_postings = NewRelic::Processor::EpochCounter.new
	  @vnode_index_deletes = NewRelic::Processor::EpochCounter.new
	  @vnode_index_deletes_postings = NewRelic::Processor::EpochCounter.new
	  @read_repairs = NewRelic::Processor::EpochCounter.new
	  @vnode_gets_total = NewRelic::Processor::EpochCounter.new
	  @vnode_puts_total = NewRelic::Processor::EpochCounter.new
	  @vnode_index_reads_total = NewRelic::Processor::EpochCounter.new
	  @vnode_index_reads_total = NewRelic::Processor::EpochCounter.new
	  @vnode_index_writes_postings_total = NewRelic::Processor::EpochCounter.new
	  @vnode_index_deletes_total = NewRelic::Processor::EpochCounter.new
	  @vnode_index_deletes_postings_total = NewRelic::Processor::EpochCounter.new
	  @node_gets = NewRelic::Processor::EpochCounter.new
	  @node_gets_total = NewRelic::Processor::EpochCounter.new
	  @node_get_fsm_time_mean = NewRelic::Processor::EpochCounter.new
	  @node_get_fsm_time_median = NewRelic::Processor::EpochCounter.new
	  @node_get_fsm_time_95 = NewRelic::Processor::EpochCounter.new
	  @node_get_fsm_time_99 = NewRelic::Processor::EpochCounter.new
	  @node_get_fsm_time_100 = NewRelic::Processor::EpochCounter.new
	  @node_puts = NewRelic::Processor::EpochCounter.new
	  @node_puts_total = NewRelic::Processor::EpochCounter.new
	  @node_put_fsm_time_mean = NewRelic::Processor::EpochCounter.new
	  @node_put_fsm_time_median = NewRelic::Processor::EpochCounter.new
	  @node_put_fsm_time_95 = NewRelic::Processor::EpochCounter.new
	  @node_put_fsm_time_99 = NewRelic::Processor::EpochCounter.new
	  @node_put_fsm_time_100 = NewRelic::Processor::EpochCounter.new
	  @node_get_fsm_siblings_mean = NewRelic::Processor::EpochCounter.new
	  @node_get_fsm_siblings_median = NewRelic::Processor::EpochCounter.new
	  @node_get_fsm_siblings_95 = NewRelic::Processor::EpochCounter.new
	  @node_get_fsm_siblings_99 = NewRelic::Processor::EpochCounter.new
	  @node_get_fsm_siblings_100 = NewRelic::Processor::EpochCounter.new
	  @node_get_fsm_objsize_mean = NewRelic::Processor::EpochCounter.new
	  @node_get_fsm_objsize_median = NewRelic::Processor::EpochCounter.new
	  @node_get_fsm_objsize_95 = NewRelic::Processor::EpochCounter.new
	  @node_get_fsm_objsize_99 = NewRelic::Processor::EpochCounter.new
	  @node_get_fsm_objsize_100 = NewRelic::Processor::EpochCounter.new
	  @read_repairs_total = NewRelic::Processor::EpochCounter.new
	  @coord_redirs_total = NewRelic::Processor::EpochCounter.new
	  @precommit_fail = NewRelic::Processor::EpochCounter.new
	  @postcommit_fail = NewRelic::Processor::EpochCounter.new
	  @cpu_nprocs = NewRelic::Processor::EpochCounter.new
	  @cpu_avg1 = NewRelic::Processor::EpochCounter.new
	  @cpu_avg5 = NewRelic::Processor::EpochCounter.new
	  @cpu_avg15 = NewRelic::Processor::EpochCounter.new
	  @mem_total = NewRelic::Processor::EpochCounter.new
	  @mem_allocated = NewRelic::Processor::EpochCounter.new
	  @sys_process_count = NewRelic::Processor::EpochCounter.new
	  @pbc_connects_total = NewRelic::Processor::EpochCounter.new
	  @pbc_connects = NewRelic::Processor::EpochCounter.new
	  @pbc_active = NewRelic::Processor::EpochCounter.new
	  @executing_mappers = NewRelic::Processor::EpochCounter.new
	  @memory_total = NewRelic::Processor::EpochCounter.new
	  @memory_processes = NewRelic::Processor::EpochCounter.new
	  @memory_processes_used = NewRelic::Processor::EpochCounter.new
	  @memory_system = NewRelic::Processor::EpochCounter.new
	  @memory_atom = NewRelic::Processor::EpochCounter.new
	  @memory_atom_used = NewRelic::Processor::EpochCounter.new
	  @memory_binary = NewRelic::Processor::EpochCounter.new
	  @memory_code = NewRelic::Processor::EpochCounter.new
	  @memory_ets = NewRelic::Processor::EpochCounter.new
	  @ignored_gossip_total = NewRelic::Processor::EpochCounter.new
	  @rings_reconciled_total = NewRelic::Processor::EpochCounter.new
	  @rings_reconciled = NewRelic::Processor::EpochCounter.new
	  @gossip_received = NewRelic::Processor::EpochCounter.new
	  @handoff_timeouts = NewRelic::Processor::EpochCounter.new
	  @converge_delay_min = NewRelic::Processor::EpochCounter.new
	  @converge_delay_max = NewRelic::Processor::EpochCounter.new
	  @converge_delay_mean = NewRelic::Processor::EpochCounter.new
	  @converge_delay_last = NewRelic::Processor::EpochCounter.new
	  @rebalance_delay_min = NewRelic::Processor::EpochCounter.new
	  @rebalance_delay_max = NewRelic::Processor::EpochCounter.new
	  @rebalance_delay_mean = NewRelic::Processor::EpochCounter.new
	  @rebalance_delay_last = NewRelic::Processor::EpochCounter.new
	  @riak_kv_vnodes_running = NewRelic::Processor::EpochCounter.new
	  @riak_kv_vnodeq_min = NewRelic::Processor::EpochCounter.new
	  @riak_kv_vnodeq_median = NewRelic::Processor::EpochCounter.new
	  @riak_kv_vnodeq_mean = NewRelic::Processor::EpochCounter.new
	  @riak_kv_vnodeq_max = NewRelic::Processor::EpochCounter.new
	  @riak_kv_vnodeq_total = NewRelic::Processor::EpochCounter.new
	  @riak_pipe_vnodes_running = NewRelic::Processor::EpochCounter.new
	  @riak_pipe_vnodeq_min = NewRelic::Processor::EpochCounter.new
	  @riak_pipe_vnodeq_median = NewRelic::Processor::EpochCounter.new
	  @riak_pipe_vnodeq_mean = NewRelic::Processor::EpochCounter.new
	  @riak_pipe_vnodeq_max = NewRelic::Processor::EpochCounter.new
	  @riak_pipe_vnodeq_total = NewRelic::Processor::EpochCounter.new
	  @riak_search_vnodes_running = NewRelic::Processor::EpochCounter.new
	  @riak_search_vnodeq_min = NewRelic::Processor::EpochCounter.new
	  @riak_search_vnodeq_median = NewRelic::Processor::EpochCounter.new
	  @riak_search_vnodeq_mean = NewRelic::Processor::EpochCounter.new
	  @riak_search_vnodeq_max = NewRelic::Processor::EpochCounter.new
	  @riak_search_vnodeq_total = NewRelic::Processor::EpochCounter.new
    end

    def poll_cycle
      results = RestClient.get "http://#{host}:#{port}/stats"
	  stats = JSON.parse(results)

	  report_metric "vnode_gets", "vnode_gets", @vnode_gets.process(stats["vnode_gets"])
	  report_metric "vnode_puts", "vnode_puts", @vnode_puts.process(stats["vnode_puts"])
	  report_metric "vnode_index_reads", "vnode_index_reads", @vnode_index_reads.process(stats["vnode_index_reads"])
	  report_metric "vnode_index_writes", "vnode_index_writes", @vnode_index_writes.process(stats["vnode_index_writes"])
	  report_metric "vnode_index_writes_postings", "vnode_index_writes_postings", @vnode_index_writes_postings.process(stats["vnode_index_writes_postings"])
	  report_metric "vnode_index_deletes", "vnode_index_deletes", @vnode_index_deletes.process(stats["vnode_index_deletes"])
	  report_metric "vnode_index_deletes_postings", "vnode_index_deletes_postings", @vnode_index_deletes_postings.process(stats["vnode_index_deletes_postings"])
	  report_metric "read_repairs", "read_repairs", @read_repairs.process(stats["read_repairs"])
	  report_metric "vnode_gets_total", "vnode_gets_total", @vnode_gets_total.process(stats["vnode_gets_total"])
	  report_metric "vnode_puts_total", "vnode_puts_total", @vnode_puts_total.process(stats["vnode_puts_total"])
	  report_metric "vnode_index_reads_total", "vnode_index_reads_total", @vnode_index_reads_total.process(stats["vnode_index_reads_total"])
	  report_metric "vnode_index_reads_total", "vnode_index_reads_total", @vnode_index_reads_total.process(stats["vnode_index_reads_total"])
	  report_metric "vnode_index_writes_postings_total", "vnode_index_writes_postings_total", @vnode_index_writes_postings_total.process(stats["vnode_index_writes_postings_total"])
	  report_metric "vnode_index_deletes_total", "vnode_index_deletes_total", @vnode_index_deletes_total.process(stats["vnode_index_deletes_total"])
	  report_metric "vnode_index_deletes_postings_total", "vnode_index_deletes_postings_total", @vnode_index_deletes_postings_total.process(stats["vnode_index_deletes_postings_total"])
	  report_metric "node_gets", "node_gets", @node_gets.process(stats["node_gets"])
	  report_metric "node_gets_total", "node_gets_total", @node_gets_total.process(stats["node_gets_total"])
	  report_metric "node_get_fsm_time_mean", "node_get_fsm_time_mean", @node_get_fsm_time_mean.process(stats["node_get_fsm_time_mean"])
	  report_metric "node_get_fsm_time_median", "node_get_fsm_time_median", @node_get_fsm_time_median.process(stats["node_get_fsm_time_median"])
	  report_metric "node_get_fsm_time_95", "node_get_fsm_time_95", @node_get_fsm_time_95.process(stats["node_get_fsm_time_95"])
	  report_metric "node_get_fsm_time_99", "node_get_fsm_time_99", @node_get_fsm_time_99.process(stats["node_get_fsm_time_99"])
	  report_metric "node_get_fsm_time_100", "node_get_fsm_time_100", @node_get_fsm_time_100.process(stats["node_get_fsm_time_100"])
	  report_metric "node_puts", "node_puts", @node_puts.process(stats["node_puts"])
	  report_metric "node_puts_total", "node_puts_total", @node_puts_total.process(stats["node_puts_total"])
	  report_metric "node_put_fsm_time_mean", "node_put_fsm_time_mean", @node_put_fsm_time_mean.process(stats["node_put_fsm_time_mean"])
	  report_metric "node_put_fsm_time_median", "node_put_fsm_time_median", @node_put_fsm_time_median.process(stats["node_put_fsm_time_median"])
	  report_metric "node_put_fsm_time_95", "node_put_fsm_time_95", @node_put_fsm_time_95.process(stats["node_put_fsm_time_95"])
	  report_metric "node_put_fsm_time_99", "node_put_fsm_time_99", @node_put_fsm_time_99.process(stats["node_put_fsm_time_99"])
	  report_metric "node_put_fsm_time_100", "node_put_fsm_time_100", @node_put_fsm_time_100.process(stats["node_put_fsm_time_100"])
	  report_metric "node_get_fsm_siblings_mean", "node_get_fsm_siblings_mean", @node_get_fsm_siblings_mean.process(stats["node_get_fsm_siblings_mean"])
	  report_metric "node_get_fsm_siblings_median", "node_get_fsm_siblings_median", @node_get_fsm_siblings_median.process(stats["node_get_fsm_siblings_median"])
	  report_metric "node_get_fsm_siblings_95", "node_get_fsm_siblings_95", @node_get_fsm_siblings_95.process(stats["node_get_fsm_siblings_95"])
	  report_metric "node_get_fsm_siblings_99", "node_get_fsm_siblings_99", @node_get_fsm_siblings_99.process(stats["node_get_fsm_siblings_99"])
	  report_metric "node_get_fsm_siblings_100", "node_get_fsm_siblings_100", @node_get_fsm_siblings_100.process(stats["node_get_fsm_siblings_100"])
	  report_metric "node_get_fsm_objsize_mean", "node_get_fsm_objsize_mean", @node_get_fsm_objsize_mean.process(stats["node_get_fsm_objsize_mean"])
	  report_metric "node_get_fsm_objsize_median", "node_get_fsm_objsize_median", @node_get_fsm_objsize_median.process(stats["node_get_fsm_objsize_median"])
	  report_metric "node_get_fsm_objsize_95", "node_get_fsm_objsize_95", @node_get_fsm_objsize_95.process(stats["node_get_fsm_objsize_95"])
	  report_metric "node_get_fsm_objsize_99", "node_get_fsm_objsize_99", @node_get_fsm_objsize_99.process(stats["node_get_fsm_objsize_99"])
	  report_metric "node_get_fsm_objsize_100", "node_get_fsm_objsize_100", @node_get_fsm_objsize_100.process(stats["node_get_fsm_objsize_100"])
	  report_metric "read_repairs_total", "read_repairs_total", @read_repairs_total.process(stats["read_repairs_total"])
	  report_metric "coord_redirs_total", "coord_redirs_total", @coord_redirs_total.process(stats["coord_redirs_total"])
	  report_metric "precommit_fail", "precommit_fail", @precommit_fail.process(stats["precommit_fail"])
	  report_metric "postcommit_fail", "postcommit_fail", @postcommit_fail.process(stats["postcommit_fail"])
	  report_metric "cpu_nprocs", "cpu_nprocs", @cpu_nprocs.process(stats["cpu_nprocs"])
	  report_metric "cpu_avg1", "cpu_avg1", @cpu_avg1.process(stats["cpu_avg1"])
	  report_metric "cpu_avg5", "cpu_avg5", @cpu_avg5.process(stats["cpu_avg5"])
	  report_metric "cpu_avg15", "cpu_avg15", @cpu_avg15.process(stats["cpu_avg15"])
	  report_metric "mem_total", "mem_total", @mem_total.process(stats["mem_total"])
	  report_metric "mem_allocated", "mem_allocated", @mem_allocated.process(stats["mem_allocated"])
	  report_metric "sys_process_count", "sys_process_count", @sys_process_count.process(stats["sys_process_count"])
	  report_metric "pbc_connects_total", "pbc_connects_total", @pbc_connects_total.process(stats["pbc_connects_total"])
	  report_metric "pbc_connects", "pbc_connects", @pbc_connects.process(stats["pbc_connects"])
	  report_metric "pbc_active", "pbc_active", @pbc_active.process(stats["pbc_active"])
	  report_metric "executing_mappers", "executing_mappers", @executing_mappers.process(stats["executing_mappers"])
	  report_metric "memory_total", "memory_total", @memory_total.process(stats["memory_total"])
	  report_metric "memory_processes", "memory_processes", @memory_processes.process(stats["memory_processes"])
	  report_metric "memory_processes_used", "memory_processes_used", @memory_processes_used.process(stats["memory_processes_used"])
	  report_metric "memory_system", "memory_system", @memory_system.process(stats["memory_system"])
	  report_metric "memory_atom", "memory_atom", @memory_atom.process(stats["memory_atom"])
	  report_metric "memory_atom_used", "memory_atom_used", @memory_atom_used.process(stats["memory_atom_used"])
	  report_metric "memory_binary", "memory_binary", @memory_binary.process(stats["memory_binary"])
	  report_metric "memory_code", "memory_code", @memory_code.process(stats["memory_code"])
	  report_metric "memory_ets", "memory_ets", @memory_ets.process(stats["memory_ets"])
	  report_metric "ignored_gossip_total", "ignored_gossip_total", @ignored_gossip_total.process(stats["ignored_gossip_total"])
	  report_metric "rings_reconciled_total", "rings_reconciled_total", @rings_reconciled_total.process(stats["rings_reconciled_total"])
	  report_metric "rings_reconciled", "rings_reconciled", @rings_reconciled.process(stats["rings_reconciled"])
	  report_metric "gossip_received", "gossip_received", @gossip_received.process(stats["gossip_received"])
	  report_metric "handoff_timeouts", "handoff_timeouts", @handoff_timeouts.process(stats["handoff_timeouts"])
	  report_metric "converge_delay_min", "converge_delay_min", @converge_delay_min.process(stats["converge_delay_min"])
	  report_metric "converge_delay_max", "converge_delay_max", @converge_delay_max.process(stats["converge_delay_max"])
	  report_metric "converge_delay_mean", "converge_delay_mean", @converge_delay_mean.process(stats["converge_delay_mean"])
	  report_metric "converge_delay_last", "converge_delay_last", @converge_delay_last.process(stats["converge_delay_last"])
	  report_metric "rebalance_delay_min", "rebalance_delay_min", @rebalance_delay_min.process(stats["rebalance_delay_min"])
	  report_metric "rebalance_delay_max", "rebalance_delay_max", @rebalance_delay_max.process(stats["rebalance_delay_max"])
	  report_metric "rebalance_delay_mean", "rebalance_delay_mean", @rebalance_delay_mean.process(stats["rebalance_delay_mean"])
	  report_metric "rebalance_delay_last", "rebalance_delay_last", @rebalance_delay_last.process(stats["rebalance_delay_last"])
	  report_metric "riak_kv_vnodes_running", "riak_kv_vnodes_running", @riak_kv_vnodes_running.process(stats["riak_kv_vnodes_running"])
	  report_metric "riak_kv_vnodeq_min", "riak_kv_vnodeq_min", @riak_kv_vnodeq_min.process(stats["riak_kv_vnodeq_min"])
	  report_metric "riak_kv_vnodeq_median", "riak_kv_vnodeq_median", @riak_kv_vnodeq_median.process(stats["riak_kv_vnodeq_median"])
	  report_metric "riak_kv_vnodeq_mean", "riak_kv_vnodeq_mean", @riak_kv_vnodeq_mean.process(stats["riak_kv_vnodeq_mean"])
	  report_metric "riak_kv_vnodeq_max", "riak_kv_vnodeq_max", @riak_kv_vnodeq_max.process(stats["riak_kv_vnodeq_max"])
	  report_metric "riak_kv_vnodeq_total", "riak_kv_vnodeq_total", @riak_kv_vnodeq_total.process(stats["riak_kv_vnodeq_total"])
	  report_metric "riak_pipe_vnodes_running", "riak_pipe_vnodes_running", @riak_pipe_vnodes_running.process(stats["riak_pipe_vnodes_running"])
	  report_metric "riak_pipe_vnodeq_min", "riak_pipe_vnodeq_min", @riak_pipe_vnodeq_min.process(stats["riak_pipe_vnodeq_min"])
	  report_metric "riak_pipe_vnodeq_median", "riak_pipe_vnodeq_median", @riak_pipe_vnodeq_median.process(stats["riak_pipe_vnodeq_median"])
	  report_metric "riak_pipe_vnodeq_mean", "riak_pipe_vnodeq_mean", @riak_pipe_vnodeq_mean.process(stats["riak_pipe_vnodeq_mean"])
	  report_metric "riak_pipe_vnodeq_max", "riak_pipe_vnodeq_max", @riak_pipe_vnodeq_max.process(stats["riak_pipe_vnodeq_max"])
	  report_metric "riak_pipe_vnodeq_total", "riak_pipe_vnodeq_total", @riak_pipe_vnodeq_total.process(stats["riak_pipe_vnodeq_total"])
	  report_metric "riak_search_vnodes_running", "riak_search_vnodes_running", @riak_search_vnodes_running.process(stats["riak_search_vnodes_running"])
	  report_metric "riak_search_vnodeq_min", "riak_search_vnodeq_min", @riak_search_vnodeq_min.process(stats["riak_search_vnodeq_min"])
	  report_metric "riak_search_vnodeq_median", "riak_search_vnodeq_median", @riak_search_vnodeq_median.process(stats["riak_search_vnodeq_median"])
	  report_metric "riak_search_vnodeq_mean", "riak_search_vnodeq_mean", @riak_search_vnodeq_mean.process(stats["riak_search_vnodeq_mean"])
	  report_metric "riak_search_vnodeq_max", "riak_search_vnodeq_max", @riak_search_vnodeq_max.process(stats["riak_search_vnodeq_max"])
	  report_metric "riak_search_vnodeq_total", "riak_search_vnodeq_total", @riak_search_vnodeq_total.process(stats["riak_search_vnodeq_total"])
    end
  end

  #
  # Register this agent
  #
  NewRelic::Plugin::Setup.install_agent :riak, RiakAgent

  #
  # Launch the agent (never returns)
  #
  NewRelic::Plugin::Run.setup_and_run

end