# Agent skills

Personal agent skills maintained as ordinary Git source, packaged as the `skills` plugin in the `fsw0422` marketplace. Claude Code and Codex both install it from `.claude-plugin/`. The marketplace also has a separate `playwright-chromium-browser` plugin for CLI browsing; see below.

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

### Browsers

browser-pilot governs every browser task, and the global instructions tell both tools to load it before any browser tool. The Claude Code Desktop and Codex apps use only their built-in browser. Sessions without one, such as a CLI, use the separate `playwright-chromium-browser` plugin. Your own Chrome is never used: the Claude Code user settings deny Claude in Chrome (`mcp__claude-in-chrome`), and the Codex config turns off the bundled Chrome plugin with `enabled = false` under `[plugins."chrome@openai-bundled"]`.

The plugin runs Playwright's Chromium (Chrome for Testing), isolated from your own Chrome, with a persistent sign-in profile at `~/.playwright-chromium-browser/profile` and browser output in `~/.playwright-chromium-browser/output`. Never commit either folder; they hold login cookies and page contents.

```sh
claude plugin install playwright-chromium-browser@fsw0422 --scope user
npx -y @playwright/mcp@latest install-browser chrome-for-testing
```

The second command downloads the browser once per machine (about 100 MB); repeat it if Playwright later reports the browser missing after an update.

If you previously ran the old `install.sh`, remove its symlinks so the skill does not load twice:

```sh
rm ~/.agents/skills/linkedin-job-pilot
```

## Global instructions and settings

The user-level instructions (`AGENTS.md`), Claude Code settings, and Codex config live in the [.ksp](https://github.com/fsw0422/.ksp) dotfiles repo, not here, and [ksp-setup](https://github.com/fsw0422/ksp-setup) links them into `~/.claude` and `~/.codex`.

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
