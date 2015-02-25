#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'newrelic_plugin'
require 'rest-client'
require 'json'
require 'socket'

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
    agent_version '1.0.1'
    agent_human_labels('Riak') { "#{nodename}" }
    agent_config_options :host, :port, :nodename, :hostname

    def setup_metrics

      self.port ||= 8098
      self.host ||= "127.0.0.1"
      unless self.hostname
        begin
          self.hostname ||= Socket.gethostname
        rescue
          self.hostname = "localhost"
        end
      end
      unless self.nodename
        begin
          results = RestClient.get "http://#{self.host}:#{self.port}/stats"
          stats = JSON.parse(results)
          self.nodename = stats['nodename']
        rescue
          self.nodename = "riak@#{self.hostname}"
        end
      end

      @metrics = [
        Metric.new('vnode_gets_total', 'VNode/Gets/Total', 'Operations'),
        Metric.new('vnode_puts_total', 'VNode/Puts/Total', 'Operations'),
        Metric.new('read_repairs_total', 'Read Repairs/Total', 'Repairs'),
        Metric.new('coord_redirs_total', 'Node/Redirects/Total', 'Redirects'),
        Metric.new('node_gets_total', 'Node/Gets/Total', 'Operations'),
        Metric.new('node_get_fsm_time_mean', 'Node/Get/FSM/Time/Mean', 'Microseconds'),
        Metric.new('node_get_fsm_time_median', 'Node/Get/FSM/Time/Median', 'Microseconds'),
        Metric.new('node_get_fsm_time_95', 'Node/Get/FSM/Time/95', 'Microseconds'),
        Metric.new('node_get_fsm_time_99', 'Node/Get/FSM/Time/99', 'Microseconds'),
        Metric.new('node_get_fsm_time_100', 'Node/Get/FSM/Time/100', 'Microseconds'),
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
        Metric.new('sys_process_count', 'Sys/Processes/Total', 'Processes'),
        Metric.new('pbc_connects_total', 'PBC/Connections/Total', 'Connections'),
        Metric.new('pbc_active', 'PBC/Connections/Active', 'Connections'),
        Metric.new('memory_processes_used', 'Memory/Used/Processes', 'Bytes'),
        Metric.new('consistent_gets_total', 'Consistent/Gets/Total', 'Operations'),
        Metric.new('consistent_puts_total', 'Consistent/Puts/Total', 'Operations'),
        Metric.new('node_get_fsm_rejected_total', 'Node/Get/FSM/Rejected/Total', 'Rejections'),
        Metric.new('node_gets_counter_total', 'Node/Gets/Counter/Total', 'Operations'),
        Metric.new('node_gets_map_total', 'Node/Gets/Map/Total', 'Operations'),
        Metric.new('node_gets_set_total', 'Node/Gets/Set/Total', 'Operations'),
        Metric.new('node_put_fsm_rejected_total', 'Node/Put/FSM/Rejected/Total', 'Rejections'),
        Metric.new('node_puts_counter_total', 'Node/Puts/Counter/Total', 'Operations'),
        Metric.new('node_puts_map_total', 'Node/Puts/Map/Total', 'Operations'),
        Metric.new('node_puts_set_total', 'Node/Puts/Set/Total', 'Operations'),
        Metric.new('search_index_fail_count', 'Search/Index/Fail/Total', 'Failures'),
        Metric.new('search_index_fail_one', 'Search/Index/Fail/One', 'Failures'),
        Metric.new('search_index_latency_95', 'Search/Index/Latency/95', 'Microseconds'),
        Metric.new('search_index_latency_99', 'Search/Index/Latency/99', 'Microseconds'),
        Metric.new('search_index_latency_999', 'Search/Index/Latency/999', 'Microseconds'),
        Metric.new('search_index_latency_max', 'Search/Index/Latency/Max', 'Microseconds'),
        Metric.new('search_index_latency_median', 'Search/Index/Latency/Median', 'Microseconds'),
        Metric.new('search_index_latency_min', 'Search/Index/Latency/Min', 'Microseconds'),
        Metric.new('search_index_throughput_count', 'Search/Index/Throughput/Total', 'Operations'),
        Metric.new('search_index_throughtput_one', 'Search/Index/Throughtput/One', 'Operations'),
        Metric.new('search_query_fail_count', 'Search/Query/Fail/Total', 'Failures'),
        Metric.new('search_query_fail_one', 'Search/Query/Fail/One', 'Failures'),
        Metric.new('search_query_latency_95', 'Search/Query/Latency/95', 'Microseconds'),
        Metric.new('search_query_latency_99', 'Search/Query/Latency/99', 'Microseconds'),
        Metric.new('search_query_latency_999', 'Search/Query/Latency/999', 'Microseconds'),
        Metric.new('search_query_latency_max', 'Search/Query/Latency/Max', 'Microseconds'),
        Metric.new('search_query_latency_median', 'Search/Query/Latency/Median', 'Microseconds'),
        Metric.new('search_query_latency_min', 'Search/Query/Latency/Min', 'Microseconds'),
        Metric.new('search_query_throughput_count', 'Search/Query/Throughput/Total', 'Operations'),
        Metric.new('search_query_throughput_one', 'Search/Query/Throughput/One', 'Operations'),
        Metric.new('vnode_counter_update_total', 'VNode/Counter/Update/Total', 'Operations'),
        Metric.new('vnode_map_update_total', 'VNode/Map/Update/Total', 'Operations'),
        Metric.new('vnode_set_update_total', 'VNode/Set/Update/Total', 'Operations')
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
