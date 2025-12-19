# How to Create a Pull Request with CodeRabbit

## Prerequisites

1. **GitHub Repository**: Your code must be in a GitHub repository
2. **CodeRabbit Installation**: Install CodeRabbit from GitHub Marketplace
   - Go to: https://github.com/marketplace/coderabbitai
   - Click "Set up a plan" and choose your plan
   - Grant CodeRabbit access to your repository

## Step 1: Initialize Git Repository (if not already done)

```bash
cd /Users/tamimmultaheb/CascadeProjects/TaskFocusApp

# Initialize git if needed
git init

# Add all files
git add .

# Create initial commit
git commit -m "feat: Atomic Task iOS app with Supabase auth and smart swipe logic"
```

## Step 2: Create GitHub Repository

1. Go to https://github.com/new
2. Create a new repository (e.g., "atomic-task-ios")
3. **Do NOT** initialize with README, .gitignore, or license
4. Copy the repository URL

## Step 3: Push to GitHub

```bash
# Add remote origin
git remote add origin https://github.com/YOUR_USERNAME/atomic-task-ios.git

# Push to main branch
git branch -M main
git push -u origin main
```

## Step 4: Create a Feature Branch

```bash
# Create and switch to feature branch
git checkout -b feature/initial-implementation

# Push feature branch to GitHub
git push -u origin feature/initial-implementation
```

## Step 5: Create Pull Request

### Option A: Via GitHub Web Interface

1. Go to your repository on GitHub
2. Click "Pull requests" tab
3. Click "New pull request"
4. Select:
   - **Base**: `main`
   - **Compare**: `feature/initial-implementation`
5. Click "Create pull request"
6. **Title**: Use the title from PR_DESCRIPTION.md
7. **Description**: Copy the entire content from PR_DESCRIPTION.md
8. Click "Create pull request"

### Option B: Via GitHub CLI (if installed)

```bash
# Install GitHub CLI if needed
brew install gh

# Authenticate
gh auth login

# Create PR with description from file
gh pr create \
  --title "Atomic Task - iOS App Complete Implementation" \
  --body-file PR_DESCRIPTION.md \
  --base main \
  --head feature/initial-implementation
```

## Step 6: CodeRabbit Will Automatically Review

Once the PR is created, CodeRabbit will:
- ✅ Automatically analyze your code changes
- ✅ Provide inline comments and suggestions
- ✅ Generate a high-level summary
- ✅ Check for potential issues
- ✅ Suggest improvements

You'll see CodeRabbit's review appear as comments on your PR within a few minutes.

## Step 7: Respond to CodeRabbit's Feedback

- Review CodeRabbit's suggestions
- Make changes if needed
- Push updates to the same branch
- CodeRabbit will re-review automatically

## Step 8: Merge the PR

Once you're satisfied with the review:
1. Click "Merge pull request" on GitHub
2. Choose merge method (Squash and merge recommended)
3. Confirm merge
4. Delete the feature branch (optional)

## Quick Command Summary

```bash
# Complete workflow
cd /Users/tamimmultaheb/CascadeProjects/TaskFocusApp
git init
git add .
git commit -m "feat: Atomic Task iOS app with Supabase auth"
git remote add origin https://github.com/YOUR_USERNAME/atomic-task-ios.git
git branch -M main
git push -u origin main
git checkout -b feature/initial-implementation
git push -u origin feature/initial-implementation

# Then create PR via GitHub web interface or:
gh pr create --title "Atomic Task - Complete Implementation" --body-file PR_DESCRIPTION.md
```

## Troubleshooting

### CodeRabbit Not Reviewing?

1. Check CodeRabbit is installed for your repository
2. Verify `.coderabbit.yaml` is in the repository root
3. Check PR is not a draft (CodeRabbit skips drafts by default)
4. Wait a few minutes - initial reviews can take time

### Git Push Rejected?

```bash
# If you need to force push (use carefully)
git push --force-with-lease origin feature/initial-implementation
```

### Need to Update PR Description?

1. Edit the PR on GitHub web interface
2. Or update PR_DESCRIPTION.md and run:
```bash
gh pr edit --body-file PR_DESCRIPTION.md
```

## Files Created for This PR

- ✅ `.coderabbit.yaml` - CodeRabbit configuration
- ✅ `PR_DESCRIPTION.md` - Complete PR description
- ✅ `HOW_TO_CREATE_PR.md` - This guide

---

**Ready to create your PR!** 🚀
