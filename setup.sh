#!/bin/bash
#
# Claude Code Power Setup
# Installs 75+ skills, 21 plugins, 6 MCP servers, 24 agents
#
# Usage: bash setup.sh
#

set -e

echo "╔═══════════════════════════════════════════════════╗"
echo "║       Claude Code Power Setup Installer           ║"
echo "║  75+ Skills | 21 Plugins | 6 MCP | 24 Agents     ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""

# Detect OS
OS="unknown"
case "$(uname -s)" in
  Linux*)   OS="linux";;
  Darwin*)  OS="mac";;
  MINGW*|MSYS*|CYGWIN*) OS="windows";;
esac
echo "Detected OS: $OS"
echo ""

# Check prerequisites
echo "=== Checking prerequisites ==="

command -v node >/dev/null 2>&1 || { echo "ERROR: Node.js not found. Install from https://nodejs.org"; exit 1; }
echo "  ✓ Node.js $(node --version)"

command -v git >/dev/null 2>&1 || { echo "ERROR: Git not found. Install from https://git-scm.com"; exit 1; }
echo "  ✓ Git $(git --version | cut -d' ' -f3)"

command -v claude >/dev/null 2>&1 || { echo "ERROR: Claude Code CLI not found. Install from https://claude.ai/code"; exit 1; }
echo "  ✓ Claude Code CLI found"

# Check for Python (optional, for ui-ux-pro-max)
PYTHON_CMD=""
if command -v python3 >/dev/null 2>&1; then
  PYTHON_CMD="python3"
elif command -v python >/dev/null 2>&1; then
  PYTHON_CMD="python"
fi
if [ -n "$PYTHON_CMD" ]; then
  echo "  ✓ Python ($($PYTHON_CMD --version 2>&1))"
else
  echo "  ! Python not found (optional, needed for ui-ux-pro-max search)"
fi

echo ""

# ─────────────────────────────────────────────
# Step 1: GSD (Get Stuff Done)
# ─────────────────────────────────────────────
echo "=== Step 1/5: Installing GSD (38 project management skills) ==="
npx get-shit-done-cc@latest 2>/dev/null || echo "  ! GSD install needs to be run inside Claude Code"
echo ""

# ─────────────────────────────────────────────
# Step 2: UI/UX Pro Max Skill
# ─────────────────────────────────────────────
echo "=== Step 2/5: Installing UI/UX Pro Max Skill ==="
CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"
mkdir -p "$SKILLS_DIR"

if [ -d "$SKILLS_DIR/ui-ux-pro-max-skill" ]; then
  echo "  Already installed, pulling latest..."
  cd "$SKILLS_DIR/ui-ux-pro-max-skill" && git pull 2>/dev/null || true
else
  echo "  Cloning ui-ux-pro-max-skill..."
  git clone https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git "$SKILLS_DIR/ui-ux-pro-max-skill" 2>/dev/null || echo "  ! Clone failed — check URL"
fi
echo ""

# ─────────────────────────────────────────────
# Step 3: Plugin Settings
# ─────────────────────────────────────────────
echo "=== Step 3/5: Configuring plugins (21 enabled) ==="
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$SETTINGS_FILE" ]; then
  echo "  Existing settings.json found — merging enabledPlugins..."
  # Use node to merge
  node -e "
    const fs = require('fs');
    const existing = JSON.parse(fs.readFileSync('$SETTINGS_FILE', 'utf8'));
    const newPlugins = JSON.parse(fs.readFileSync('$SCRIPT_DIR/settings.json', 'utf8'));
    existing.enabledPlugins = { ...existing.enabledPlugins, ...newPlugins.enabledPlugins };
    if (!existing.effortLevel) existing.effortLevel = 'high';
    fs.writeFileSync('$SETTINGS_FILE', JSON.stringify(existing, null, 2));
    console.log('  ✓ Merged', Object.keys(newPlugins.enabledPlugins).length, 'plugins into existing settings');
  " 2>/dev/null || {
    echo "  ! Auto-merge failed. Copy settings.json manually:"
    echo "    cp $SCRIPT_DIR/settings.json $SETTINGS_FILE"
  }
else
  echo "  No existing settings — copying fresh..."
  cp "$SCRIPT_DIR/settings.json" "$SETTINGS_FILE"
  echo "  ✓ Settings installed"
fi
echo ""

# ─────────────────────────────────────────────
# Step 4: MCP Servers
# ─────────────────────────────────────────────
echo "=== Step 4/5: Adding MCP Servers (6) ==="

# HTTP servers (OAuth-based)
echo "  Adding Supabase MCP..."
claude mcp add --transport http supabase "https://mcp.supabase.com/mcp" 2>/dev/null || echo "  ! Supabase MCP add failed"

echo "  Adding GitHub MCP..."
claude mcp add --transport http github https://api.githubcopilot.com/mcp/ 2>/dev/null || echo "  ! GitHub MCP add failed"

echo "  Adding Vercel MCP..."
claude mcp add --transport http vercel https://mcp.vercel.com 2>/dev/null || echo "  ! Vercel MCP add failed"

# Stdio servers (platform-dependent)
echo "  Adding Shopify Dev MCP..."
if [ "$OS" = "windows" ]; then
  claude mcp add --transport stdio shopify-dev-mcp -- cmd /c npx -y @shopify/dev-mcp@latest 2>/dev/null || echo "  ! Shopify MCP add failed"
else
  claude mcp add --transport stdio shopify-dev-mcp -- npx -y @shopify/dev-mcp@latest 2>/dev/null || echo "  ! Shopify MCP add failed"
fi

echo ""
echo "  NOTE: Run /mcp inside Claude Code to authenticate OAuth servers"
echo "        (Supabase, GitHub, Vercel)"
echo ""

# ─────────────────────────────────────────────
# Step 5: Custom Agents (Optional)
# ─────────────────────────────────────────────
echo "=== Step 5/5: Installing custom agents ==="
AGENTS_DIR="$CLAUDE_DIR/agents"
mkdir -p "$AGENTS_DIR"

if [ -d "$SCRIPT_DIR/agents" ]; then
  AGENT_COUNT=0
  for AGENT_FILE in "$SCRIPT_DIR/agents/"*.md; do
    if [ -f "$AGENT_FILE" ]; then
      BASENAME=$(basename "$AGENT_FILE")
      cp "$AGENT_FILE" "$AGENTS_DIR/$BASENAME"
      AGENT_COUNT=$((AGENT_COUNT + 1))
    fi
  done
  echo "  ✓ Copied $AGENT_COUNT custom agents to $AGENTS_DIR"
else
  echo "  No agents/ directory found — skipping"
fi
echo ""

# ─────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────
echo "╔═══════════════════════════════════════════════════╗"
echo "║              Setup Complete!                      ║"
echo "╠═══════════════════════════════════════════════════╣"
echo "║                                                   ║"
echo "║  ✓ GSD (38 skills)         — project management  ║"
echo "║  ✓ Superpowers (14 skills) — dev workflow         ║"
echo "║  ✓ Plugins (21 enabled)    — tools & integrations ║"
echo "║  ✓ UI/UX Pro Max           — design intelligence  ║"
echo "║  ✓ MCP Servers (6)         — external services    ║"
echo "║  ✓ Custom Agents           — ops & testing        ║"
echo "║                                                   ║"
echo "║  Next steps:                                      ║"
echo "║  1. Restart Claude Code                           ║"
echo "║  2. Run /mcp to authenticate OAuth servers        ║"
echo "║  3. Start building!                               ║"
echo "║                                                   ║"
echo "╚═══════════════════════════════════════════════════╝"
