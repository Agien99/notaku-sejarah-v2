# Notaku Sejarah V2

[![Flutter CI/CD](https://github.com/Agien99/notaku-sejarah-v2/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/Agien99/notaku-sejarah-v2/actions/workflows/flutter-ci.yml)

A modern, responsive Flutter rebuild of **Notaku Sejarah**.

## Current phase

**Phase 5 — Kuiz** adds chapter selection, 15 randomized questions per attempt,
answer navigation, scoring, explanations, retry and exit protection.

- Modern Heritage responsive app shell and Utama
- Nota by form/chapter with direct chapter navigation
- Validated question repository with a 20-question Tingkatan 1 Bab 1 practice bank
- Interactive quizzes with shuffled questions and answer choices
- Automated formatting, analysis, tests, Android APK and Flutter Web builds

Other quiz chapters are marked unavailable until their question banks are added.
Attempts currently live in memory; persistent history and Rekod integration are
planned for the next phase. See [Phase 5 details](docs/phase-5-kuiz.md).

## Phase 1 verification

Phase 1 has passed its final verification. The repository now has a clean Flutter foundation, centralized design and responsive systems, automated quality gates, verified Android APK artifacts, and a live Flutter Web preview.

See [Phase 1 Verification](docs/phase-1-verification.md) for the completion checklist.

## Toolchain

The CI pipeline currently pins:

- Flutter **3.47.5**
- Dart version bundled with Flutter 3.47.5
- Java **17** for Android builds

Pinning the Flutter version keeps local, CI, Android and Web builds reproducible across future development phases.

## Responsive architecture

Notaku Sejarah V2 uses three shared window classes:

| Window class | Width | Primary navigation |
| --- | ---: | --- |
| Compact | < 600px | Bottom navigation |
| Medium | 600–899px | Navigation rail |
| Expanded | >= 900px | Extended navigation rail |

Responsive behavior is centralized under `lib/core/responsive/` so feature screens do not need to implement independent breakpoint logic.

## CI/CD

GitHub Actions runs automatically on:

- pushes to `main`
- pull requests targeting `main`
- manual workflow dispatch

The quality gate performs:

1. Flutter toolchain verification
2. platform scaffolding generation
3. dependency resolution
4. Dart formatting validation
5. Flutter analysis with warnings and info-level issues treated as fatal
6. Flutter tests with coverage
7. coverage artifact upload

After the quality gate passes, Android and Web builds run independently.

### CI artifacts

Successful workflow runs provide:

- `notaku-sejarah-v2-debug-apk` — installable Android debug APK
- `notaku-sejarah-v2-web` — compiled Flutter Web output
- `notaku-sejarah-v2-coverage` — LCOV test coverage output

Artifacts are retained for 14 days.

## Android testing

The Android test build uses:

- App name: **Notaku Sejarah**
- Application ID: `com.digitechgien.notakusejarah`
- Version source: `pubspec.yaml`
- Build type: **debug APK**

The Android application ID is treated as stable from Phase 1 onward. The debug APK is intended only for internal development and device testing; production signing will be configured in a later release/deployment phase.

Each successful Android artifact contains:

- `notaku-sejarah-v2-debug.apk`
- `notaku-sejarah-v2-debug.sha256`
- `apk-badging.txt`

CI verifies the APK package name and visible Android application label after the APK is built.

### Test an APK from GitHub Actions

1. Open the repository's **Actions** tab.
2. Open the latest successful **Flutter CI/CD** run.
3. Find the **Artifacts** section.
4. Download `notaku-sejarah-v2-debug-apk`.
5. Extract the downloaded ZIP.
6. Transfer `notaku-sejarah-v2-debug.apk` to an Android phone.
7. Open the APK on the phone and allow installation from that source if Android requests permission.
8. Install and launch **Notaku Sejarah**.

This workflow allows device testing without running an Android emulator on the development computer.

## Web preview

The latest successful `main` build is deployed to:

https://agien99.github.io/notaku-sejarah-v2/

## Repository structure

```text
lib/
├── app/
├── core/
│   ├── responsive/
│   └── theme/
└── features/
    ├── home/
    ├── notes/
    ├── quiz/
    ├── records/
    └── shell/

test/
├── app_test.dart
└── core/
    └── responsive/
```

Feature implementations share the core theme and responsive navigation. Quiz content is stored under `assets/quiz/` and loaded through `QuizRepository`.
