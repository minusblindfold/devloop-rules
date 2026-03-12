---
keywords: [git, commit, branch, push, merge, squash, pull request, PR]
scope: always
---
# Git Workflow Conventions

> Branching strategy, commit message format, squash policy, and PR creation.

## Rules

### Branching

- Always create a `feature/<slug>` branch before making changes. Never commit directly to main.
- The slug should be a short, lowercase, hyphenated description of the work (e.g., `feature/add-user-auth`, `feature/fix-login-redirect`).

### Commit messages

- Write plain English commit messages. Short subject line (under 72 characters), optional 1-2 line body for context.
- Never include Co-Authored-By lines.
- Multiple commits during implementation are fine — commit naturally as you complete tasks.

### Before pushing

- Squash all commits on the feature branch into a single commit. Use `git reset --soft main && git commit` to collapse the branch into one clean commit.
- The squashed commit message should summarize all changes — not list individual commits.
- Push the feature branch with `-u` to set upstream tracking.

### After pushing

- Create a pull request using `gh pr create`.
- PR title should match the squashed commit subject.
- PR body should include a short summary of what changed and why.

## Bootstrap

Initialize a git repository with `git init`. Create a `.gitignore` appropriate for the project's stack. Make an initial commit on main, then create a `feature/<slug>` branch for the first task.

## Example

```bash
# Start work
git checkout -b feature/add-user-auth

# ... implement tasks, committing as you go ...
git commit -m "Add user entity and repository"
git commit -m "Add auth service and login endpoint"
git commit -m "Add security config and tests"

# Ready to push — squash into one commit
git reset --soft main
git commit -m "Add user authentication

Implement user entity, auth service, login endpoint, and security
configuration. Includes unit and integration tests."

# Push and create PR
git push -u origin feature/add-user-auth
gh pr create --title "Add user authentication" --body "..."
```
