#!/bin/bash

# Wrapper script to run Flutter with environment variables from .env
# Usage: script/flutter_run_with_env.sh [flutter args...]

# Source the helper script to get DART_DEFINES
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/get_dart_defines.sh"

# Get the project root directory
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Change to project root
cd "$PROJECT_ROOT"

# Run flutter with dart-define arguments and any additional args
if [ -z "$DART_DEFINES" ]; then
    flutter "$@"
else
    # Split DART_DEFINES into array and pass as separate arguments
    flutter "$@" $DART_DEFINES
fi

