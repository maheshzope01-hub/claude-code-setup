# All Skills Reference

## Superpowers (14 active + 3 deprecated)

| Skill | Triggers When |
|---|---|
| `superpowers:using-superpowers` | Every session start |
| `superpowers:brainstorming` | Before any creative/feature work |
| `superpowers:writing-plans` | Before multi-step implementation |
| `superpowers:executing-plans` | Executing written plans |
| `superpowers:subagent-driven-development` | Parallel task execution |
| `superpowers:dispatching-parallel-agents` | 2+ independent tasks |
| `superpowers:test-driven-development` | Before writing implementation code |
| `superpowers:systematic-debugging` | On bugs/test failures |
| `superpowers:verification-before-completion` | Before claiming work is done |
| `superpowers:requesting-code-review` | After completing features |
| `superpowers:receiving-code-review` | Processing incoming reviews |
| `superpowers:finishing-a-development-branch` | Branch completion |
| `superpowers:using-git-worktrees` | Feature isolation |
| `superpowers:writing-skills` | Creating/editing skills |

## GSD (38 commands)

| Command | Purpose |
|---|---|
| `gsd:new-project` | Initialize project |
| `gsd:new-milestone` | Start milestone cycle |
| `gsd:discuss-phase` | Gather phase context |
| `gsd:plan-phase` | Create phase plan |
| `gsd:execute-phase` | Execute plans |
| `gsd:autonomous` | Run all phases autonomously |
| `gsd:progress` | Check progress |
| `gsd:quick` | Quick task with guarantees |
| `gsd:debug` | Systematic debugging |
| `gsd:verify-work` | Conversational UAT |
| `gsd:validate-phase` | Audit validation gaps |
| `gsd:map-codebase` | Analyze codebase |
| `gsd:research-phase` | Research implementation |
| `gsd:ui-phase` | UI design contract |
| `gsd:ui-review` | 6-pillar visual audit |
| `gsd:add-phase` | Add phase to roadmap |
| `gsd:insert-phase` | Insert urgent work |
| `gsd:remove-phase` | Remove future phase |
| `gsd:add-tests` | Generate tests |
| `gsd:add-todo` | Capture idea/task |
| `gsd:check-todos` | List pending todos |
| `gsd:note` | Zero-friction notes |
| `gsd:stats` | Project statistics |
| `gsd:health` | Diagnose planning health |
| `gsd:pause-work` | Context handoff |
| `gsd:resume-work` | Resume from previous session |
| `gsd:complete-milestone` | Archive milestone |
| `gsd:audit-milestone` | Audit against intent |
| `gsd:plan-milestone-gaps` | Close audit gaps |
| `gsd:cleanup` | Archive phase dirs |
| `gsd:settings` | Configure toggles |
| `gsd:set-profile` | Switch model profile |
| `gsd:list-phase-assumptions` | Surface assumptions |
| `gsd:do` | Route freeform text |
| `gsd:help` | Show commands |
| `gsd:update` | Update GSD |
| `gsd:reapply-patches` | Reapply local mods |
| `gsd:join-discord` | Join community |

## Plugin Skills

| Plugin | Skill | Purpose |
|---|---|---|
| claude-code-setup | claude-automation-recommender | Recommend hooks/MCP/plugins |
| claude-md-management | claude-md-improver | Improve CLAUDE.md files |
| frontend-design | frontend-design | UI design guidance |
| hookify | writing-rules | Hook/rule writing |
| playground | playground | Interactive exploration |
| skill-creator | skill-creator | Build new skills |
| plugin-dev | agent-development | Create custom agents |
| plugin-dev | command-development | Build slash commands |
| plugin-dev | hook-development | Create hooks |
| plugin-dev | mcp-integration | MCP server integration |
| plugin-dev | plugin-settings | Plugin settings management |
| plugin-dev | plugin-structure | Plugin architecture |
| plugin-dev | skill-development | Skill creation reference |
| stripe | stripe-best-practices | Stripe integration |

## Utility Skills

| Skill | Purpose |
|---|---|
| `update-config` | Configure settings.json |
| `keybindings-help` | Customize keyboard shortcuts |
| `simplify` | Code quality review |
| `loop` | Recurring task execution |
| `claude-api` | Claude API/SDK development |

## UI/UX Pro Max

Searchable design intelligence databases:
- **13 design domains**: products, styles, colors, typography, landing pages, charts, UX, icons, etc.
- **13 framework stacks**: React, Next.js, Vue, Nuxt, Svelte, Astro, Flutter, SwiftUI, React Native, shadcn, Jetpack Compose, etc.
- **Search**: `python3 search.py "<query>" --domain <domain> --stack <stack>`
