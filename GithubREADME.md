# 📦 GitHub Workflow & Rules

This project follows a **feature-based workflow** to avoid conflicts and keep the codebase stable.

---

## 🔒 Main Rules (Read First)

- ❌ **Never push directly to `main`**
- ✅ Always work on a **feature branch**
- ✅ One feature = one branch
- ✅ Open a **Pull Request (PR)** for every change
- ❌ Do not edit files you don’t own without asking

---

## 📥 Clone the Repository

```bash
git clone https://github.com/<org-or-user>/<repo-name>.git
cd <repo-name>
```

## Keep Your Local Repo Updated

Before starting any work:
```bash
git checkout main
git pull origin main
```

## Branching Strategy 

create a new branch from main: (to implement a feature)

```bash
git checkout -b <name_of_branch>
```
checkout: change branches
-b or branch <name>: to create a branch 

## Working on a Feature
1. git pull repo (to update it)
2. change branch (**NOT MAIN**)
3. Do your changes
4. commit with a clear message:
```bash
git add .
git commit -m "Add login UI with validation"
```
5. push your branch
```bash
git push -u origin <your_branch_name>
```

## Pull Requests (PR)
- Open a PR **into** main
- Briefly explain:
    > what was changed
    > which files were touched
- Wait for review before merging
- ❌ No self-merging unless agreed

## Rules
- Auth logic -> Damianos
- Screens/UI -> UI collaborator


## 🚨 Conflict Prevention Checklist

Before pushing:

Did you pull from main recently?

Are you on the correct branch?

Are you touching only your assigned files?