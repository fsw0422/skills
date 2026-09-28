#!/bin/sh

set -eu

repo_root="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)"
source="${repo_root}/AGENTS.md"
codex_target="${CODEX_HOME:-${HOME}/.codex}/AGENTS.md"
claude_target="${CLAUDE_CONFIG_DIR:-${HOME}/.claude}/CLAUDE.md"

test -f "${source}" || {
	printf 'Missing instructions file: %s\n' "${source}" >&2
	exit 1
}

# A linked worktree is deleted on cleanup, which would leave dangling links.
[ ! -f "${repo_root}/.git" ] || {
	printf 'Run this from the main checkout, not a worktree: %s\n' "${repo_root}" >&2
	exit 1
}

check() {
	target="$1"
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
	target="$1"
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

check "${codex_target}"
check "${claude_target}"
link "${codex_target}"
link "${claude_target}"
