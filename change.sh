#!/bin/bash

CONFIG_FILE="$HOME/.github_accounts"
TOKEN_FILE="$HOME/.github_tokens"
CRED_FILE="$HOME/.git-credentials"

# Ensure config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "❌ Account config file not found: $CONFIG_FILE"
  echo "Format: account=username,email"
  exit 1
fi

# Load accounts into associative arrays
declare -A GITHUB_ACCOUNTS
declare -A GITHUB_EMAILS

while IFS='=' read -r account info; do
  username=$(echo "$info" | cut -d',' -f1)
  email=$(echo "$info" | cut -d',' -f2)
  GITHUB_ACCOUNTS["$account"]="$username"
  GITHUB_EMAILS["$account"]="$email"
done < <(grep -v '^#' "$CONFIG_FILE")

# Prompt user to choose an account
echo "Select a GitHub account:"
select ACCOUNT in "${!GITHUB_ACCOUNTS[@]}"; do
  if [[ -n "$ACCOUNT" ]]; then break; fi
  echo "Invalid selection, try again."
done

GITHUB_USER="${GITHUB_ACCOUNTS[$ACCOUNT]}"
GITHUB_EMAIL="${GITHUB_EMAILS[$ACCOUNT]}"

# Check token file
if [[ ! -f "$TOKEN_FILE" ]]; then
  echo "❌ Token file not found: $TOKEN_FILE"
  exit 1
fi

GITHUB_TOKEN=$(grep "^$ACCOUNT=" "$TOKEN_FILE" | cut -d '=' -f2-)
if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "❌ No token found for '$ACCOUNT' in $TOKEN_FILE"
  exit 1
fi

echo "🔄 Updating stored GitHub credentials..."

# Set Git config
git config --system --unset credential.helper 2>/dev/null
git config --global --unset-all credential.helper
git config --global --unset credential.helper manager 2>/dev/null
git config --global --unset credential.helper manager-core 2>/dev/null
git config --global credential.helper "store"
git config --global user.name "$GITHUB_USER"
git config --global user.email "$GITHUB_EMAIL"
git config --global core.askPass ""
export GIT_ASKPASS=echo
export GIT_TERMINAL_PROMPT=0
export GCM_INTERACTIVE=never

# Store token in credential file
rm -f "$CRED_FILE"
echo "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com" > "$CRED_FILE"
chmod 600 "$CRED_FILE"

echo "✅ Switched to '$ACCOUNT' account globally!"
git config --global --list | grep -E 'user.name|user.email|credential.helper'

# Optional repo awareness
echo "ℹ️ Skipping remote URL rewriting — assumed correct per repo."
find . -type d -name ".git" | while read git_dir; do
  repo_root=$(dirname "$git_dir")
  (
    cd "$repo_root" || exit
    REMOTE=$(git remote get-url origin 2>/dev/null)
    echo "📦 Repo: $repo_root → $REMOTE"
  )
done

# Validate token
echo "🔍 Verifying token for '$GITHUB_USER' via GitHub API..."
AUTH_CHECK=$(curl -s -u "${GITHUB_USER}:${GITHUB_TOKEN}" https://api.github.com/user)
AUTH_USERNAME=$(echo "$AUTH_CHECK" | grep '"login":' | cut -d '"' -f4)

if [[ "$AUTH_USERNAME" == "$GITHUB_USER" ]]; then
  echo "✅ Authentication successful for '$GITHUB_USER'!"
else
  echo "❌ Token verification failed or mismatched:"
  echo "$AUTH_CHECK"
fi
