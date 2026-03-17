# Claude Code Power Setup

Complete Claude Code configuration with 75+ skills, 21 plugins, and 6 MCP servers.

## Quick Install

```bash
git clone https://github.com/maheshzope01-hub/claude-code-setup.git
cd claude-code-setup
bash setup.sh
```

## What You Get

| Category | Count |
|---|---|
| Skills | 75+ |
| Plugins (enabled) | 21 |
| MCP Servers | 6 |
| UI/UX Design Databases | 48 CSV files |
| Framework Stacks | 13 |

## Included

### Superpowers (14 skills)
Dev workflow automation — brainstorming, TDD, debugging, code review, plans, verification, parallel agents, git worktrees.

### GSD — Get Stuff Done (38 skills)
Project management — milestones, phases, planning, execution, autonomous mode, UI review, validation, todos, notes.

### Plugins (21 enabled)
- **Dev workflow**: code-review, code-simplifier, commit-commands, feature-dev, pr-review-toolkit, security-guidance
- **Frontend**: frontend-design, playground
- **Integrations**: supabase, stripe, github, context7, playwright, slack
- **Meta**: claude-code-setup, claude-md-management, hookify, plugin-dev, skill-creator, typescript-lsp

### MCP Servers (6)
- **Supabase** — direct database access
- **GitHub** — PR/issue management
- **Vercel** — deployment management
- **Shopify Dev** — Shopify API docs & schemas
- **Context7** — up-to-date library documentation
- **Playwright** — browser testing & screenshots

### UI/UX Pro Max Skill
Searchable design intelligence with 48 CSV databases covering:
- 13 design domains (styles, colors, typography, charts, UX, icons, etc.)
- 13 framework stacks (React, Next.js, Vue, Svelte, Flutter, SwiftUI, etc.)

## Manual Install

If you prefer step-by-step:

### 1. GSD
```bash
npx get-shit-done-cc@latest
```

### 2. UI/UX Pro Max
```bash
mkdir -p ~/.claude/skills
git clone https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git ~/.claude/skills/ui-ux-pro-max-skill
```

### 3. Plugins
Copy `settings.json` contents into `~/.claude/settings.json` (merge `enabledPlugins` if you have existing settings).

### 4. MCP Servers
```bash
claude mcp add --transport http supabase "https://mcp.supabase.com/mcp"
claude mcp add --transport http github https://api.githubcopilot.com/mcp/
claude mcp add --transport http vercel https://mcp.vercel.com

# Windows:
claude mcp add --transport stdio shopify-dev-mcp -- cmd /c npx -y @shopify/dev-mcp@latest
# Mac/Linux:
claude mcp add --transport stdio shopify-dev-mcp -- npx -y @shopify/dev-mcp@latest
```

Then run `/mcp` inside Claude Code to authenticate.

## Requirements

- Claude Code CLI
- Node.js 18+
- Git
- Python 3.x (optional, for UI/UX Pro Max search)
