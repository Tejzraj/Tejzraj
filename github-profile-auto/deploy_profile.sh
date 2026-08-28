#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════
#  One-click deploy: Tejzraj GitHub Profile README
# ═══════════════════════════════════════════════════════
set -e

# Set GITHUB_TOKEN as an environment variable before running this script:
#   export GITHUB_TOKEN="your_personal_access_token"
TOKEN="${GITHUB_TOKEN:?Error: GITHUB_TOKEN environment variable is not set}"
USERNAME="Tejzraj"
REPO_DIR="$(dirname "$0")/Tejzraj"

echo "🔍 Verifying repo exists on GitHub..."
STATUS=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: token $TOKEN" "https://api.github.com/repos/$USERNAME/$USERNAME")

if [ "$STATUS" != "200" ]; then
  echo ""
  echo "❌  Repo https://github.com/$USERNAME/$USERNAME not found (HTTP $STATUS)"
  echo ""
  echo "👉  Please create it first:"
  echo "    1. Go to https://github.com/new"
  echo "    2. Name it: $USERNAME (EXACTLY your username)"
  echo "    3. Set to Public"
  echo "    4. Check 'Add a README file'"
  echo "    5. Click Create repository"
  echo "    6. Run this script again"
  exit 1
fi

echo "✅  Repo found! Fetching default branch..."
DEFAULT_BRANCH=$(curl -s -H "Authorization: token $TOKEN" "https://api.github.com/repos/$USERNAME/$USERNAME" | python3 -c "import sys,json; print(json.load(sys.stdin)['default_branch'])")
echo "    Default branch: $DEFAULT_BRANCH"

echo ""
echo "📦  Setting up git remote and force-pushing..."

cd "$REPO_DIR"
git remote set-url origin "https://$USERNAME:$TOKEN@github.com/$USERNAME/$USERNAME.git" 2>/dev/null || true
git push -u origin "main:$DEFAULT_BRANCH" --force

echo ""
echo "🎉  SUCCESS! Your profile is live at:"
echo "    https://github.com/$USERNAME"
echo ""
echo "🐍  Snake animation will auto-generate on next GitHub Actions run."
echo "    Trigger it manually: https://github.com/$USERNAME/$USERNAME/actions"
