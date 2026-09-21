# Codex skills

Personal Codex skills maintained as ordinary Git source.

## Install

Clone the repository and run the installer:

```sh
gh repo clone fsw0422/skills ~/projects/skills
~/projects/skills/install.sh
```

The installer creates symlinks from `~/.agents/skills/<name>` to each skill under this repository's `skills/` directory. It refuses to overwrite existing installations or unrelated symlinks.

## Update

```sh
git -C ~/projects/skills pull --ff-only
```

Because installed skills are symlinks, pulled changes become active without reinstalling. Codex normally detects changes automatically; restart Codex if an update does not appear.

Edit either through the repository path or its installed symlink, then commit and push normally.
