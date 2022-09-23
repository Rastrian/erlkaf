-module(erlkaf_error_converter).

-export([
    get_readable_error/1
]).

-define(ERROR_MAPPING, [
    % librdkafka internal errors
    {-200, rd_kafka_resp_err_begin},
    {-199, rd_kafka_resp_err_bad_msg},
    {-198, rd_kafka_resp_err_bad_compression},
    {-197, rd_kafka_resp_err_destroy},
    {-196, rd_kafka_resp_err_fail},
    {-195, rd_kafka_resp_err_transport},
    {-194, rd_kafka_resp_err_crit_sys_resource},
    {-193, rd_kafka_resp_err_resolve},
    {-192, rd_kafka_resp_err_msg_timed_out},
    {-191, rd_kafka_resp_err_partition_eof},
    {-190, rd_kafka_resp_err_unknown_partition},
    {-189, rd_kafka_resp_err_fs},
    {-188, rd_kafka_resp_err_unknown_topic},
    {-187, rd_kafka_resp_err_all_brokers_down},
    {-186, rd_kafka_resp_err_invalid_arg},
    {-185, rd_kafka_resp_err_timed_out},
    {-184, rd_kafka_resp_err_queue_full},
    {-183, rd_kafka_resp_err_isr_insuff},
    {-182, rd_kafka_resp_err_node_update},
    {-181, rd_kafka_resp_err_ssl},
    {-180, rd_kafka_resp_err_wait_coord},
    {-179, rd_kafka_resp_err_unknown_group},
    {-178, rd_kafka_resp_err_in_progress},
    {-177, rd_kafka_resp_err_prev_in_progress},
    {-176, rd_kafka_resp_err_existing_subscription},
    {-175, rd_kafka_resp_err_assign_partitions},
    {-174, rd_kafka_resp_err_revoke_partitions},
    {-173, rd_kafka_resp_err_conflict},
    {-172, rd_kafka_resp_err_state},
    {-171, rd_kafka_resp_err_unknown_protocol},
    {-170, rd_kafka_resp_err_not_implemented},
    {-169, rd_kafka_resp_err_authentication},
    {-168, rd_kafka_resp_err_no_offset},
    {-167, rd_kafka_resp_err_outdated},
    {-166, rd_kafka_resp_err_timed_out_queue},
    {-165, rd_kafka_resp_err_unsupported_feature},
    {-164, rd_kafka_resp_err_wait_cache},
    {-163, rd_kafka_resp_err_intr},
    {-162, rd_kafka_resp_err_key_serialization},
    {-161, rd_kafka_resp_err_value_serialization},
    {-160, rd_kafka_resp_err_key_deserialization},
    {-159, rd_kafka_resp_err_value_deserialization},
    {-158, rd_kafka_resp_err_partial},
    {-157, rd_kafka_resp_err_read_only},
    {-156, rd_kafka_resp_err_noent},
    {-155, rd_kafka_resp_err_underflow},
    {-154, rd_kafka_resp_err_invalid_type},
    {-100, rd_kafka_resp_err_end},
    {-1, rd_kafka_resp_err_unknown},
 
    % broker errors
    {0, rd_kafka_resp_err_no_error},
    {1, rd_kafka_resp_err_offset_out_of_range},
    {2, rd_kafka_resp_err_invalid_msg},
    {3, rd_kafka_resp_err_unknown_topic_or_part},
    {4, rd_kafka_resp_err_invalid_msg_size},
    {5, rd_kafka_resp_err_leader_not_available},
    {6, rd_kafka_resp_err_not_leader_for_partition},
    {7, rd_kafka_resp_err_request_timed_out},
    {8, rd_kafka_resp_err_broker_not_available},
    {9, rd_kafka_resp_err_replica_not_available},
    {10, rd_kafka_resp_err_msg_size_too_large},
    {11, rd_kafka_resp_err_stale_ctrl_epoch},
    {12, rd_kafka_resp_err_offset_metadata_too_large},
    {13, rd_kafka_resp_err_network_exception},
    {14, rd_kafka_resp_err_group_load_in_progress},
    {15, rd_kafka_resp_err_group_coordinator_not_available},
    {16, rd_kafka_resp_err_not_coordinator_for_group},
    {17, rd_kafka_resp_err_topic_exception},
    {18, rd_kafka_resp_err_record_list_too_large},
    {19, rd_kafka_resp_err_not_enough_replicas},
    {20, rd_kafka_resp_err_not_enough_replicas_after_append},
    {21, rd_kafka_resp_err_invalid_required_acks},
    {22, rd_kafka_resp_err_illegal_generation},
    {23, rd_kafka_resp_err_inconsistent_group_protocol},
    {24, rd_kafka_resp_err_invalid_group_id},
    {25, rd_kafka_resp_err_unknown_member_id},
    {26, rd_kafka_resp_err_invalid_session_timeout},
    {27, rd_kafka_resp_err_rebalance_in_progress},
    {28, rd_kafka_resp_err_invalid_commit_offset_size},
    {29, rd_kafka_resp_err_topic_authorization_failed},
    {30, rd_kafka_resp_err_group_authorization_failed},
    {31, rd_kafka_resp_err_cluster_authorization_failed},
    {32, rd_kafka_resp_err_invalid_timestamp},
    {33, rd_kafka_resp_err_unsupported_sasl_mechanism},
    {34, rd_kafka_resp_err_illegal_sasl_state},
    {35, rd_kafka_resp_err_unsupported_version},
    {36, rd_kafka_resp_err_topic_already_exists},
    {37, rd_kafka_resp_err_invalid_partitions},
    {38, rd_kafka_resp_err_invalid_replication_factor},
    {39, rd_kafka_resp_err_invalid_replica_assignment},
    {40, rd_kafka_resp_err_invalid_config},
    {41, rd_kafka_resp_err_not_controller},
    {42, rd_kafka_resp_err_invalid_request},
    {43, rd_kafka_resp_err_unsupported_for_message_format},
    {44, rd_kafka_resp_err_policy_violation},
    {45, rd_kafka_resp_err_out_of_order_sequence_number},
    {46, rd_kafka_resp_err_duplicate_sequence_number},
    {47, rd_kafka_resp_err_invalid_producer_epoch},
    {48, rd_kafka_resp_err_invalid_txn_state},
    {49, rd_kafka_resp_err_invalid_producer_id_mapping},
    {50, rd_kafka_resp_err_invalid_transaction_timeout},
    {51, rd_kafka_resp_err_concurrent_transactions},
    {52, rd_kafka_resp_err_transaction_coordinator_fenced},
    {53, rd_kafka_resp_err_transactional_id_authorization_failed},
    {54, rd_kafka_resp_err_security_disabled},
    {55, rd_kafka_resp_err_operation_not_attempted}
    ]
).

get_readable_error(Error) ->
    erlkaf_utils:lookup(Error, ?ERROR_MAPPING, undefined).