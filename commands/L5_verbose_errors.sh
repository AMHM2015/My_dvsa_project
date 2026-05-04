#!/bin/bash

echo "=== Test 1: Missing required fields ==="
curl -s "$API" \
  -H "Content-Type: application/json" \
  -d '{}' | jq

echo
echo "=== Test 2: Null fields ==="
curl -s "$API" \
  -H "Content-Type: application/json" \
  -d '{"action":null,"cart-id":null}' | jq

echo
echo "=== Test 3: Garbage body ==="
curl -s "$API" \
  -H "Content-Type: text/plain" \
  -d 'this is not json' | jq

echo
echo "Look for stack traces, /var/task/ paths, or internal function names."
