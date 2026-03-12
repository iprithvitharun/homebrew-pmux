#!/bin/bash
# Build Prithvi Terminal as a macOS .app bundle
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/.build/release"
APP_DIR="$SCRIPT_DIR/build/Prithvi Terminal.app"
CONTENTS="$APP_DIR/Contents"
MACOS="$CONTENTS/MacOS"
RESOURCES="$CONTENTS/Resources"

echo ""
echo "  Building Prithvi Terminal..."
echo ""

# Build release binary
cd "$SCRIPT_DIR"
swift build -c release 2>&1

echo ""
echo "  Creating app bundle..."
echo ""

# Create .app structure
rm -rf "$APP_DIR"
mkdir -p "$MACOS"
mkdir -p "$RESOURCES"

# Copy binary
cp "$BUILD_DIR/PrithviTerminal" "$MACOS/PrithviTerminal"

# Copy Info.plist
cp "$SCRIPT_DIR/PrithviTerminal/Info.plist" "$CONTENTS/Info.plist"

# Create PkgInfo
echo -n "APPL????" > "$CONTENTS/PkgInfo"

# Create a simple icon (placeholder — replace with actual .icns)
# For now, just touch it so the bundle is valid
# To add a real icon: replace Resources/AppIcon.icns

echo ""
echo "  ✓ Built: $APP_DIR"
echo ""
echo "  To run:"
echo "    open \"$APP_DIR\""
echo ""
echo "  To install to /Applications:"
echo "    cp -R \"$APP_DIR\" /Applications/"
echo ""
