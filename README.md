# Claude Code Power Setup

Complete Claude Code configuration with 75+ skills, 21 plugins, 6 MCP servers, and 24 custom agents.

## Quick Install (1 command)

```bash
bash setup.sh
```

Or follow the manual steps below.

## What You Get

| Category | Count |
|---|---|
| Plugins (enabled) | 21 |
| Skills | 75+ |
| MCP Servers | 6 |
| Agents | 24 (15 GSD + 3 plugin + 6 custom) |
| UI/UX Design Data | 48 CSV databases |
| Hooks | 3 |

## Manual Install

### Step 1: Install Superpowers + GSD

```bash
# Superpowers (20+ dev workflow skills)
# Installs via Claude Code plugin marketplace — run inside Claude Code:
# /install superpowers

# GSD (Get Stuff Done — 38 project management skills)
npx get-shit-done-cc@latest
```

### Step 2: Install UI/UX Pro Max Skill

```bash
mkdir -p ~/.claude/skills
cd ~/.claude/skills
git clone https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git
```

### Step 3: Enable Plugins

Copy `settings.json` to `~/.claude/settings.json` (merge with existing if you have one).

### Step 4: Add MCP Servers

```bash
# HTTP servers (OAuth — will prompt browser login)
claude mcp add --transport http supabase "https://mcp.supabase.com/mcp"
claude mcp add --transport http github https://api.githubcopilot.com/mcp/
claude mcp add --transport http vercel https://mcp.vercel.com

# Stdio servers
claude mcp add --transport stdio shopify-dev-mcp -- cmd /c npx -y @shopify/dev-mcp@latest
# Note: Context7 and Playwright come from plugins, no manual add needed
```

Then run `/mcp` inside Claude Code to authenticate.

### Step 5: Custom Agents (Optional)

Copy the `agents/` folder to `~/.claude/agents/`.

## Files Included

```
claude-code-setup/
├── README.md              # This file
├── setup.sh               # One-command installer
├── settings.json          # Plugin configuration (21 enabled)
├── agents/                # Custom agents
│   ├── onescale-ops.md
│   ├── onescale-auditor.md
│   ├── onescale-sync-monitor.md
│   ├── onescale-health.md
│   ├── onescale-alerts.md
│   └── onescale-tester.md
└── skills-list.md         # Full skill reference
```

## Plugin List (21 Enabled)

### Dev Workflow
- superpowers (brainstorming, TDD, debugging, code review, plans, verification)
- code-review, code-simplifier, commit-commands, feature-dev, pr-review-toolkit
- security-guidance, typescript-lsp

### Frontend & Design
- frontend-design, playground (code maps, design, diff review)
- ui-ux-pro-max-skill (48 CSV databases, 13 framework stacks)

### Integrations
- supabase, stripe, github, context7, playwright, slack

### Meta / Building
- claude-code-setup, claude-md-management, hookify, plugin-dev, skill-creator

## Requirements

- Claude Code CLI installed
- Node.js 18+
- Python 3.x (for ui-ux-pro-max search)
- Git
