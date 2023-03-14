serviceAccount:
  create: true
  name:  ${loki_service_account_name}
  annotations:
    eks.amazonaws.com/role-arn: ${loki_iam_role_arn}

loki:
  config: |
    auth_enabled: false

    server:
      http_listen_port: 3100

    schema_config:
      configs:
        - from: 2021-01-01
          store: boltdb-shipper
          object_store: aws
          schema: v11
          index:
            prefix: loki_index_
            period: 24h

    storage_config:
      boltdb_shipper:
        shared_store: s3
        active_index_directory: /var/loki/index
        cache_location: /var/loki/cache
        cache_ttl: 24h
      aws:
        s3: s3://${aws_region}/${bucket_name}

    compactor:
      working_directory: /loki/compactor
      shared_store: s3

    distributor:
      ring:
        kvstore:
          store: memberlist

    ingester:
      chunk_idle_period: 1h
      max_chunk_age: 1h
      chunk_block_size: 262144
      chunk_target_size: 1536000
      chunk_encoding: snappy
      chunk_retain_period: 1m
      max_transfer_retries: 0
      lifecycler:
        join_after: 0s
        ring:
          kvstore:
            store: memberlist
          replication_factor: 1

    frontend_worker:
      frontend_address: {{ include "loki.queryFrontendFullname" . }}:9095

    frontend:
      log_queries_longer_than: 5s
      compress_responses: true
      tail_proxy_url: http://{{ include "loki.querierFullname" . }}:3100

    memberlist:
      join_members:
        - {{ include "loki.fullname" . }}-memberlist

    limits_config:
      ingestion_rate_mb: 10
      ingestion_burst_size_mb: 20
      enforce_metric_name: false
      reject_old_samples: true
      reject_old_samples_max_age: 168h
      max_cache_freshness_per_query: 10m
      max_concurrent_tail_requests: 20

    chunk_store_config:
      max_look_back_period: 0s

    query_range:
      align_queries_with_step: true
      max_retries: 5
      split_queries_by_interval: 15m
      cache_results: true
      results_cache:
        cache:
          enable_fifocache: true
          fifocache:
            max_size_items: 1024
            validity: 24h

compactor:
  enabled: true
  serviceAccount:
    create: true
    name: ${loki_compactor_service_account_name}
    annotations:
      eks.amazonaws.com/role-arn: ${loki_compactor_iam_role_arn}

ingester:
  replicas: 2

distributor:
  replicas: 2

querier:
  replicas: 2

queryFrontend:
  replicas: 2
