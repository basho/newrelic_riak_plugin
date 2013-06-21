#Title: New Relic Riak Agent

##Description:
The New Relic Riak Agent serves node statistics of a Riak Node to the New Relic APM System via the web API available for plugins. The plugin is written in Ruby, with the code available on github under Apache 2.0 License.

##Plugin Requirements:

   * Installed [Erlang v R15B01](http://docs.basho.com/riak/1.2.0/tutorials/installation/Installing-Erlang/#Installing-on-GNU-Linux).
   * Install [Riak](http://docs.basho.com/riak/latest/tutorials/installation/).
   * Ruby >= 1.8.7
   * Rubygems >= 1.8
   * Bundler >= 1.3.0
   * Git >= 1.8

##Installation:

   * Download this repository to the folder you'd like to execute it from.
   * Navigate to the folder that the plugin is downloaded to.
   * Run `bundle install`
   * Edit the config/newrelic_plugin.yml file and add your New Relic License key where the value "YOUR_LICENSE_KEY_HERE" is at.
   * Edit the riak_agent.rb file and change the GUID to something unique to your application (it's set by default to 'com.basho.riak_agent')
   * Run `bundle exec ./riak_agent.rb` or `./riak_agent.rb` to start the plugin and start measuring stats against the executing Riak node.
   * That's it, you'll now see metrics start to trickle into your dashboard with your executing plugin.

##Summary of Metrics:

For more information on the meaning of these metrics, please visit [docs.basho.com](http://docs.basho.com/riak/1.3.1/references/apis/http/HTTP-Status/).

| Riak Stat     | New Relic Stat | Unit of Measure |
| ------------ | ------------- | ------------ |
| vnode_gets | VNode/Gets/Rate | Operations/Seconds |
| vnode_puts | VNode/Puts/Rate | Operations/Seconds |
| vnode_gets_total | VNode/Gets/Total | Operations |
| vnode_puts_total | VNode/Puts/Total | Operations |
| vnode_index_reads | VNode/Index/Reads | Indexes/Seconds |
| vnode_index_writes | VNode/Index/Writes | Indexes/Seconds |
| vnode_index_deletes | VNode/Index/Deletes | Indexes/Seconds |
| vnode_index_reads_total | VNode/Index/Reads/Total | Indexes |
| vnode_index_writes_total | VNode/Index/Writes/Total | Indexes |
| vnode_index_deletes_total | VNode/Index/Deletes/Total | Indexes |
| vnode_index_writes_postings | VNode/Index/Writes/Postings | Postings/Seconds |
| vnode_index_deletes_postings | VNode/Index/Deletes/Postings | Postings/Seconds |
| vnode_index_writes_postings_total | VNode/Index/Writes/Postings/Total | Postings |
| vnode_index_deletes_postings_total | VNode/Index/Deletes/Postings/Total | Postings |
| read_repairs | Read Repairs/Rate | Repairs/Seconds |
| read_repairs_total | Read Repairs/Total | Repairs |
| coord_redirs_total | Node/Redirects/Total | Redirects |
| node_gets | Node/Gets/Rate | Operations/Seconds |
| node_gets_total | Node/Gets/Total | Operations |
| node_get_fsm_time_mean | Node/Get/FSM/Time/Mean | Microseconds |
| node_get_fsm_time_median | Node/Get/FSM/Time/Median | Microseconds |
| node_get_fsm_time_95 | Node/Get/FSM/Time/95 | Microseconds |
| node_get_fsm_time_99 | Node/Get/FSM/Time/99 | Microseconds |
| node_get_fsm_time_100 | Node/Get/FSM/Time/100 | Microseconds |
| node_puts | Node/Puts/Rate | Operations/Seconds |
| node_puts_total | Node/Puts/Total | Operations |
| node_put_fsm_time_mean | Node/Put/FSM/Time/Mean | Microseconds |
| node_put_fsm_time_median | Node/Put/FSM/Time/Median | Microseconds |
| node_put_fsm_time_95 | Node/Put/FSM/Time/95 | Microseconds |
| node_put_fsm_time_99 | Node/Put/FSM/Time/99 | Microseconds |
| node_put_fsm_time_100 | Node/Put/FSM/Time/100 | Microseconds |
| node_get_fsm_siblings_mean | Node/Get/FSM/Siblings/Mean | Siblings |
| node_get_fsm_siblings_median | Node/Get/FSM/Siblings/Median | Siblings |
| node_get_fsm_siblings_95 | Node/Get/FSM/Siblings/95 | Siblings |
| node_get_fsm_siblings_99 | Node/Get/FSM/Siblings/99 | Siblings |
| node_get_fsm_siblings_100 | Node/Get/FSM/Siblings/100 | Siblings |
| node_get_fsm_objsize_mean | Node/Get/FSM/ObjectSize/Mean | Bytes |
| node_get_fsm_objsize_median | Node/Get/FSM/ObjectSize/Median | Bytes |
| node_get_fsm_objsize_95 | Node/Get/FSM/ObjectSize/95 | Bytes |
| node_get_fsm_objsize_99 | Node/Get/FSM/ObjectSize/99 | Bytes |
| node_get_fsm_objsize_100 | Node/Get/FSM/ObjectSize/100 | Bytes |
| precommit_fail | Failures/Pre-commit | Failures |
| postcommit_fail | Failures/Post-commit | Failures |
| cpu_nprocs | CPU/Processes/Total | Processes |
| cpu_avg1 | CPU/Processes/Average/1Minute | Processes/Seconds |
| cpu_avg5 | CPU/Processes/Average/5Minute | Processes/Seconds |
| cpu_avg15 | CPU/Processes/Average/15Minute | Processes/Seconds |
| sys_process_count | Sys/Processes/Total | Processes |
| pbc_connects_total | PBC/Connections/Total | Connections |
| pbc_connects | PBC/Connections/Rate | Connections/Seconds |
| pbc_active | PBC/Connections/Active | Connections |
| executing_mappers | Mappers/Executing | Mappers |
| mem_total | Memory/Available/Total | Bytes |
| memory_total | Memory/Allocated/Total | Bytes |
| mem_allocated | Memory/Allocated/Node | Bytes |
| memory_processes | Memory/Allocated/Processes | Bytes |
| memory_system | Memory/Allocated/System | Bytes |
| memory_atom | Memory/Allocated/Atom | Bytes |
| memory_code | Memory/Allocated/Code | Bytes |
| memory_ets | Memory/Allocated/Ets | Bytes |
| memory_atom_used | Memory/Used/Atom | Bytes |
| memory_binary | Memory/Used/Binaries | Bytes |
| memory_processes_used | Memory/Used/Processes | Bytes |
| ignored_gossip_total | Gossip/Ignored  | Messages |
| gossip_received | Gossip/Received | Messages |
| rings_reconciled_total | Rings/Reconciled/Total | Rings |
| rings_reconciled | Rings/Reconciled/Rate | Rings/Seconds |
| handoff_timeouts | Hand-off Timeouts | Timeouts |
| converge_delay_min | Converge/Delay/Min | Microseconds |
| converge_delay_max | Converge/Delay/Max | Microseconds |
| converge_delay_mean | Converge/Delay/Mean | Microseconds |
| converge_delay_last | Converge/Delay/Last | Microseconds |
| rebalance_delay_min | Re-balance/Delay/Min | Microseconds |
| rebalance_delay_max | Re-balance/Delay/Max | Microseconds |
| rebalance_delay_mean | Re-balance/Delay/Mean | Microseconds |
| rebalance_delay_last | Re-balance/Delay/Last | Microseconds |
| riak_kv_vnodes_running | KV/VNodes/Running | VNodes |
| riak_kv_vnodeq_min | KV/VNode/Queue/Min | Messages |
| riak_kv_vnodeq_median | KV/VNode/Queue/Median | Messages |
| riak_kv_vnodeq_mean | KV/VNode/Queue/Mean | Messages |
| riak_kv_vnodeq_max | KV/VNode/Queue/Max | Messages |
| riak_kv_vnodeq_total | KV/VNode/Queue/Total | Messages |
| riak_pipe_vnodes_running | Pipe/VNodes/Running | VNodes |
| riak_pipe_vnodeq_min | Pipe/VNode/Queue/Min | Messages |
| riak_pipe_vnodeq_median | Pipe/VNode/Queue/Min | Messages |
| riak_pipe_vnodeq_mean | Pipe/VNode/Queue/Min | Messages |
| riak_pipe_vnodeq_max | Pipe/VNode/Queue/Min | Messages |
| riak_pipe_vnodeq_total | Pipe/VNode/Queue/Min | Messages |
| riak_search_vnodes_running | Search/VNodes/Running | VNodes |
| riak_search_vnodeq_min | Search/VNode/Queue/Min | Messages |
| riak_search_vnodeq_median | Search/VNode/Queue/Median | Messages |
| riak_search_vnodeq_mean | Search/VNode/Queue/Mean | Messages |
| riak_search_vnodeq_max | Search/VNode/Queue/Max | Messages |
| riak_search_vnodeq_total | Search/VNode/Queue/Total | Messages |
