#!/bin/bash

# Helper script to extract dart-define arguments from .env file
# Usage: source script/get_dart_defines.sh
# Output: Sets DART_DEFINES variable with all --dart-define flags

# Get the project root directory (parent of script directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Check if .env file exists
ENV_FILE="$PROJECT_ROOT/.env"
if [ ! -f "$ENV_FILE" ]; then
    echo "Warning: .env file not found at $ENV_FILE" >&2
    DART_DEFINES=""
    return 0
fi

# Build dart-define arguments from .env file
DART_DEFINES=""

# Read .env file and build --dart-define flags
while IFS='=' read -r key value || [ -n "$key" ]; do
    # Skip empty lines and comments
    [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]] && continue
    
    # Remove leading/trailing whitespace from key and value
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs)
    
    # Skip if key is empty after trimming
    [[ -z "$key" ]] && continue
    
    # Add to dart-define arguments
    if [ -z "$DART_DEFINES" ]; then
        DART_DEFINES="--dart-define=$key=$value"
    else
        DART_DEFINES="$DART_DEFINES --dart-define=$key=$value"
    fi
done < "$ENV_FILE"

# Export the variable so it can be used by parent scripts
export DART_DEFINES

