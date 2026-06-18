-- Find the top 10 customers experiencing the highest 95th percentile latency.
-- Use Case 4: Identify latency impact on specific customers (Business Context)
-- If you don't propagate user or customer identifiers in your trace attributes
-- (e.g., for privacy or technical reasons), but you do log them in your
-- application access logs, you can join traces and logs to identify which
-- customers are experiencing the worst performance.

SELECT
  JSON_VALUE(l.json_payload.customer_id) AS customer_id,
  AVG(t.duration_nano / 1000000) AS avg_latency_ms,
  APPROX_QUANTILES(t.duration_nano / 1000000, 100)[OFFSET(95)] AS p95_latency_ms,
  COUNT(t.span_id) AS total_requests
FROM
  `YOUR_PROJECT_ID.us._Trace.Spans._AllSpans` AS t
JOIN
  `YOUR_PROJECT_ID.us._Default._AllLogs` AS l
ON
  t.trace_id = SPLIT(l.trace, '/')[SAFE_OFFSET(3)]
  AND t.span_id = l.spanId
WHERE
  t.start_time BETWEEN TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 DAY) AND CURRENT_TIMESTAMP()
  AND t.kind.name = 'SPAN_KIND_SERVER'
  AND JSON_VALUE(l.json_payload.customer_id) IS NOT NULL
GROUP BY
  customer_id
ORDER BY
  p95_latency_ms DESC
LIMIT 10
