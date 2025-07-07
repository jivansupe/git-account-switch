# 🔁 GitHub Account Switcher (Multi-Account Git Tool)

Switch between multiple GitHub accounts (e.g. personal & work) **seamlessly** on a single machine.  
No more manual credential juggling, GUI popups, or authentication failures.

---

## ✨ Features

- 🔄 One command to switch between GitHub accounts
- ✅ Stores tokens securely (without exposing them to Git prompts)
- 👥 Supports **multiple accounts** (like `personal`, `work`, or client-specific)
- 🛑 Disables annoying `git-askpass` popups and GUI prompts
- ✅ Works with any Git repo on your machine using HTTPS

---

## 🚀 How It Works

This script sets Git config and stores a personal access token (PAT) for the selected account in your `~/.git-credentials` file in a way Git understands.

---

## 🛠️ Setup Instructions

### 1. 📄 Create Personal Access Tokens (PATs)

For each GitHub account you want to use:

- Go to [https://github.com/settings/tokens](https://github.com/settings/tokens)
- Click **"Generate new token (classic)"**
- Recommended scopes:
  - ✅ `repo`
  - ✅ `read:org`
  - ✅ `workflow`
- Copy the generated token immediately — it’s shown only once.

---

### 2. 📁 Create the token file

Save your tokens in a file at:

```
~/.github_tokens
```

Format:

```ini
personal=ghp_yourTokenForPersonalAccountHere
work=ghp_yourTokenForWorkAccountHere
```

✅ You can add more accounts later using the same format.

---

### 3. 🧠 Know your account names and emails

These are hardcoded in the script for now. Make sure the following match your accounts:

```bash
personal → jivansupe → jivansupe@gmail.com  
work     → jivan-supe → jivan.supe@indexnine.com
```

You can edit these in the `change.sh` script inside the `GITHUB_ACCOUNTS` and `GITHUB_EMAILS` maps.

---

### 4. 💡 Optional: Make the script executable

```bash
chmod +x change.sh
```

Then you can run it as:

```bash
./change.sh
```

---

## 🔧 How to Use

Any time you want to switch accounts:

```bash
./change.sh
```

You’ll be prompted like:

```
Select a GitHub account:
1) personal
2) work
#?
```

Pick your account. The script:

- Sets global Git username/email
- Stores token in `~/.git-credentials` scoped to `github.com`
- Cleans up old credential helpers
- Prevents `git-askpass` and GUI prompts
- Verifies token is correct via GitHub API

After switching, you can push/pull to any repo that account has access to.

---

## 🔐 Security Notes

- Your token is stored in plain text in `~/.github_tokens` and `~/.git-credentials`
- Make sure those files have `600` permissions:
  ```bash
  chmod 600 ~/.github_tokens ~/.git-credentials
  ```
- Don’t commit or share these files!

---

## 🧼 Troubleshooting

**Problem** | **Solution**
--|--
🔁 Still being asked for username/password | Ensure token is stored at `https://github.com` level, not at repo/org level. Script handles this now.
🔒 Permission denied (403) | Token doesn’t have access to that repo — verify scopes or switch to correct account.
🧠 Still getting GUI login | Git Credential Manager or `git-askpass` not properly disabled — script now clears them.

---

## 💬 Example

```bash
$ ./change.sh
Select a GitHub account:
1) personal
2) work
#? 2

🔄 Updating stored GitHub credentials...
✅ Switched to 'work' account globally!
✅ Authentication successful for 'jivan-supe'!
```

---

## 📦 Git Repo Compatibility

- ✅ Works with **any Git repo using HTTPS**
- ✅ Private or public repos
- ✅ Org-level or personal accounts
- ❌ SSH remote URLs are not supported in this tool (yet)