
# 🔁 GitHub Account Switcher

Easily switch between multiple GitHub accounts (like personal and work) from the command line — without GUI prompts or credential headaches.

---

## 📦 Installation via NPM (Globally)

Install the CLI tool globally via npm:

```bash
npm install -g easy-git-account-switch
```

Once installed, use it anywhere via:

```bash
easy-git-account-switch
```

> This runs the same logic as `change.sh` but accessible system-wide as a command-line tool.

---

## ✨ Features

- One command to switch accounts
- Stores tokens securely
- Disables GUI prompts (`askpass`)
- Uses HTTPS (no SSH keys needed)
- Works with private and public repos
- Now available as a global CLI via npm

---

## 🚀 How It Works

This tool:
- Sets the global Git username and email
- Stores a personal access token (PAT) securely in `~/.git-credentials`
- Uses external config files to manage multiple accounts
- Prevents Git from triggering GUI prompts (askpass)
- Authenticates via GitHub API to verify your token
- Lists local Git repos and shows remotes

---

## 🛠️ Setup Instructions

### 1. Create GitHub Personal Access Tokens

- Visit: [https://github.com/settings/tokens](https://github.com/settings/tokens)
- Click "Generate new token (classic)"
- Select scopes like:
  - `repo`
  - `read:org`
  - `workflow`
- Copy and save the token

---

### 2. Create Token File

Create a file at:

```bash
~/.github_tokens
```

Example content:

```ini
personal=ghp_exampleTokenForPersonal
work=ghp_exampleTokenForWork
```

---

### 3. Create Account Config File

Create a file at:

```bash
~/.github_accounts
```

Example content:

```ini
# Format: account=username,email
personal=your-username,your-email@example.com
work=your-work-username,your-work-email@example.com
```

---

### 4. Make the Script Executable (If Using Locally)

```bash
chmod +x change.sh
```

Run it with:

```bash
./change.sh
```

Or globally, just use:

```bash
easy-git-account-switch
```

You’ll see:

```
Select a GitHub account:
1) personal
2) work
#?
```

---

## 🔒 Security Note

These files contain secrets:

- `~/.github_tokens`
- `~/.github_accounts`
- `~/.git-credentials`

Make sure they're protected:

```bash
chmod 600 ~/.github_tokens ~/.github_accounts ~/.git-credentials
```

Never commit them to any repository.

---

## 🧼 Troubleshooting

| Issue                         | Solution                                                                  |
|------------------------------|---------------------------------------------------------------------------|
| Still asked for credentials  | Ensure credentials are for `https://github.com`, and `askpass` is disabled |
| 403 error                    | Token might not have repo access, or wrong account selected                |
| GUI prompt shows up          | Run the script again to re-apply Git config                                |

---

## ✅ Example Usage

```bash
$ easy-git-account-switch
Select a GitHub account:
1) personal
2) work
#? 2

✅ Switched to 'work' account globally!
✅ Authentication successful!
```

---

## 🔗 Works With

- ✅ Any GitHub repo using HTTPS
- ✅ Personal or organization-owned repos
- ✅ Multiple GitHub accounts

❌ SSH remote URLs are not supported in this script.

---

Happy switching! 🔁
