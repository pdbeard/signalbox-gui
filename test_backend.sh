#!/bin/bash
# Test script for Signalbox GUI backend

echo "Testing Signalbox GUI Backend"
echo "=============================="
echo ""

# Change to script directory
cd "$(dirname "$0")"

# Test 1: List scripts
echo "Test 1: Listing scripts..."
echo '{"id":1,"command":"list","args":[]}' | python3 signalbox_backend.py
echo ""

# Test 2: List groups
echo "Test 2: Listing groups..."
echo '{"id":2,"command":"list-groups","args":[]}' | python3 signalbox_backend.py
echo ""

# Test 3: Show config
echo "Test 3: Showing config..."
echo '{"id":3,"command":"show-config","args":[]}' | python3 signalbox_backend.py
echo ""

# Test 4: Validate
echo "Test 4: Validating configuration..."
echo '{"id":4,"command":"validate","args":[]}' | python3 signalbox_backend.py
echo ""

echo "=============================="
echo "All tests complete!"
echo ""
echo "If you see JSON responses above, the backend is working correctly."
echo "Now try running: quickshell -c ."
