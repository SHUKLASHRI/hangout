# HANGOUT Codebase Audit: Security Vulnerabilities, Hack Vectors, Crash Points & Optimizations

> **Audit Date:** October 2026  
> **Target Application:** HANGOUT (Flutter & Firebase Social Coordination App)  
> **Scope:** Architecture, Security Rules, Authentication, State Management, Data Layer, Map Rendering, UI/UX Resiliency

---

## Table of Contents
1. [Executive Summary](#1-executive-summary)
2. [Critical Security Vulnerabilities & Hack Vectors](#2-critical-security-vulnerabilities--hack-vectors)
3. [App-Breaking Crash Points & Denial-of-Service (DoS)](#3-app-breaking-crash-points--denial-of-service-dos)
4. [Broken Features & Disconnected Logic Flaws](#4-broken-features--disconnected-logic-flaws)
5. [Performance Bottlenecks & Optimization Opportunities](#5-performance-bottlenecks--optimization-opportunities)
6. [Prioritized Remediation Roadmap](#6-prioritized-remediation-roadmap)

---

## 1. Executive Summary

This comprehensive audit of the **HANGOUT** codebase evaluated security boundaries, database integrity, error resiliency, and runtime performance. 

While the application features a modern UI aesthetic and responsive multi-platform layout, **several critical security vulnerabilities in Firestore security rules allow malicious users to tamper with hangouts, spoof user trust scores, and leak private location data**. Furthermore, multiple null-safety and indexing bugs can cause client-wide crashes (DoS) from malformed or empty database inputs.

---

## 2. Critical Security Vulnerabilities & Hack Vectors

### 🔴 VULN-01: Broken Access Control on Hangout Updates (Tampering & Griefing)
- **Location:** `firestore.rules` (Lines 32–40)
- **Code:**
  ```javascript
  allow update: if isSignedIn() 
    && (
      request.auth.uid == resource.data.hostId
      || (request.resource.data.diff(resource.data).affectedKeys()
          .hasOnly(['participantIds', 'status']))
    );
  ```
- **How Someone Can Hack / Break It:**
  1. **Arbitrary Cancellation:** Any authenticated user (not just the host) can send a Firestore `update` request containing only `{'status': 'cancelled'}` or `{'status': 'completed'}` to **any hangout in the database**. An attacker can script an API call to cancel all active hangouts globally.
  2. **Participant List Tampering:** Any signed-in user can overwrite `participantIds` with an arbitrary array. An attacker can kick out legitimate participants, inject hundreds of fake user IDs (bypassing `maxParticipants`), or force other users into hangouts without their consent.
  3. **Capacity Limit Bypass:** The rule does not enforce `request.resource.data.participantIds.size() <= resource.data.maxParticipants`.

---

### 🔴 VULN-02: Trust Score, Suspension & Verification Spoofing (Client-Side Authority)
- **Location:** `firestore.rules` (Lines 15–20), `lib/models/user_model.dart`
- **Code:**
  ```javascript
  match /users/{userId} {
    allow read: if isSignedIn();
    allow write: if isOwner(userId);
  }
  ```
- **How Someone Can Hack / Break It:**
  1. **Suspension Bypass:** In `UserModel`, `isSuspended` and `canCreate` are stored directly in `/users/{userId}`. A suspended or banned user can issue a direct document update: `isSuspended: false, canCreate: true`.
  2. **Fake Trust Score:** Users can update their own `trustScore: 5.0`, `hangsCompleted: 1000`, and `noShows: 0`. Because the app relies on the client to calculate and write trust metrics, trust verification is completely client-spoofable.
  3. **Verification Forgery:** Any future admin or verification flags in the user profile can be granted by the user to themselves.

---

### 🔴 VULN-03: Physical Location Privacy Leak (Hidden Meeting Point Illusion)
- **Location:** `firestore.rules` (Lines 23–25), `lib/models/hangout_model.dart` (Lines 16–17, 56–57)
- **Code:**
  ```dart
  final GeoPoint meetingPoint; // Exact location (revealed on approval)
  final GeoPoint meetingZone;  // Approximate location (public)
  ```
  ```javascript
  match /hangouts/{hangoutId} {
    allow read: if isSignedIn();
  }
  ```
- **How Someone Can Hack / Break It:**
  1. The PRD and UI claim that the exact `meetingPoint` is private and only revealed after joining and host approval.
  2. However, both `meetingPoint` and `meetingZone` are stored together in the root `/hangouts/{hangoutId}` document.
  3. Because `allow read: if isSignedIn();` returns the whole document, **any signed-in user can query Firestore directly via REST or SDK and retrieve the exact GPS coordinates (`meetingPoint`) of any hangout, host's private meetup, or residential address without joining or host approval**.

---

### 🔴 VULN-04: Sybil Attacks & Unbounded Rating Manipulation
- **Location:** `firestore.rules` (Lines 45–49), `lib/services/trust_service.dart`
- **Code:**
  ```javascript
  match /ratings/{ratingId} {
    allow read: if isSignedIn();
    allow create: if isSignedIn() && request.resource.data.fromUid == request.auth.uid;
    allow update, delete: if false;
  }
  ```
- **How Someone Can Hack / Break It:**
  1. **Self-Rating:** A user can submit ratings where `toUid == request.auth.uid`, artificially boosting their own reputation.
  2. **Phantom Ratings:** There is no check that `hangoutId` exists or that the rater actually attended the hangout.
  3. **Score Range Tampering:** The rules do not enforce score bounds (`score >= 1 && score <= 5`). An attacker can send `score: 999999` or negative scores.
  4. **Rating Spam / Sybil Bombing:** An attacker can generate thousands of 1-star ratings against a victim's UID to completely destroy their trust score.

---

### 🔴 VULN-05: Realtime Database Wide Open / Unmanaged Backend Rules
- **Location:** `lib/main.dart` (Line 37), `firebase.json`
- **Code:**
  ```dart
  databaseURL: "https://hangout-72488-default-rtdb.asia-southeast1.firebasedatabase.app"
  ```
- **How Someone Can Hack / Break It:**
  1. `firebase.json` only configures hosting (`"public": "build/web"`).
  2. It does not configure `database.rules.json` or `firestore.rules`.
  3. If Realtime Database default test rules are active (`".read": true, ".write": true`), any external actor can dump or delete the entire Realtime Database.
  4. Furthermore, running `firebase deploy` does not deploy `firestore.rules`, leaving security rules unversioned in production.

---

### 🟠 VULN-06: Secrets Exposure in Flutter Assets & Git History
- **Location:** `pubspec.yaml` (Line 57), `.env`, `lib/main.dart` (Line 31), `lib/screens/location_picker_screen.dart` (Line 40)
- **Code:**
  ```yaml
  flutter:
    assets:
      - .env
  ```
- **How Someone Can Hack / Break It:**
  1. Bundling `.env` under `flutter.assets` packages the raw `.env` file into the APK, IPA, and public Web build (`/assets/.env`). Anyone inspecting browser network traffic or decompiling the APK can extract the API keys.
  2. Fallback Google Maps and Firebase API keys are hardcoded in Dart source files (`AIzaSyAXG-Vh5-aatnwfSwS4Za4zs_HVXf3Jp64` and `AIzaSyCbXKjrR-ru2QQwciyPjbakCj8UNjB7Rfg`).
  3. If the Google Maps key is unrestricted, attackers can use it for external Geocoding/Places queries, driving up cloud costs.

---

### 🟠 VULN-07: Unauthenticated Route Navigation & Missing Navigation Guards
- **Location:** `lib/core/router.dart`
- **How Someone Can Hack / Break It:**
  1. `GoRouter` does not contain any redirect logic (`redirect: (context, state) => ...`).
  2. Any user can type or deep link into `/map`, `/feed`, `/chat`, `/profile`, `/create`, or `/hangout/:id` without logging in.
  3. Once inside, accessing features with `auth.userModel == null` causes crashes or unpredictable permission errors.

---

## 3. App-Breaking Crash Points & Denial-of-Service (DoS)

### 💥 CRASH-01: Empty String Index Out-of-Bounds (`[0]`) Crash
- **Location:**
  - `lib/widgets/hangout_card.dart` (Line 152): `widget.hangout.hostName[0].toUpperCase()`
  - `lib/screens/hangout_detail_screen.dart` (Line 109): `hangout.hostName[0].toUpperCase()`
  - `lib/screens/host_dashboard_screen.dart` (Line 56): `name[0]`
  - `lib/screens/hangout/rating_screen.dart` (Line 69): `widget.targetName[0].toUpperCase()`
- **Impact:**
  - If a user registers or creates a hangout with an empty name `""`, or if Firestore contains a record where `hostName: ""`, accessing `[0]` immediately throws a fatal `RangeError (index): Invalid value: Valid value range is empty: 0`.
  - **Attack Scenario:** A malicious user creates a hangout with `hostName: ""`. When other users open the Feed or Map, the card rendering crashes the entire screen.

---

### 💥 CRASH-02: Corrupted Document Crashes Feed Stream Permanently
- **Location:** `lib/services/firestore_service.dart` (Lines 28–34), `lib/providers/hangout_provider.dart` (Lines 29–33)
- **Code:**
  ```dart
  return _db.collection('hangouts')
      .where('status', isEqualTo: 'active')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => HangoutModel.fromFirestore(doc)).toList();
  });
  ```
- **Impact:**
  - If a single document in `/hangouts` has a missing required field (e.g., missing `scheduledAt`, bad `GeoPoint`, or invalid type), `HangoutModel.fromFirestore(doc)` throws an unhandled exception.
  - In Rx/Dart Streams, an unhandled error inside `.map()` aborts the stream.
  - `HangoutProvider._init()` does not provide an `onError` callback:
    ```dart
    _service.streamActiveHangouts().listen((list) { ... }); // Missing onError
    ```
  - The UI is permanently frozen on `_isLoading = true` ("Finding hangouts near you..."), breaking the app for all users.

---

### 💥 CRASH-03: Fatal Exception Thrown in `HangoutDetailScreen.build()`
- **Location:** `lib/screens/hangout_detail_screen.dart` (Lines 25–28)
- **Code:**
  ```dart
  final hangout = hangoutProvider.hangouts.firstWhere(
    (h) => h.id == id,
    orElse: () => throw Exception("Hangout not found"),
  );
  ```
- **Impact:**
  - Throwing an uncaught `Exception` directly inside a widget's `build()` method causes Flutter's Red Screen of Death (or gray screen on Web).
  - This occurs whenever:
    1. A user refreshes a hangout URL directly in the browser (`/hangout/:id`).
    2. A hangout's status changes from `active` to `full` (which removes it from `streamActiveHangouts`).
    3. The active category filter does not match the hangout's category.

---

### 💥 CRASH-04: Force-Unwrapped Null User ID on Join / Leave
- **Location:** `lib/screens/hangout_detail_screen.dart` (Lines 252, 257)
- **Code:**
  ```dart
  context.read<HangoutProvider>().leave(hangout.id, uid!);
  context.read<HangoutProvider>().join(hangout.id, uid!);
  ```
- **Impact:**
  - `uid` is retrieved from `auth.userModel?.uid`.
  - If the user enters the screen while `userModel` is still loading or unauthenticated, tapping either button throws an unhandled `Null check operator used on a null value` crash.

---

### 💥 CRASH-05: State Mutation Inside `build()` in `AppShell`
- **Location:** `lib/screens/app_shell.dart` (Line 20), `lib/providers/app_state.dart` (Lines 40–46)
- **Code:**
  ```dart
  // Inside AppShell.build()
  final state = context.watch<AppStateProvider>();
  final routerState = GoRouterState.of(context);
  state.syncIndexWithRoute(routerState.matchedLocation);
  ```
  ```dart
  // Inside AppStateProvider
  void syncIndexWithRoute(String path) {
    ...
    notifyListeners();
  }
  ```
- **Impact:**
  - Calling `notifyListeners()` synchronously inside `build()` of a widget that watches that same provider triggers Flutter framework assertion errors (`setState() or markNeedsBuild() called during build`) and can cause infinite re-entrant rebuild cycles.

---

### 💥 CRASH-06: Unhandled Stream Error in `LocationProvider`
- **Location:** `lib/providers/location_provider.dart` (Lines 41–44)
- **Code:**
  ```dart
  _subscription = _service.positionStream.listen((position) {
    _currentPosition = position;
    notifyListeners();
  });
  ```
- **Impact:**
  - If the user revokes location permissions in Android/iOS app settings or disables GPS while the app is running, the position stream emits an unhandled error and crashes the listener.

---

## 4. Broken Features & Disconnected Logic Flaws

| Feature | File & Lines | Current Behavior | Expected Behavior |
| :--- | :--- | :--- | :--- |
| **Hangout Creation** | `lib/screens/hangout/create_screen.dart` (360–395) | Generates a local dummy object with `hostId: 'u_current'`, delays 1s, prints to console, and pops. **Never saves to Firestore.** | Validate fields, upload cover photo to Firebase Storage, call `HangoutService.createHangout` with real `auth.uid`. |
| **Hangout Cancellation** | `lib/screens/hangout_detail_screen.dart` (244–248) | Host button calls `setFilter(null)` and pops. **Does not cancel the hangout.** | Call `HangoutService.cancelHangout(hangout.id)`. |
| **Rating Submission** | `lib/screens/hangout/rating_screen.dart` (40–48) | Delays 1s and calls `recalculateTrust`. **Never saves `RatingModel` to Firestore.** | Save rating document to `/ratings`, verify rater attendance. |
| **Trust Recalculation** | `lib/services/trust_service.dart` (28–31) | Client updates `/users/{uid}`. When User A rates User B, **Firestore rules block User A from modifying User B's document** (`isOwner` violation). | Trust calculations should run securely on the server via Cloud Functions. |
| **Realtime Chat** | `lib/screens/chat_screen.dart` (140–185) | Displays static hardcoded messages ("Strategy Night", "Weekend Hike"). Send button has empty callback `onPressed: () {}`. | Connect to Firestore/Realtime Database subcollection `/hangouts/{id}/messages`. |
| **Host Dashboard** | `lib/screens/host_dashboard_screen.dart` (27–42) | Static hardcoded participants ("Arjun", "Sara"). Checkbox `onChanged: (val) {}` is empty; "Complete" button only pops screen. | Fetch real participants, verify attendance, award trust points and record no-shows. |
| **Sign Up Flow** | `lib/screens/auth/signup_screen.dart` (115–118) | Button has comment `// Will be integrated in Gen 19` and executes `context.go('/map')`. **No user is registered.** | Call `auth.signUpWithEmail(...)` and create user document in Firestore. |
| **Login Flow** | `lib/screens/auth/login_screen.dart` (72) | "Continue with Email" directly calls `context.go('/map')`. Phone and Web buttons are no-ops. | Present email/password text fields or Google auth modal. |
| **Google Sign-In Web** | `lib/services/auth_service.dart` (8) | Hardcoded `clientId: '1234567890-dummy.apps.googleusercontent.com'`. | Web OAuth crashes on invocation. Requires valid Google Cloud OAuth Client ID. |
| **FCM Push Notifications** | `lib/services/notification_service.dart` | Token is fetched via `getToken()`, but **never saved to the user profile in Firestore**. | Store token in `/users/{uid}/fcmTokens` to enable targeted push notifications. |

---

## 5. Performance Bottlenecks & Optimization Opportunities

### ⚡ OPT-01: Global Unbounded Hangout Stream (High Latency & Cloud Costs)
- **Problem:** `streamActiveHangouts()` queries `collection('hangouts').where('status', '==', 'active')` across the **entire global database**.
- **Impact:** If there are 10,000 active hangouts globally, every connected client downloads, parses, and listens to all 10,000 documents on app launch. This causes massive memory consumption and high Firestore read billing.
- **Optimization:**
  - Implement geo-bounding/geohashes (e.g., using `geoflutterfire_plus` which is already in `pubspec.yaml`).
  - Add query limits (`.limit(30)`) and pagination/infinite scrolling.

---

### ⚡ OPT-02: Main-Thread UI Freezing on Map Marker Generation
- **Problem:** In `MapScreen._updateMapElements`:
  ```dart
  for (final hangout in hangouts) {
    final icon = await MarkerGenerator.createCustomMarkerBitmap(
      HangoutMarkerWidget(hangout: hangout),
    );
    ...
  }
  ```
- **Impact:** For every hangout in the feed, a headless render pipeline is instantiated, rasterized to `ui.Image`, and encoded to PNG synchronously. Rendering 20 markers sequentially locks the UI thread for 1.5–3.0 seconds on mobile devices.
- **Optimization:**
  - Implement an in-memory `Map<String, BitmapDescriptor>` cache keyed by `activityType` and status.
  - Generate generic category markers rather than individual custom widgets for every single document, or generate markers asynchronously in background isolates / offscreen caches.

---

### ⚡ OPT-03: Geocoding API Quota Exhaustion & Lack of Debounce
- **Problem:** In `LocationPickerScreen`, `onCameraIdle` immediately triggers `_fetchAddress(_currentCenter)` without throttling or debouncing.
- **Impact:** Moving or panning the map fires repeated HTTP requests to the Google Maps Geocoding REST API. A user adjusting the pin over 5 seconds triggers 10–20 billed API calls. Furthermore, on Flutter Web, direct client-side HTTP calls to `maps.googleapis.com` are blocked by browser CORS policies.
- **Optimization:**
  - Add a 600ms debounce timer to `onCameraIdle`.
  - Use the native Google Maps JavaScript SDK Geocoder on Flutter Web.

---

### ⚡ OPT-04: GPU-Intensive `BackdropFilter` in Scrollable Cards
- **Problem:** `LiquidGlassCard` wraps content in `BackdropFilter(filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15))`. In `FeedScreen`, every item in the `SliverGrid` runs an independent blur shader.
- **Impact:** On mobile GPUs and Flutter Web (CanvasKit/Skwasm), rendering multiple active `BackdropFilter` layers during scrolling causes noticeable frame drops and jank. Additionally, in `HangoutCard`, an opaque white gradient is drawn directly over the blurred container, rendering the blur effect invisible while still consuming GPU cycles.
- **Optimization:**
  - Use semi-transparent solid/gradient cards with subtle borders instead of live `BackdropFilter` inside repeating scrollable lists.
  - Reserve `BackdropFilter` exclusively for static app bars and modal overlays.

---

### ⚡ OPT-05: Battery Drain from Global High-Accuracy Location Stream
- **Problem:** `LocationService` initializes `Geolocator.getPositionStream` with `LocationAccuracy.high` and a 10-meter distance filter.
- **Impact:** Because `LocationProvider` is registered as a global provider at the root of `runApp`, GPS hardware remains powered on continuously, rapidly draining battery even when the user is browsing their Profile or Settings.
- **Optimization:**
  - Pause the continuous position stream when the user leaves the Map screen.
  - Use `LocationAccuracy.medium` or `LocationAccuracy.low` for general discovery.

---

### ⚡ OPT-06: Bloated Dependencies & Dead Assets
- **Problem:**
  - `geoflutterfire_plus: ^0.0.1` is in `pubspec.yaml` but never imported or used.
  - `glass_kit: ^4.0.2` and `liquid_glass_easy: ^1.1.1` are redundant with custom `LiquidGlassCard`.
  - `shaders/liquid_glass.frag` is present in the repository but not registered in `pubspec.yaml` and never loaded.
- **Optimization:** Clean up `pubspec.yaml` dependencies and remove unused shaders and packages to reduce binary size and build times.

---

## 6. Prioritized Remediation Roadmap

```
┌────────────────────────────────────────────────────────────────────────┐
│ Phase 1: Security & Rule Hardening (Immediate)                         │
├────────────────────────────────────────────────────────────────────────┤
│ • Lock down firestore.rules: Disallow client modification of status,   │
│   trustScore, and isSuspended.                                         │
│ • Separate exact meetingPoint into private subcollection               │
│   (/hangouts/{id}/private/location) readable only by approved members. │
│ • Deploy database.rules.json and link firestore.rules in firebase.json.│
│ • Remove .env from pubspec.yaml assets; use compile-time dart-define.  │
└────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│ Phase 2: Crash Prevention & Error Handling                             │
├────────────────────────────────────────────────────────────────────────┤
│ • Replace all string[0] indexing with safe helpers (name.characters).  │
│ • Wrap Firestore stream mapping in try-catch; add onError to listeners.│
│ • Replace throw Exception() in HangoutDetailScreen with ErrorWidget.   │
│ • Remove state.syncIndexWithRoute() from AppShell.build().             │
│ • Add auth state redirect guards to GoRouter.                          │
└────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│ Phase 3: Wire Core Features to Backend                                 │
├────────────────────────────────────────────────────────────────────────┤
│ • Wire CreateHangoutScreen to HangoutService.createHangout().          │
│ • Wire Cancel button in HangoutDetailScreen to cancelHangout().        │
│ • Wire RatingScreen to Firestore ratings collection.                   │
│ • Implement Cloud Function for server-side trust score calculation.    │
│ • Connect Realtime Chat and Host Attendance to real data streams.      │
│ • Fix Login and Signup screens with genuine authentication calls.      │
└────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│ Phase 4: Performance & Rendering Optimization                          │
├────────────────────────────────────────────────────────────────────────┤
│ • Cache map marker bitmaps in memory by category.                      │
│ • Implement geohash querying (Geoflutterfire) with query limits.       │
│ • Debounce Geocoding requests in LocationPickerScreen.                 │
│ • Replace BackdropFilter in Feed cards with lightweight glass styles.  │
│ • Pause GPS streaming when not viewing the map.                        │
└────────────────────────────────────────────────────────────────────────┘
```
