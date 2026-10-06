# Agent skills

Personal agent skills maintained as ordinary Git source, packaged as a single plugin (`skills`) in the `fsw0422` marketplace. Claude Code and Codex both install it from `.claude-plugin/`.

## Install

Claude Code:

```sh
claude plugin marketplace add fsw0422/skills
claude plugin install skills@fsw0422 --scope user
```

Codex (installs are always per user):

```sh
codex plugin marketplace add fsw0422/skills
codex plugin add skills@fsw0422
```

If `codex` is not on your `PATH`, the ChatGPT desktop app bundles it at `/Applications/ChatGPT.app/Contents/Resources/codex`.

Skills are namespaced by the plugin, e.g. `skills:linkedin-job-pilot`.

The plugin also bundles a Playwright MCP server, `jobhunt-browser` (`.mcp.json`), for linkedin-job-pilot in Claude Code. It runs Playwright's Chromium, not your own Chrome, with a persistent sign-in profile at `~/jobhunt/.browser-profile` and browser output in `~/jobhunt/.playwright-mcp`, so installing the plugin on a new machine brings the same browser setup. Never commit the profile folder; it holds login cookies.

If you previously ran the old `install.sh`, remove its symlinks so the skill does not load twice:

```sh
rm ~/.agents/skills/linkedin-job-pilot
```

## Global instructions and settings

`AGENTS.md` holds the user-level instructions both tools load in every session. `claude-settings.json` holds the Claude Code user settings. Neither is used by the plugin. Link them once, from the main checkout:

```sh
~/projects/skills/link-instructions.sh
```

This symlinks `~/.codex/AGENTS.md` and `~/.claude/CLAUDE.md` to `AGENTS.md`, and `~/.claude/settings.json` to `claude-settings.json`, moving any existing file to `<name>.bak` first. `CODEX_HOME` and `CLAUDE_CONFIG_DIR` override the target directories. Edits apply to the next session in both tools once they reach the main checkout; there is nothing to reinstall.

The settings file is not named `settings.json` because Claude Code reads that name at a plugin root as the plugin's own settings. Claude Code writes user-scope changes straight into the linked file, so keep work-specific marketplaces and plugins in a project's `.claude/settings.json` instead, and check `git diff` before committing.

## Update

Every pushed commit is a new plugin version; there is no `version` field to bump.

Claude Code (restart afterwards):

```sh
claude plugin marketplace update fsw0422
claude plugin update skills@fsw0422
```

Or enable auto-update for the `fsw0422` marketplace in `/plugin`.

Codex:

```sh
codex plugin marketplace upgrade fsw0422
```

## Add a skill

Create `<name>/SKILL.md` at the repository root and add `"./<name>"` to the `skills` list in `.claude-plugin/plugin.json`. Both tools load only the listed directories. Optional Codex UI metadata goes in `<name>/agents/openai.yaml`.

## Develop

Load the working copy for one Claude Code session without publishing:

```sh
claude --plugin-dir ~/projects/skills
```

Validate the manifests before pushing:

```sh
claude plugin validate ~/projects/skills
```
