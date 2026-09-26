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

If you previously ran the old `install.sh`, remove its symlinks so the skill does not load twice:

```sh
rm ~/.agents/skills/linkedin-job-pilot
```

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
