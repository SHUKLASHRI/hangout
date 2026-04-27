# HANGOUT Design System 🎨✨

This document outlines the visual language, UI components, and aesthetic principles of the HANGOUT platform. Our goal is a **Premium, Socially-Secure, and Alive** experience.

---

## 💎 Design Pillars

1.  **Glassmorphism**: Depth through transparency and blur.
2.  **Liquid Glass**: Dynamic, fluid-like frosted effects for high-engagement areas.
3.  **Vibrant Trust**: Professional Navy foundation with energetic Orange accents.
4.  **Alive UI**: Staggered animations and micro-interactions that respond to user presence.

---

## 🎨 Color System (`AppColors`)

All colors are defined in `lib/theme/app_theme.dart`. **Never hardcode hex values.**

### **Primary Palette**
| Color | Hex | Purpose |
| :--- | :--- | :--- |
| `trustBlue` | `#2563EB` | Deep Blue — Trust, primary brand color |
| `socialOrange` | `#F97316` | Vibrant Orange — Energy, secondary brand color |
| `safetyGreen` | `#22C55E` | Success Green — Positive outcomes, safety |

### **Surface & Glass**
| Color | Hex | Purpose |
| :--- | :--- | :--- |
| `background` | `#F3F4F6` | Light gray background |
| `surface` | `#FFFFFF` | Solid card/surface color |
| `glassBase` | `#1AFFFFFF` | 10% White — Liquid Glass foundation |
| `glassOrange`| `#1AF97316`| 10% Orange — Tinted glass for social CTAs |

### **Semantic Colors (Trust & Action)**
| Color | Hex | Threshold |
| :--- | :--- | :--- |
| `trustGood` | `#1E7E34` | Score >= 4.0 (Safe) |
| `trustWarn` | `#E8681A` | Score 3.0 - 3.9 (Caution) |
| `trustBad` | `#C0392B` | Score < 3.0 (At Risk) |

---

## 🖋️ Typography

We use **Google Fonts** to maintain a premium feel.

-   **Headings**: `Plus Jakarta Sans` (Bold/Extrabold) — For high-impact titles.
-   **Body/Labels**: `Inter` — For maximum readability and UI text.
-   **Monospace**: `Consolas` or `Courier New` — For IDs and file paths.

---

## 🧊 Glassmorphism (`glass_kit`)

The `GlassCard` is our primary UI container. It provides a frosted-glass effect that makes the interface feel light and layered.

**Standard Implementation:**
```dart
GlassContainer(
  blur: 12,
  color: AppColors.glass,
  borderColor: Colors.white.withOpacity(0.3),
  borderWidth: 1.5,
  borderRadius: BorderRadius.circular(16),
  child: ...
)
```

---

## 🌊 Liquid Glass (`liquid_glass_easy`)

For high-engagement areas (like the "I'm Free Now" button or the Map Detail sheet), we use **Liquid Glass**. This creates a fluid, moving glass effect that makes the UI feel "alive."

**Usage Scenarios:**
-   Floating Action Buttons (FAB)
-   Bottom Sheet Headers
-   Trust Level Highlights

**Implementation Snippet:**
```dart
LiquidGlass(
  opacity: 0.15,
  blur: 20,
  child: Container(
    padding: EdgeInsets.all(16),
    child: Text("Premium Content"),
  ),
)
```

---

## 🎬 Animations (`flutter_animate`)

No screen should just "appear." Use staggered animations to guide the user's eye.

-   **Page Transitions**: `fadeIn` + `slideY(begin: 0.1)`
-   **List Items**: Staggered `fadeIn` (80ms delay per index).
-   **CTAs**: Subtle `shimmer` or `pulse` on high-priority buttons.

**Example:**
```dart
myWidget.animate()
  .fadeIn(duration: 300.ms)
  .slideY(begin: 0.2, end: 0, curve: Curves.easeOut);
```

---

## 📍 Iconography

We use **Lucide Icons** exclusively for a modern, thin-stroke aesthetic.
-   `LucideIcons.mapPin` — Hangout Location
-   `LucideIcons.users` — Group size
-   `LucideIcons.star` — Trust Score
-   `LucideIcons.clock` — Time/Expiry

---

## 📏 Layout & Grid

-   **Page Padding**: `20.0` (AppConstants.paddingPage)
-   **Card Radius**: `16.0` (AppConstants.radiusCard)
-   **Chip/Button Radius**: `24.0` (AppConstants.radiusChip)
-   **Vertical Rhythm**: Use `8.0`, `16.0`, `24.0` increments for spacing.

---

*"Design is not just what it looks like and feels like. Design is how it works."* 🥂✨
