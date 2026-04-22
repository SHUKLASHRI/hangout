# HANGOUT 🥂✨

A premium, trust-first social discovery platform built with Flutter. HANGOUT helps people connect through nearby activities in a safe, geofenced, and verified environment.

---

## 🏆 The 20-Generation Mastery Sprint
This repository has been fully architected and implemented over a **20-Generation AI Sprint**, resulting in a production-ready MVP with high-fidelity UI and a robust data engine.

### **Core Pillars**
- 🛡️ **Verified Trust**: Proprietary Trust Score Engine (4.0 Base) with late-cancellation penalties.
- 🗺️ **Privacy-First Mapping**: 500m "Approximate Zone" circles that reveal exact meeting points only to participants.
- ✨ **Premium Aesthetics**: High-fidelity glassmorphism, liquid transitions, and Outfit typography.
- 🚀 **E2E Automation**: Automated CI/CD pipeline via GitHub Actions and Firebase Hosting.

---

## 🛠️ Technical Stack
- **Frontend**: Flutter (Cross-platform Web/Mobile)
- **State**: Provider + ProxyProvider (Reactive Auth & Hangout Streams)
- **Navigation**: GoRouter with Shell Architecture & Navigation Guards
- **Backend**: Firebase Auth (Google/Email), Cloud Firestore, FCM
- **Architecture**: Domain-Driven Design with "Super-Models" (Serializable & Atomic)

---

## 📂 Project Structure
- `lib/core/`: The Hub. Centralized theme, routing, and constants.
- `lib/models/`: Super-Models with Firestore serialization logic.
- `lib/providers/`: Reactive state managers.
- `lib/services/`: Atomic business logic (Trust, Location, Hangouts).
- `lib/widgets/`: Atomic Widget Library (GlassCard, TrustBadge, HangoutCard).
- `lib/screens/`: Feature-complete screens (Map, Feed, Onboarding, Auth).

---

## 🚀 Getting Started

### **1. Setup Environment**
```bash
git clone https://github.com/SHUKLASHRI/hangout.git
cd hangout
flutter pub get
```

### **2. Development Mode**
```bash
flutter run -d chrome # or your emulator
```

### **3. Production Build**
```bash
flutter build web --release
firebase deploy
```

---

## 📄 Documentation
For deep dives into the system architecture and social logic:
- **[ARCHITECTURE.md](./ARCHITECTURE.md)**: Logic behind Trust Scores and Zone Privacy.
- **[CONTRIBUTING.md](./CONTRIBUTING.md)**: Coding standards and theme tokens.

---

Built with 🧡 by **Shrinath Shukla** & The HANGOUT Team.
*"Real connections, zero pressure."*
