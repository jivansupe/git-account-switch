#!/bin/bash

# GitHub accounts
declare -A GITHUB_ACCOUNTS=(
  ["personal"]="jivansupe"
  ["work"]="jivan-supe"
)

declare -A GITHUB_EMAILS=(
  ["personal"]="jivansupe@gmail.com"
  ["work"]="jivan.supe@indexnine.com"
)

# Select account
echo "Select a GitHub account:"
select ACCOUNT in "${!GITHUB_ACCOUNTS[@]}"; do
  if [[ -n "$ACCOUNT" ]]; then break; fi
  echo "Invalid selection, try again."
done

GITHUB_USER="${GITHUB_ACCOUNTS[$ACCOUNT]}"
GITHUB_EMAIL="${GITHUB_EMAILS[$ACCOUNT]}"

# Token lookup
TOKEN_FILE="$HOME/.github_tokens"
if [[ ! -f "$TOKEN_FILE" ]]; then
  echo "❌ Token file not found at $TOKEN_FILE"
  exit 1
fi

GITHUB_TOKEN=$(grep "^$ACCOUNT=" "$TOKEN_FILE" | cut -d '=' -f2-)
if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "❌ No token found for '$ACCOUNT' in $TOKEN_FILE"
  exit 1
fi

echo "🔄 Updating stored GitHub credentials..."

# Clear credential helpers
git config --system --unset credential.helper 2>/dev/null
git config --global --unset-all credential.helper
git config --global credential.helper "store"
git config --global core.askPass ""
export GIT_ASKPASS=echo
export GIT_TERMINAL_PROMPT=0
export GCM_INTERACTIVE=never

# Optional: turn off useHttpPath to avoid repo-specific matching
git config --global --unset credential.useHttpPath

# Set Git identity
git config --global user.name "$GITHUB_USER"
git config --global user.email "$GITHUB_EMAIL"

# Write plain host-level credentials
CRED_FILE="$HOME/.git-credentials"
rm -f "$CRED_FILE"
echo "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com" > "$CRED_FILE"
chmod 600 "$CRED_FILE"

echo "✅ Switched to '$ACCOUNT' account globally!"
git config --global --list | grep -E 'user.name|user.email|credential.helper|core.askPass'

# Repo context (optional info)
echo "ℹ️ Skipping remote URL rewriting — assumed correct per repo."
find . -type d -name ".git" | while read git_dir; do
  repo_root=$(dirname "$git_dir")
  (
    cd "$repo_root" || exit
    REMOTE=$(git remote get-url origin 2>/dev/null)
    echo "📦 Repo: $repo_root → $REMOTE"
  )
done

# GitHub token check
echo "🔍 Verifying token for '$GITHUB_USER' via GitHub API..."
AUTH_CHECK=$(curl -s -u "${GITHUB_USER}:${GITHUB_TOKEN}" https://api.github.com/user)
AUTH_USERNAME=$(echo "$AUTH_CHECK" | grep '"login":' | cut -d '"' -f4)

if [[ "$AUTH_USERNAME" == "$GITHUB_USER" ]]; then
  echo "✅ Authentication successful for '$GITHUB_USER'!"
else
  echo "❌ Token failed or doesn't match '$GITHUB_USER'"
  echo "$AUTH_CHECK"
fi
