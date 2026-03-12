#!/usr/bin/env bash
# Prithvi CLI Uninstaller
set -e

SHELL_RC="$HOME/.zshrc"

echo ""
echo "  Prithvi CLI — Uninstaller"
echo ""

if grep -q "prithvi-cli/prithvi.zsh" "$SHELL_RC" 2>/dev/null; then
  # Remove the source line and comment
  sed -i '' '/# Prithvi CLI/d' "$SHELL_RC"
  sed -i '' '/prithvi-cli\/prithvi.zsh/d' "$SHELL_RC"
  echo "  ✓ Removed from $SHELL_RC"
  echo "  → Restart your terminal to complete uninstall"
else
  echo "  ! Prithvi CLI not found in $SHELL_RC"
fi

echo ""
