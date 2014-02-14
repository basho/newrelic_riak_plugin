#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'newrelic_plugin'
require 'rest-client'
require 'json'

module RiakAgent

  class Metric

    attr_reader :key, :name, :unit

    def initialize(key, name, unit)
      @key = key
      @name = name
      @unit = unit
    end

  end

  class Agent < NewRelic::Plugin::Agent::Base
    agent_guid 'com.basho.riak_agent'
    agent_version '0.1.0'
    agent_human_labels('Riak') { "#{host}:#{port}" }
    agent_config_options :host, :port

    def setup_metrics

      @metrics = [
          Metric.new('vnode_gets', 'VNode/Gets', 'Operations/Seconds'),
          Metric.new('vnode_puts', 'VNode/Puts', 'Operations/Seconds'),
          Metric.new('vnode_gets_total', 'VNode/Gets/Total', 'Operations'),
          Metric.new('vnode_puts_total', 'VNode/Puts/Total', 'Operations'),
          Metric.new('vnode_index_reads', 'VNode/Index/Reads/Rate', 'Indexes/Seconds'),
          Metric.new('vnode_index_writes', 'VNode/Index/Writes/Rate', 'Indexes/Seconds'),
          Metric.new('vnode_index_deletes', 'VNode/Index/Deletes/Rate', 'Indexes/Seconds'),
          Metric.new('vnode_index_reads_total', 'VNode/Index/Reads/Total', 'Indexes'),
          Metric.new('vnode_index_writes_total', 'VNode/Index/Writes/Total', 'Indexes'),
          Metric.new('vnode_index_deletes_total', 'VNode/Index/Deletes/Total', 'Indexes'),
          Metric.new('vnode_index_writes_postings', 'VNode/Index/Writes/Postings', 'Postings/Seconds'),
          Metric.new('vnode_index_deletes_postings', 'VNode/Index/Deletes/Postings', 'Postings/Seconds'),
          Metric.new('vnode_index_writes_postings_total', 'VNode/Index/Writes/Postings/Total', 'Postings'),
          Metric.new('vnode_index_deletes_postings_total', 'VNode/Index/Deletes/Postings/Total', 'Postings'),
          Metric.new('read_repairs', 'Read Repairs/Rate', 'Repairs/Seconds'),
          Metric.new('read_repairs_total', 'Read Repairs/Total', 'Repairs'),
          Metric.new('coord_redirs_total', 'Node/Redirects/Total', 'Redirects'),
          Metric.new('node_gets', 'Node/Gets/Rate', 'Operations/Seconds'),
          Metric.new('node_gets_total', 'Node/Gets/Total', 'Operations'),
          Metric.new('node_get_fsm_time_mean', 'Node/Get/FSM/Time/Mean', 'Microseconds'),
          Metric.new('node_get_fsm_time_median', 'Node/Get/FSM/Time/Median', 'Microseconds'),
          Metric.new('node_get_fsm_time_95', 'Node/Get/FSM/Time/95', 'Microseconds'),
          Metric.new('node_get_fsm_time_99', 'Node/Get/FSM/Time/99', 'Microseconds'),
          Metric.new('node_get_fsm_time_100', 'Node/Get/FSM/Time/100', 'Microseconds'),
          Metric.new('node_puts', 'Node/Puts/Rate', 'Operations/Seconds'),
          Metric.new('node_puts_total', 'Node/Puts/Total', 'Operations'),
          Metric.new('node_put_fsm_time_mean', 'Node/Put/FSM/Time/Mean', 'Microseconds'),
          Metric.new('node_put_fsm_time_median', 'Node/Put/FSM/Time/Median', 'Microseconds'),
          Metric.new('node_put_fsm_time_95', 'Node/Put/FSM/Time/95', 'Microseconds'),
          Metric.new('node_put_fsm_time_99', 'Node/Put/FSM/Time/99', 'Microseconds'),
          Metric.new('node_put_fsm_time_100', 'Node/Put/FSM/Time/100', 'Microseconds'),
          Metric.new('node_get_fsm_siblings_mean', 'Node/Get/FSM/Siblings/Mean', 'Siblings'),
          Metric.new('node_get_fsm_siblings_median', 'Node/Get/FSM/Siblings/Median', 'Siblings'),
          Metric.new('node_get_fsm_siblings_95', 'Node/Get/FSM/Siblings/95', 'Siblings'),
          Metric.new('node_get_fsm_siblings_99', 'Node/Get/FSM/Siblings/99', 'Siblings'),
          Metric.new('node_get_fsm_siblings_100', 'Node/Get/FSM/Siblings/100', 'Siblings'),
          Metric.new('node_get_fsm_objsize_mean', 'Node/Get/FSM/ObjectSize/Mean', 'Bytes'),
          Metric.new('node_get_fsm_objsize_median', 'Node/Get/FSM/ObjectSize/Median', 'Bytes'),
          Metric.new('node_get_fsm_objsize_95', 'Node/Get/FSM/ObjectSize/95', 'Bytes'),
          Metric.new('node_get_fsm_objsize_99', 'Node/Get/FSM/ObjectSize/99', 'Bytes'),
          Metric.new('node_get_fsm_objsize_100', 'Node/Get/FSM/ObjectSize/100', 'Bytes'),
          Metric.new('precommit_fail', 'Failures/Pre-commit', 'Failures'),
          Metric.new('postcommit_fail', 'Failures/Post-commit', 'Failures'),
          Metric.new('cpu_nprocs', 'CPU/Processes/Total', 'Processes'),
          Metric.new('cpu_avg1', 'CPU/Processes/Average/1Minute', 'Processes/Seconds'),
          Metric.new('cpu_avg5', 'CPU/Processes/Average/5Minute', 'Processes/Seconds'),
          Metric.new('cpu_avg15', 'CPU/Processes/Average/15Minute', 'Processes/Seconds'),
          Metric.new('sys_process_count', 'Sys/Processes/Total', 'Processes'),
          Metric.new('pbc_connects_total', 'PBC/Connections/Total', 'Connections'),
          Metric.new('pbc_connects', 'PBC/Connections/Rate', 'Connections/Seconds'),
          Metric.new('pbc_active', 'PBC/Connections/Active', 'Connections'),
          Metric.new('executing_mappers', 'Mappers/Executing', 'Mappers'),
          Metric.new('mem_total', 'Memory/Available/Total', 'Bytes'),
          Metric.new('memory_total', 'Memory/Allocated/Total', 'Bytes'),
          Metric.new('mem_allocated', 'Memory/Allocated/Node', 'Bytes'),
          Metric.new('memory_processes', 'Memory/Allocated/Processes', 'Bytes'),
          Metric.new('memory_system', 'Memory/Allocated/System', 'Bytes'),
          Metric.new('memory_atom', 'Memory/Allocated/Atom', 'Bytes'),
          Metric.new('memory_code', 'Memory/Allocated/Code', 'Bytes'),
          Metric.new('memory_ets', 'Memory/Allocated/Ets', 'Bytes'),
          Metric.new('memory_atom_used', 'Memory/Used/Atom', 'Bytes'),
          Metric.new('memory_binary', 'Memory/Used/Binaries', 'Bytes'),
          Metric.new('memory_processes_used', 'Memory/Used/Processes', 'Bytes'),
          Metric.new('ignored_gossip_total', 'Gossip/Ignored ', 'Messages'),
          Metric.new('gossip_received', 'Gossip/Received', 'Messages'),
          Metric.new('rings_reconciled_total', 'Rings/Reconciled/Total', 'Rings'),
          Metric.new('rings_reconciled', 'Rings/Reconciled/Rate', 'Rings/Seconds'),
          Metric.new('handoff_timeouts', 'Hand-off Timeouts', 'Timeouts'),
          Metric.new('converge_delay_min', 'Converge/Delay/Min', 'Microseconds'),
          Metric.new('converge_delay_max', 'Converge/Delay/Max', 'Microseconds'),
          Metric.new('converge_delay_mean', 'Converge/Delay/Mean', 'Microseconds'),
          Metric.new('converge_delay_last', 'Converge/Delay/Last', 'Microseconds'),
          Metric.new('rebalance_delay_min', 'Re-balance/Delay/Min', 'Microseconds'),
          Metric.new('rebalance_delay_max', 'Re-balance/Delay/Max', 'Microseconds'),
          Metric.new('rebalance_delay_mean', 'Re-balance/Delay/Mean', 'Microseconds'),
          Metric.new('rebalance_delay_last', 'Re-balance/Delay/Last', 'Microseconds'),
          Metric.new('riak_kv_vnodes_running', 'KV/VNodes/Running', 'VNodes'),
          Metric.new('riak_kv_vnodeq_min', 'KV/VNode/Queue/Min', 'Messages'),
          Metric.new('riak_kv_vnodeq_median', 'KV/VNode/Queue/Median', 'Messages'),
          Metric.new('riak_kv_vnodeq_mean', 'KV/VNode/Queue/Mean', 'Messages'),
          Metric.new('riak_kv_vnodeq_max', 'KV/VNode/Queue/Max', 'Messages'),
          Metric.new('riak_kv_vnodeq_total', 'KV/VNode/Queue/Total', 'Messages'),
          Metric.new('riak_pipe_vnodes_running', 'Pipe/VNodes/Running', 'VNodes'),
          Metric.new('riak_pipe_vnodeq_min', 'Pipe/VNode/Queue/Min', 'Messages'),
          Metric.new('riak_pipe_vnodeq_median', 'Pipe/VNode/Queue/Min', 'Messages'),
          Metric.new('riak_pipe_vnodeq_mean', 'Pipe/VNode/Queue/Min', 'Messages'),
          Metric.new('riak_pipe_vnodeq_max', 'Pipe/VNode/Queue/Min', 'Messages'),
          Metric.new('riak_pipe_vnodeq_total', 'Pipe/VNode/Queue/Min', 'Messages'),
          Metric.new('riak_search_vnodes_running', 'Search/VNodes/Running', 'VNodes'),
          Metric.new('riak_search_vnodeq_min', 'Search/VNode/Queue/Min', 'Messages'),
          Metric.new('riak_search_vnodeq_median', 'Search/VNode/Queue/Median', 'Messages'),
          Metric.new('riak_search_vnodeq_mean', 'Search/VNode/Queue/Mean', 'Messages'),
          Metric.new('riak_search_vnodeq_max', 'Search/VNode/Queue/Max', 'Messages'),
          Metric.new('riak_search_vnodeq_total', 'Search/VNode/Queue/Total', 'Messages')
      ]
    end

    def poll_cycle
      results = RestClient.get "http://#{host}:#{port}/stats"
      stats = JSON.parse(results)

      @metrics.each do |metric|
        report_metric(metric.name, metric.unit, stats[metric.key])
      end

    end
  end

  NewRelic::Plugin::Setup.install_agent :riak, RiakAgent
  NewRelic::Plugin::Run.setup_and_run
end

