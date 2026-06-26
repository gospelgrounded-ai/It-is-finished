# Parakletos

> *"And I will ask the Father, and he will give you another Helper."* — John 14:16

An on-device iOS app that helps men break free from pornography through friction, accountability, and grace. No server. No account. No analytics. Everything stays on your phone.

---

## First-time setup (Mac)

You need **Xcode 16+** and **Homebrew** installed.

```bash
# 1. Clone
git clone https://github.com/gospelgrounded-ai/It-is-finished.git
cd It-is-finished

# 2. Generate the Xcode project (one-time only)
bash generate.sh

# 3. Open in Xcode
open Parakletos.xcodeproj
```

In Xcode:
1. Select the **Parakletos** target → **Signing & Capabilities**
2. Choose your Apple ID from the **Team** dropdown
3. Plug in your iPhone → hit **▶ Run**

> ⚠️ Family Controls (M4 — real website blocking) will not run in the Simulator. Always test on a physical device.

---

## Bundle ID

Default: `com.parakletos.app`

To change it: edit `PRODUCT_BUNDLE_IDENTIFIER` in `project.yml` and re-run `bash generate.sh`.

---

## Project structure

```
Parakletos/
├── App/           Entry point, RootView, design tokens
├── Models/        SwiftData @Model classes + enums
├── Engine/        Streak logic, override state machine, seed loader
├── Views/
│   ├── Onboarding/
│   ├── Home/
│   ├── Override/  The 9-step friction gauntlet
│   ├── Settings/
│   └── Components/
├── Resources/     parakletos-content-seed.json
└── Supporting/    Info.plist, entitlements
ParakletosTests/   Unit tests for StreakEngine
```

---

## Milestones

| Milestone | Status | Description |
|-----------|--------|-------------|
| M0 | ✅ | Project scaffold + data models |
| M1 | ✅ | Streak engine, override flow, onboarding, home |
| M2 | 🔜 | Full override screen polish, journey view |
| M3 | 🔜 | Notifications, milestone celebrations |
| M4 | 🔜 | Real website blocking via Family Controls + Network Extension |

---

## Theology of the app

Copy tone: **grace, never shame.** A stumble is not the end of the story. Every screen after a fall gives encouragement. The word "failure" does not appear in this codebase.

All copy marked `// COPY:` is a draft for theological review.
