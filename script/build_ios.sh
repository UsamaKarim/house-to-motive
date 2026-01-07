#!/bin/bash

# iOS Build Script using .env file
# Usage: ./script/build_ios.sh [debug|release]
# Example: ./script/build_ios.sh release

set -e

# Get build mode from argument, default to release
BUILD_MODE=${1:-release}

# Validate build mode
if [[ "$BUILD_MODE" != "debug" && "$BUILD_MODE" != "release" ]]; then
    echo "Error: Build mode must be 'debug' or 'release'"
    echo "Usage: ./script/build_ios.sh [debug|release]"
    exit 1
fi

# Get the project root directory (parent of script directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Check if .env file exists
ENV_FILE="$PROJECT_ROOT/.env"
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: .env file not found at $ENV_FILE"
    echo "Please create a .env file with your environment variables."
    exit 1
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

# Change to project root
cd "$PROJECT_ROOT"

echo "Building iOS app in $BUILD_MODE mode..."
echo "Using environment variables from .env file"

# Build the iOS app
if [ "$BUILD_MODE" == "release" ]; then
    flutter build ios --release $DART_DEFINES
else
    flutter build ios --debug $DART_DEFINES
fi

echo "Build completed successfully!"

