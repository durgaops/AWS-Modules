# Logging & Observability Modules

Path: `terraform/modules/observability/`

| Module | Purpose |
|--------|---------|
| cloudwatch-log-group | Standard retention, KMS and naming |
| cloudwatch-metric-alarm | Standard alarms |
| cloudwatch-dashboard | Infrastructure and application dashboards |
| central-log-bucket | Secure, immutable centralized S3 logging |
| log-subscription | CloudWatch Logs subscription filters |
| log-forwarder | Forwarding to Splunk, Datadog or SIEM |
| opensearch-logging | Central OpenSearch logging platform |
| kinesis-log-streaming | Kinesis-based log pipeline |
| firehose-log-delivery | Delivery to S3, SIEM or analytics |
| eventbridge-observability | Operational event routing |
| sns-notification | Alert topics and subscriptions |
| xray | AWS X-Ray configurations |
| otel-collector | OpenTelemetry Collector deployment |
| managed-prometheus | Amazon Managed Prometheus |
| managed-grafana | Amazon Managed Grafana |
| synthetic-monitoring | CloudWatch Synthetics canaries |
| rum | Real User Monitoring |
| application-insights | Application Insights baseline |
| service-slo | SLI/SLO monitoring configuration |
| incident-routing | PagerDuty or ServiceNow integration |
| observability-baseline | Standard logs, metrics, traces and alarms |

## Recommended composition

```
observability-baseline
├── cloudwatch-log-group
├── cloudwatch-metric-alarm
├── cloudwatch-dashboard
├── sns-notification
├── log-forwarder
└── otel-collector
```

Use either:
- module: `modules/observability/observability-baseline`
- composition: `compositions/observability-baseline`
