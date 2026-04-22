# HANGOUT: System Architecture 🏛️

This document details the technical implementation and social logic behind the HANGOUT platform.

---

## 💎 Design Philosophy: "Social Security"
The architecture is built around three core layers of safety and trust:
1. **Identity Layer**: Verified Google/Email Auth + 4-Step Onboarding.
2. **Privacy Layer**: Zone Privacy Mapping (500m fuzzy zones).
3. **Behavior Layer**: The Trust Score Engine.

---

## 📦 Data Architecture (The Super-Models)
All models in `lib/models/` follow the **Super-Model Pattern**:
- **Atomic Serialization**: `fromFirestore` and `toMap` for bidirectional sync.
- **Immutability**: `copyWith` for safe state transitions.
- **Embedded Logic**: Models contain their own display logic (e.g., `HangoutModel` handles its own expiry checks).

### **Core Models:**
- `UserModel`: Profile, Trust Score, and Onboarding state.
- `HangoutModel`: Multi-tier location data, participant tracking, and activity categorization.
- `RatingModel`: Peer-review data points.

---

## ⚙️ Logic Engines (The Services)
Services in `lib/services/` are stateless, single-responsibility units:
- **`TrustService`**: Recalculates user reputation using weighted averages and penalty logic.
- **`LocationService`**: Handles geofencing and distance calculations.
- **`HangoutService`**: Uses **Firestore Transactions** for atomic join/leave operations (prevents over-capacity).
- **`NotificationService`**: Manages FCM and Local Notification triggers.

---

## 🎨 UI Architecture (Atomic Glassmorphism)
The UI is composed from an **Atomic Widget Library** (`lib/widgets/`):
- `GlassCard`: The foundation.
- `TrustBadge`: Contextual trust signaling.
- `ActivityChip`: Visual categorization.
- `HangoutCard`: The primary discovery unit.

---

## 🚦 Navigation & Guarding
We use **GoRouter** with a master `AppShell`:
- **Auth Guard**: Splash screen redirects to `/login` if unauthenticated.
- **Onboarding Guard**: Redirects to `/onboarding` if profile is incomplete.
- **Deep-Linking**: Fully supported for `/hangout/:id`.

---

## 🌍 DevOps & Deployment
- **Repository**: GitHub (SHUKLASHRI/hangout)
- **CI/CD**: GitHub Actions (Fireship-style deployment on push to `master`).
- **Infrastructure**: Firebase (Auth, Firestore, Hosting, FCM).

---

*"Architected for trust, built for speed."* ⚡🦾
