#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

msg="${1:-chore: update preview}"

git add -A

if git diff --cached --quiet; then
  echo "No changes to commit."
else
  git commit -m "$msg"
fi

branch="$(git rev-parse --abbrev-ref HEAD)"
git push -u origin "$branch"

owner_repo="$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || true)"
if [ -z "$owner_repo" ]; then
  origin="$(git remote get-url origin)"
  owner_repo="$(echo "$origin" | sed -E 's#.*github.com[:/](.+)(\.git)?#\1#' | sed 's/\.git$//')"
fi
pages="https://$(echo "$owner_repo" | cut -d/ -f1).github.io/$(echo "$owner_repo" | cut -d/ -f2)"
echo ""
echo "Published:"
echo "  $pages/"
echo "  $pages/zhibao/"
echo "  $pages/zhiban/"
echo "  $pages/zhiyan/"
echo "  $pages/tiaojie/"
