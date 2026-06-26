#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  Parakletos — Xcode project generator
#  Run this ONCE on your Mac after cloning the repo.
#  Requires: macOS + Homebrew (brew.sh)
# ─────────────────────────────────────────────────────────────
set -e

echo "🛠  Checking for XcodeGen..."
if ! command -v xcodegen &>/dev/null; then
  echo "Installing XcodeGen via Homebrew..."
  brew install xcodegen
fi

echo "⚙️  Generating Parakletos.xcodeproj..."
xcodegen generate

echo ""
echo "✅  Done!  Open Parakletos.xcodeproj in Xcode."
echo ""
echo "First-time steps in Xcode:"
echo "  1. Select the 'Parakletos' target → Signing & Capabilities"
echo "  2. Choose your personal Apple ID team from the Team dropdown"
echo "  3. Plug in your iPhone and hit ▶  Run"
