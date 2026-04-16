# HANGOUT: Technical Architecture 🏗️

This document explains the codebase structure and design patterns for the HANGOUT Flutter application.

---

## 🏗️ High-Level Folders

```text
lib/
├── main.dart          # Entry point & GoRouter configuration
├── models/            # Data structures (Hangout, User, SeedData)
├── screens/           # Full-page widgets (Map, Feed, Chat, etc.)
│   ├── auth/          # Login & Authentication screens
├── services/          # Business logic & Firebase APIs
├── theme/             # Global colors, typography, & UI tokens
└── widgets/           # Global reusable components
```

---

## 🛤️ Navigation (GoRouter)

We use **`go_router`** to handle all routing, including deep-linking and responsive shell layouts.

### **The App Shell**
All main navigation tabs (Map, Feed, Chat, Profile) are wrapped in a **`ShellRoute`**.
- **Mobile**: The shell provides a `BottomNavigationBar`.
- **Desktop**: The shell provides a persistent `Sidebar`.

### **Liquid Transitions**
We use `CustomTransitionPage` in `main.dart` to provide uniform fade-and-slide transitions between routes.

---

## ⚡ State Management (Provider)

We use the **`Provider`** package for state management.
- **`AuthService`**: Manages the user's login state and Firebase Auth integration.
- **Global Providers**: Injected at the root in `main.dart` to ensure availability across all screens.

---

## 🎨 Design System & Theming

### **Color Tokens**
All colors must be pulled from `AppColors` in `lib/theme/app_theme.dart`.
- `primary`: Trust Blue (`#2563EB`)
- `secondary`: Social Orange (`#F97316`)
- `surface`: Pure White / Soft Gray interaction layer.

### **Responsiveness**
Avoid hardcoded widths. Use **`LayoutBuilder`** and check screen constraints:
- `isWide = constraints.maxWidth > 800`
- Use this flag to toggle between Grid View (Desktop) and List View (Mobile).

---

## 🔥 Backend: Firebase

- **Authentication**: Google Sign-In & Phone Auth.
- **Database**: Cloud Firestore for real-time hangout data and chat messages.
- **Hosting**: Firebase Hosting (CI/CD automated via GitHub Actions).

---

## 🛡️ Best Practices for Contributors
- **Atomic Commits**: Keep your commits small and focused.
- **0-Lint Policy**: Run `flutter analyze` before pushing.
- **Documentation**: If you create a new Service or Model, add comments explaining it.

---

built by Shrinath Shukla & The HANGOUT Team. 🥂🦾✨
