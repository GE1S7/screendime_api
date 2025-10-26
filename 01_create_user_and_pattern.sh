#!/bin/bash

# This script will exit immediately if any command fails.
set -e

# --- Configuration ---
BASE_URL="http://localhost:4000/api"
STAKE=5

# --- Colors for output ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}--- STEP 1: Creating a new user... ---${NC}"

# Send the request and capture the response
RESPONSE=$(curl -s -X POST "$BASE_URL/users" \
  -H "Content-Type: application/json" \
  -d "{\"user\": {\"stake\": $STAKE}}")

# Extract the user ID using jq. The -r flag gives raw output (no quotes).
USER_ID=$(echo "$RESPONSE" | jq -r '.data.id')

# Check if we actually got an ID.
if [ -z "$USER_ID" ] || [ "$USER_ID" == "null" ]; then
  echo -e "${RED}ERROR: Failed to create user or parse ID from response.${NC}"
  echo "Response was: $RESPONSE"
  exit 1
fi

echo -e "${GREEN}✅ User created successfully with ID: $USER_ID${NC}"
echo "---------------------------------"


echo -e "${YELLOW}--- STEP 2: Adding a pattern to the user's blocklist... ---${NC}"

curl -s -X POST "$BASE_URL/users/$USER_ID/blocked-patterns" \
  -H "Content-Type: application/json" \
  -d '{"blocked_pattern": {"url": "youtube.com/*"}}'

echo "" # Newline for readability
echo -e "${GREEN}✅ Added 'youtube.com/*' to user $USER_ID's blocklist.${NC}"
echo "---------------------------------"


# Save the USER_ID to a file for the next script
echo "$USER_ID" > .user_id
echo -e "User ID $USER_ID saved to .user_id file for the next script."
