#!/usr/bin/env bash
set -euo pipefail

chart="charts/headplane/Chart.yaml"
values="charts/headplane/values.yaml"
repo="ghcr.io/tale/headplane"

current=$(awk '/^appVersion:/ { gsub(/"/, "", $2); print $2 }' "$chart")
latest=$(gh api repos/tale/headplane/releases/latest --jq .tag_name)

current="${current#v}"
latest="${latest#v}"

if [[ "$(printf '%s\n%s\n' "$current" "$latest" | sort -V | tail -1)" == "$current" ]]; then
  exit 0
fi

IFS='.' read -r cur_maj cur_min _ <<< "$current"
IFS='.' read -r new_maj new_min _ <<< "$latest"

if (( new_maj > cur_maj )); then
  prefix="feat!(image)"
elif (( new_min > cur_min )); then
  prefix="feat(image)"
else
  prefix="fix(image)"
fi

subject="${prefix}: bump Headplane app image to ${latest}"
sed -i "s/^appVersion: .*/appVersion: \"${latest}\"/" "$chart"
sed -i "s|${repo}:${current}|${repo}:${latest}|" "$chart"
sed -i "s|^  tag: .*|  tag: \"${latest}\"|" "$values"

if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  {
    echo "upgraded=true"
    echo "headplane_version=${latest}"
    echo "commit_subject=${subject}"
  } >> "$GITHUB_OUTPUT"
fi
