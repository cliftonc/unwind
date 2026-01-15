#!/bin/bash
# Cross-platform hook runner for Unwind skills
# Usage: run-hook.cmd <script-name>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$1"

if [ -z "$SCRIPT_NAME" ]; then
    echo "Usage: run-hook.cmd <script-name>"
    exit 1
fi

SCRIPT_PATH="$SCRIPT_DIR/$SCRIPT_NAME"

if [ -f "$SCRIPT_PATH" ]; then
    bash "$SCRIPT_PATH"
else
    echo "Hook script not found: $SCRIPT_PATH"
    exit 1
fi
