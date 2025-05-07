#!/bin/bash

ENV_FILE=".env"

# Generate secure 50-character secret key
SECRET_KEY=$(python -c "
import secrets, string
chars = string.ascii_letters + string.digits + string.punctuation
chars = chars.replace('\"','').replace(\"'\",'').replace('\\\\','')
print(''.join(secrets.choice(chars) for _ in range(50)))
")

# Quote the key
QUOTED_SECRET_KEY="\"${SECRET_KEY}\""

# Create .env if it doesn't exist
if [ ! -f "$ENV_FILE" ]; then
    echo "⚠️ .env not found, creating it..."
    touch "$ENV_FILE"
fi

# Replace or add SECRET_KEY in .env
if grep -q "^SECRET_KEY=" "$ENV_FILE"; then
    sed -i.bak "s|^SECRET_KEY=.*|SECRET_KEY=${QUOTED_SECRET_KEY}|" "$ENV_FILE"
    echo "✅ Updated SECRET_KEY in ${ENV_FILE}"
else
    echo "SECRET_KEY=${QUOTED_SECRET_KEY}" >> "$ENV_FILE"
    echo "✅ Added SECRET_KEY to ${ENV_FILE}"
fi