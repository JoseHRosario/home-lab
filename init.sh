#!/bin/bash
# init.sh: Fetches secrets directly in dotenv format and writes to shared file.

set -e

# --- 1. GET PROJECT ID FROM ARGUMENT ---
INFISICAL_PROJECT_ID_ARG=$1
if [ -z "$INFISICAL_PROJECT_ID_ARG" ]; then
    echo "ERROR: Missing Project ID argument. Usage: init.sh <project_id>"
    exit 1
fi
echo "Starting Infisical export for project: $INFISICAL_PROJECT_ID_ARG"

# --- 2. LOGIN & AUTHENTICATION ---
# (Relies on INFISICAL_CLIENT_ID and INFISICAL_CLIENT_SECRET from environment)
INFISICAL_TOKEN=$(/usr/local/bin/infisical login \
    --method=universal-auth \
    --client-id=233316d6-d273-405e-9190-9667c2445510 \
    --client-secret=7dfb42b261a118db00562d6564dfedac14f7493a64047c3ae0d40ba733e15f57 \
    --plain --silent)

if [ -z "$INFISICAL_TOKEN" ]; then
    echo "🚨 ERROR: Failed to retrieve Infisical token. Check credentials and network."
    exit 1
fi

# --- 3. DIRECT EXPORT (Ignoring Mapping) ---
ENV_FILE="/secrets/secrets.env" 

echo "Fetching secrets and writing to $ENV_FILE..."

# Fetch secrets in DOTENV format and write them directly to the file
# This assumes Infisical secrets are named BITCOIN_NODE_USER, BITCOIN_NODE_PASS, etc.
/usr/local/bin/infisical export \
    --token "$INFISICAL_TOKEN" \
    --project-id="$INFISICAL_PROJECT_ID_ARG" \
    --env="$INFISICAL_ENV" \
    --format=dotenv \
    > $ENV_FILE

# Check if the file was populated (simple check for success)
if [ ! -s "$ENV_FILE" ]; then
    echo "🚨 ERROR: Secrets file is empty. Check Infisical configuration."
    exit 1
fi

chmod 600 $ENV_FILE

echo "Secrets file created successfully. Initialization complete."