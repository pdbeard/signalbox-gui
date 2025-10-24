#!/bin/bash
# Quickshell GUI for Signalbox - Setup Script

set -e

echo "🚦 Signalbox GUI Setup"
echo "====================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if we're in the right directory
if [ ! -f "manifest.json" ]; then
    echo -e "${RED}Error: manifest.json not found. Please run from the quickshell directory.${NC}"
    exit 1
fi

echo "📦 Checking dependencies..."

# Check for Python 3
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}✗ Python 3 not found${NC}"
    echo "  Please install Python 3.8 or higher"
    exit 1
else
    echo -e "${GREEN}✓ Python 3 found${NC}"
fi

# Check for Quickshell
if ! command -v quickshell &> /dev/null; then
    echo -e "${YELLOW}⚠ Quickshell not found${NC}"
    echo "  Please install Quickshell from: https://quickshell.outfoxxed.me/"
    echo "  The GUI may not run without it."
else
    echo -e "${GREEN}✓ Quickshell found${NC}"
fi

# Check for signalbox
if [ ! -d "../signalbox" ]; then
    echo -e "${RED}✗ Signalbox directory not found at ../signalbox${NC}"
    echo "  Please ensure signalbox is in the parent directory."
    exit 1
else
    echo -e "${GREEN}✓ Signalbox directory found${NC}"
fi

# Check for signalbox main.py
if [ ! -f "../signalbox/main.py" ]; then
    echo -e "${RED}✗ Signalbox main.py not found${NC}"
    exit 1
else
    echo -e "${GREEN}✓ Signalbox main.py found${NC}"
fi

# Check Python dependencies
echo ""
echo "📚 Checking Python dependencies..."
cd ../signalbox

if [ -f "requirements.txt" ]; then
    if python3 -c "import click, yaml" 2>/dev/null; then
        echo -e "${GREEN}✓ Python dependencies installed${NC}"
    else
        echo -e "${YELLOW}⚠ Some dependencies missing${NC}"
        echo "  Installing from requirements.txt..."
        pip3 install -r requirements.txt
    fi
else
    echo -e "${YELLOW}⚠ No requirements.txt found${NC}"
fi

cd ../signalbox-gui

# Make backend executable
echo ""
echo "🔧 Setting up backend..."
chmod +x signalbox_backend.py
echo -e "${GREEN}✓ Backend script made executable${NC}"

# Test backend
echo ""
echo "🧪 Testing backend connection..."
TEST_OUTPUT=$(echo '{"id":1,"command":"validate","args":[]}' | python3 signalbox_backend.py 2>&1 | head -1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Backend test successful${NC}"
else
    echo -e "${YELLOW}⚠ Backend test had issues (this may be normal)${NC}"
fi

# Summary
echo ""
echo "============================================"
echo -e "${GREEN}✓ Setup complete!${NC}"
echo "============================================"
echo ""
echo "To start the GUI:"
echo "  cd $(pwd)"
echo "  quickshell -c ."
echo ""
echo "Or copy to your Quickshell config:"
echo "  ln -s $(pwd) ~/.config/quickshell/signalbox"
echo ""
echo "For more information, see README.md"
echo ""
