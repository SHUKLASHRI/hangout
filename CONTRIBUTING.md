# Contributing to HANGOUT 🚀

Welcome to the team! Our goal is to build the most trustworthy and social discovery app in the world. To maintain our premium standard, please follow these guidelines.

---

## 🛠️ The Global Standards

### 1. Code Style
- **Formatting**: Always run `flutter format .` before committing.
- **Analysis**: Run `flutter analyze` to ensure 0 errors/warnings.
- **Linting**: We follow the `flutter_lints` package rules.

### 2. The Design System
- **Colors**: Never use hardcoded hex codes. Always use `AppColors.primary`, `AppColors.secondary`, etc. from `lib/theme/app_theme.dart`.
- **Icons**: Use `LucideIcons` (via `lucide_icons_flutter`) for a modern, consistent look.
- **Glassmorphism**: Use `GlassContainer` for floating elements to maintain the "frosted glass" aesthetic.

---

## 🌳 Git Workflow (Branching)

We use the **Feature Branch** model:

1.  **Branching**: Never work directly on `master`.
    - Features: `feature/short-description`
    - Bugfixes: `bugfix/issue-description`
2.  **Pull Requests**:
    - Submit a PR from your branch to `master`.
    - Provide a screenshot or description of the change.
    - **Wait for Lead Reviewer Approval** (Sagar) before merging.
3.  **Automated Checks**:
    - Every PR will trigger a GitHub Action to build the web app. If the build fails, the PR will be blocked.

---

## 📂 Project Structure

- `lib/screens`: All page-level widgets.
- `lib/widgets`: Reusable UI components.
- `lib/services`: External APIs (Firebase, Auth, Location).
- `lib/models`: Data structures and seed data.
- `lib/theme`: Central source of truth for colors and fonts.

---

## 🏁 Getting Started
1. Install Flutter (Stable branch).
2. Run `flutter pub get`.
3. Start the dev server: `flutter run -d chrome`.

Happy coding! 🥂🦾✨
