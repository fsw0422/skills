#!/bin/sh

set -eu

repo_root="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)"
instructions="${repo_root}/AGENTS.md"
# Not settings.json: Claude Code reads that name at a plugin root as the plugin's own settings.
settings="${repo_root}/claude-settings.json"
claude_dir="${CLAUDE_CONFIG_DIR:-${HOME}/.claude}"
codex_target="${CODEX_HOME:-${HOME}/.codex}/AGENTS.md"
claude_target="${claude_dir}/CLAUDE.md"
settings_target="${claude_dir}/settings.json"

for source in "${instructions}" "${settings}"; do
	test -f "${source}" || {
		printf 'Missing source file: %s\n' "${source}" >&2
		exit 1
	}
done

# A linked worktree is deleted on cleanup, which would leave dangling links.
[ ! -f "${repo_root}/.git" ] || {
	printf 'Run this from the main checkout, not a worktree: %s\n' "${repo_root}" >&2
	exit 1
}

check() {
	source="$1"
	target="$2"
	if [ -L "${target}" ]; then
		current="$(readlink "${target}")"
		[ "${current}" = "${source}" ] || {
			printf 'Refusing to replace unrelated symlink: %s -> %s\n' "${target}" "${current}" >&2
			exit 1
		}
	elif [ -e "${target}" ]; then
		[ ! -e "${target}.bak" ] && [ ! -L "${target}.bak" ] || {
			printf 'Refusing to overwrite existing backup: %s.bak\n' "${target}" >&2
			exit 1
		}
	fi
}

link() {
	source="$1"
	target="$2"
	if [ -L "${target}" ]; then
		printf 'Already linked: %s -> %s\n' "${target}" "${source}"
		return
	fi
	mkdir -p "$(dirname -- "${target}")"
	if [ -e "${target}" ]; then
		mv "${target}" "${target}.bak"
		printf 'Backed up: %s -> %s.bak\n' "${target}" "${target}"
	fi
	ln -s "${source}" "${target}"
	printf 'Linked: %s -> %s\n' "${target}" "${source}"
}

check "${instructions}" "${codex_target}"
check "${instructions}" "${claude_target}"
check "${settings}" "${settings_target}"
link "${instructions}" "${codex_target}"
link "${instructions}" "${claude_target}"
link "${settings}" "${settings_target}"
