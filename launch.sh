#!/bin/bash
# Launch Signalbox GUI

cd "$(dirname "$0")"

echo "🚦 Starting Signalbox GUI..."
echo ""

# Check if quickshell is installed
if ! command -v quickshell &> /dev/null; then
    echo "Error: Quickshell not found!"
    echo "Please install Quickshell: https://quickshell.outfoxxed.me/"
    exit 1
fi

# Check if backend is executable
if [ ! -x "signalbox_backend.py" ]; then
    echo "Making backend executable..."
    chmod +x signalbox_backend.py
fi

# Launch
exec quickshell -c .
