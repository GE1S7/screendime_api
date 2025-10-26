#!/bin/bash
set -e

# --- Configuration ---
BASE_URL="http://localhost:4000/api"

# --- Colors ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}--- STEP 4: Testing a visit to an ALLOWED site... ---${NC}"

# Read the user ID saved by the first script
USER_ID=$(cat .user_id)

echo "Using User ID: $USER_ID"

# Send the request to log a visit to a site that should be allowed
RESPONSE=$(curl -s -X POST "$BASE_URL/users/$USER_ID/visits" \
  -H "Content-Type: application/json" \
  -d '{
    "visit": {
      "url": "https://elixir-lang.org/",
      "timezone": "America/New_York"
    }
  }')

# Check the response status with jq
STATUS=$(echo "$RESPONSE" | jq -r '.status')

if [ "$STATUS" == "allowed" ]; then
  echo -e "${GREEN}✅ SUCCESS: Visit was correctly allowed!${NC}"
  echo "Response: $RESPONSE"
else
  echo -e "${RED}❌ FAILURE: Expected 'allowed' status, but got '$STATUS'.${NC}"
  echo "Response: $RESPONSE"
  exit 1
fi

# Clean up the temporary file
rm .user_id
