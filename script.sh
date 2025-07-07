#!/bin/bash

# Account details
PERSONAL_USER="jivansupe"
PERSONAL_EMAIL="jivansupe@gmail.com"
PERSONAL_SSH_KEY="~/.ssh/id_ed25519_personal"

WORK_USER="jivan-supe"
WORK_EMAIL="jivan.supe@indexnine.com"
WORK_SSH_KEY="~/.ssh/id_ed25519_work"

# Function to switch accounts
switch_account() {
  local account=$1

  case $account in
    personal)
      echo "Switching to personal account..."
      git config --global user.name "$PERSONAL_USER"
      git config --global user.email "$PERSONAL_EMAIL"

      cat > ~/.ssh/config <<EOF
Host github.com
  HostName github.com
  User git
  IdentityFile $PERSONAL_SSH_KEY
  IdentitiesOnly yes
EOF

      ssh-add $PERSONAL_SSH_KEY
      echo "Switched to personal account!"
      ;;

    work)
      echo "Switching to work account..."
      git config --global user.name "$WORK_USER"
      git config --global user.email "$WORK_EMAIL"

      cat > ~/.ssh/config <<EOF
Host github.com
  HostName github.com
  User git
  IdentityFile $WORK_SSH_KEY
  IdentitiesOnly yes
EOF

      ssh-add $WORK_SSH_KEY
      echo "Switched to work account!"
      ;;

    *)
      echo "Invalid account! Use 'personal' or 'work'."
      exit 1
      ;;
  esac

  # Ensure SSH config file has correct permissions
  chmod 600 ~/.ssh/config

  # Print the active Git username, email, and GitHub URL
  echo "Active Git configuration:"
  echo "Username: $(git config --global user.name)"
  echo "Email: $(git config --global user.email)"
  echo -n "GitHub URL: "
  ssh -G github.com | awk '/^hostname / {print "git@"$2":github.com"}'
}

# Check if an account parameter is passed
if [ -z "$1" ]; then
  echo "Usage: $0 [personal|work]"
  exit 1
fi

# Call the function with the provided parameter
switch_account $1
