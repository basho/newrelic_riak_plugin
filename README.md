#Title: New Relic Riak Agent

##Description:
The New Relic Riak Agent serves node statistics of a Riak Node to the New Relic APM System via the web API available for plugins. The plugin is written in Ruby, with the code available on github under Apache 2.0 License.

##Plugin Requirements:

   * Install [Riak](http://docs.basho.com/riak/latest/tutorials/installation/).
   * Ruby >= 1.8.7
   * Rubygems >= 1.8
   * Bundler >= 1.3.0
   * Git >= 1.8

##Installation:

   * Download this repository to the folder you'd like to execute it from.
   * Navigate to the folder that the plugin is downloaded to.
   * Run `bundle install`
   * Copy ```config/newrelic_plugin.example.yml``` to ```config/newrelic_plugin.yml```
   * Edit ```config/newrelic_plugin.yml```, replacing LICENCE with your New Relic License key.
   * Edit the riak_agent.rb file and change the GUID to something unique to your application (it's set by default to 'com.basho.riak_agent')
   * Run `bundle exec ./riak_agent.rb` or `./riak_agent.rb` to start.
 
## Testing

* Create ```newrelic.key``` that just contains your New Relic license key:

		aabbccddeeffgg

* Run ```vagrant up``` ([Vagrant](https://www.vagrantup.com/))

##Summary of Metrics:

For more information on the meaning of these metrics, please visit [docs.basho.com](http://docs.basho.com/riak/latest/ops/running/nodes/inspecting/).

| Riak Stat     | New Relic Stat | Unit of Measure |
| ------------ | ------------- | ------------ |
| vnode_gets_total | VNode/Gets/Total | Operations |
| vnode_puts_total | VNode/Puts/Total | Operations |
| read_repairs_total | Read Repairs/Total | Repairs |
| coord_redirs_total | Node/Redirects/Total | Redirects |
| node_gets_total | Node/Gets/Total | Operations |
| node_get_fsm_time_mean | Node/Get/FSM/Time/Mean | Microseconds |
| node_get_fsm_time_median | Node/Get/FSM/Time/Median | Microseconds |
| node_get_fsm_time_95 | Node/Get/FSM/Time/95 | Microseconds |
| node_get_fsm_time_99 | Node/Get/FSM/Time/99 | Microseconds |
| node_get_fsm_time_100 | Node/Get/FSM/Time/100 | Microseconds |
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
| sys_process_count | Sys/Processes/Total | Processes |
| pbc_connects_total | PBC/Connections/Total | Connections |
| pbc_active | PBC/Connections/Active | Connections |
| memory_processes_used | Memory/Used/Processes | Bytes |
| consistent_gets_total | Consistent/Gets/Total | Operations |
| consistent_puts_total | Consistent/Puts/Total | Operations |
| node_get_fsm_rejected_total | Node/Get/Fsm/Rejected/Total | Rejections |
| node_gets_counter_total | Node/Gets/Counter/Total | Operations |
| node_gets_map_total | Node/Gets/Map/Total | Operations |
| node_gets_set_total | Node/Gets/Set/Total | Operations |
| node_put_fsm_rejected_total | Node/Put/Fsm/Rejected/Total | Rejections |
| node_puts_counter_total | Node/Puts/Counter/Total | Operations |
| node_puts_map_total | Node/Puts/Map/Total | Operations |
| node_puts_set_total | Node/Puts/Set/Total | Operations |
| search_index_fail_count | Search/Index/Fail/Total | Failures |
| search_index_fail_one | Search/Index/Fail/One | Failures |
| search_index_latency_95 | Search/Index/Latency/95 | Microseconds |
| search_index_latency_99 | Search/Index/Latency/99 | Microseconds |
| search_index_latency_999 | Search/Index/Latency/999 | Microseconds |
| search_index_latency_max | Search/Index/Latency/Max | Microseconds |
| search_index_latency_median | Search/Index/Latency/Median | Microseconds |
| search_index_latency_min | Search/Index/Latency/Min | Microseconds |
| search_index_throughput_count | Search/Index/Throughput/Total | Operations |
| search_index_throughtput_one | Search/Index/Throughtput/One | Operations |
| search_query_fail_count | Search/Query/Fail/Total | Failures |
| search_query_fail_one | Search/Query/Fail/One | Failures |
| search_query_latency_95 | Search/Query/Latency/95 | Microseconds |
| search_query_latency_99 | Search/Query/Latency/99 | Microseconds |
| search_query_latency_999 | Search/Query/Latency/999 | Microseconds |
| search_query_latency_max | Search/Query/Latency/Max | Microseconds |
| search_query_latency_median | Search/Query/Latency/Median | Microseconds |
| search_query_latency_min | Search/Query/Latency/Min | Microseconds |
| search_query_throughput_count | Search/Query/Throughput/Total | Operations |
| search_query_throughput_one | Search/Query/Throughput/One | Operations |
| vnode_counter_update_total | Vnode/Counter/Update/Total | Operations |
| vnode_map_update_total | Vnode/Map/Update/Total | Operations |
| vnode_set_update_total | Vnode/Set/Update/Total | Operations |
