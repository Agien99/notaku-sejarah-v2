# Notaku Sejarah V2

[![Flutter CI/CD](https://github.com/Agien99/notaku-sejarah-v2/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/Agien99/notaku-sejarah-v2/actions/workflows/flutter-ci.yml)

A modern, responsive Flutter rebuild of **Notaku Sejarah**.

## Current phase

**Phase 1 — Foundation & CI/CD**

Completed foundations:

- Flutter project foundation
- Modern Heritage design system
- Responsive compact / medium / expanded architecture
- Adaptive phone and tablet navigation
- Automated Flutter CI validation
- Android APK artifact builds
- Flutter Web builds and GitHub Pages deployment

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
    └── foundation/

test/
├── app_test.dart
└── core/
    └── responsive/
```

The temporary `foundation` feature is used only to validate Phase 1 architecture and will be replaced by real application features in later phases.
