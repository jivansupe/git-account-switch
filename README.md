# 🔁 GitHub Account Switcher

Easily switch between multiple GitHub accounts (like personal and work) from the command line — without GUI prompts or credential headaches.

## ✨ Features

- One command to switch accounts
- Stores tokens securely
- Disables GUI prompts (`askpass`)
- Uses HTTPS (no SSH keys needed)
- Works with private and public repos

## 🚀 How It Works

This tool:
- Sets the global Git username and email
- Stores a personal access token (PAT) securely in `~/.git-credentials`
- Uses external config files to manage multiple accounts
- Prevents Git from triggering GUI prompts (askpass)

## 🛠️ Setup Instructions

### 1. Create GitHub Personal Access Tokens

- Visit: [https://github.com/settings/tokens](https://github.com/settings/tokens)
- Click "Generate new token (classic)"
- Select scopes like:
  - `repo`
  - `read:org`
  - `workflow`
- Copy and save the token

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

### 4. Make the Script Executable

```bash
chmod +x change.sh
```

Run it with:

```bash
./change.sh
```

You’ll see:

```
Select a GitHub account:
1) personal
2) work
#?
```

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

## 🧼 Troubleshooting

| Issue                         | Solution                                                                 |
|------------------------------|--------------------------------------------------------------------------|
| Still asked for credentials  | Ensure credentials are for `https://github.com`, and `askpass` is disabled |
| 403 error                    | Token might not have repo access, or wrong account selected               |
| GUI prompt shows up          | Run the script again to re-apply Git config                               |

## ✅ Example Usage

```bash
$ ./change.sh
Select a GitHub account:
1) personal
2) work
#? 2

✅ Switched to 'work' account globally!
✅ Authentication successful!
```

## 🔗 Works With

- ✅ Any GitHub repo using HTTPS
- ✅ Personal or organization-owned repos
- ✅ Multiple GitHub accounts

❌ SSH remote URLs are not supported in this script.

---

Happy switching! 🔁
