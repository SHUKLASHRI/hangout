# HANGOUT: Product Requirements Document (PRD) 🥂

**Status**: Draft v1.0  
**Owner**: Shrinath Shukla (@SHUKLASHRI)  
**Goal**: Transition from a lonely world to a socially connected one through safe, local meetups.

---

## 1. Vision & Core Values

HANGOUT is more than a map; it's a **Trust Network**. Our mission is to facilitate spontaneous, face-to-face human connection without the pressure of dating or the noise of traditional social media.

### **The Three Pillars**
1.  **Safety First**: Exact meeting locations are private until user intent is verified.
2.  **Social Energy**: Built-in "I'm Free" mechanics to drive immediate engagement.
3.  **Trust-Driven UI**: A psychology-based design using **Deep Blue** (Reliability) and **Warm Orange** (Social Friendliness).

---

## 2. Target Audience
- **New City Residents**: People looking for "activity buddies" in a new environment.
- **Remote Workers**: Professionals seeking social coffee breaks or coworking sessions.
- **Hobbyists**: Gamers, athletes, and readers looking for local groups without a long-term commitment.

---

## 3. Functional Requirements

### **📍 Discovery (Map & Feed)**
- **Map View**: Real-time visualization of nearby hangouts. Markers pulse based on time-to-start.
- **Feed View**: A responsive masonry grid (Desktop) or card list (Mobile) for browsing interests.
- **Filters**: Categorization by activity (Work, Play, Eat, Sport).

### **💬 The Hangout Workflow**
- **The "I'm Free" Request**: One-tap participation request sending intent to the host.
- **Host Dashboard**: A simple interface for Shrinath to manage requests, approve guests, and view trust scores.
- **Meeting Point Reveal**: Upon approval, the "Locked" location unlocks for the approved participant.
- **Real-time Chat**: Dedicated ephemeral chat rooms for every hangout.

### **🛡️ Trust & Safety**
- **Global Trust Score**: A rating system (voted on after meetups) displayed on profiles.
- **Verified Brands**: Highlighting hangouts hosted at verified local businesses.

---

## 4. Design Requirements (The High-Fidelity Bar)

- **Liquid Transitions**: No "hard stops." Navigation between screens must feel fluid (Fade + Slide).
- **Responsive Layouts**: 
  - **Mobile**: Thumb-friendly interaction (Draggable sheets, bottom navigation).
  - **Desktop**: Information-rich interaction (Sidebars, multi-column grids).
- **Aesthetic**: White-frosted glassmorphism on a clean, light/gray background.

---

## 5. Roadmap

### **Phase 1: Foundation (Current)**
- [x] Basic Auth & Profile.
- [x] Map & Feed Discovery.
- [x] Responsive App Shell.

### **Phase 2: Engagement (Next 3 Months)**
- [ ] Production Firebase Firestore Chat.
- [ ] Push Notifications for approvals.
- [ ] Radius filtering (5km, 10km, 50km).

### **Phase 3: The Ecosystem (Future)**
- [ ] "Featured Hangouts" for local coffee shops.
- [ ] Achievement Badges (e.g., "Early Bird," "Super Host").
- [ ] Group Hangouts (v2.0 Architecture).

---

🥂 *Building for the future of human connection.*
