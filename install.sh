#!/bin/sh

set -eu

repo_root="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
source_root="${repo_root}/skills"
target_root="${CODEX_USER_SKILLS_DIR:-${HOME}/.agents/skills}"
legacy_root="${CODEX_HOME:-${HOME}/.codex}/skills"

test -d "${source_root}" || {
	printf 'Missing skills directory: %s\n' "${source_root}" >&2
	exit 1
}

found=0
for source in "${source_root}"/*; do
	[ -d "${source}" ] || continue
	[ -f "${source}/SKILL.md" ] || continue
	found=1
	name="$(basename -- "${source}")"
	target="${target_root}/${name}"
	legacy="${legacy_root}/${name}"

	if [ -L "${target}" ]; then
		current="$(readlink "${target}")"
		[ "${current}" = "${source}" ] || {
			printf 'Refusing to replace unrelated symlink: %s -> %s\n' "${target}" "${current}" >&2
			exit 1
		}
	elif [ -e "${target}" ]; then
		printf 'Refusing to replace existing path: %s\n' "${target}" >&2
		exit 1
	fi

	if [ "${legacy}" != "${target}" ] && [ -e "${legacy}" -o -L "${legacy}" ]; then
		printf 'Remove or migrate the legacy installation first: %s\n' "${legacy}" >&2
		exit 1
	fi
done

[ "${found}" -eq 1 ] || {
	printf 'No installable skills found under %s\n' "${source_root}" >&2
	exit 1
}

mkdir -p "${target_root}"

for source in "${source_root}"/*; do
	[ -d "${source}" ] || continue
	[ -f "${source}/SKILL.md" ] || continue
	name="$(basename -- "${source}")"
	target="${target_root}/${name}"
	if [ -L "${target}" ]; then
		printf 'Already linked: %s -> %s\n' "${target}" "${source}"
	else
		ln -s "${source}" "${target}"
		printf 'Linked: %s -> %s\n' "${target}" "${source}"
	fi
done
