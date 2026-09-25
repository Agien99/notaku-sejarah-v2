# Phase 3 — Nota

Phase 3 implements the complete Nota learning flow:

`Nota → Tingkatan → Bab → Reader`

## 3.1 Data and repository

- `NoteForm` and `NoteChapter` domain models.
- Local/offline-first repository.
- Chapter metadata includes the printed textbook page and physical PDF page.
- Tingkatan 1–3 are available.
- Tingkatan 4–5 remain **Akan Datang**.

## 3.2 Nota landing

- Responsive Tingkatan cards.
- Compact phone layout uses one column.
- Medium/tablet portrait uses two columns.
- Expanded/tablet landscape uses a Tingkatan + chapter master-detail layout.

## 3.3 Chapter list

- KSSM chapter list for Tingkatan 1–3.
- Each chapter displays its printed textbook page.
- Chapter selection opens the reader at the mapped physical PDF page.

## 3.4 Reader

- `pdfrx` asset reader for Android and Web.
- Direct chapter opening through `initialPageNumber`.
- Reading surface fills compact layouts and is width-limited on wide screens.
- Loading, unavailable, and load-error states.
- Retry action for PDF load failures.
- Bounded PDF rendering cache for the large offline documents.

## 3.5 Offline content migration

The original V1 PDFs are Git LFS objects in `Agien99/Notaku_Sejarah`.

V2 keeps those PDFs offline without committing another copy of the large
binaries into the new repository:

- `scripts/sync_note_assets.sh` synchronizes them on Linux/macOS/CI.
- `scripts/sync_note_assets.ps1` provides the Windows workflow.
- SHA-256 verification rejects Git LFS pointer files and corrupted downloads.
- Generated PDFs live under `assets/notes/` and are ignored by Git.
- Android and Web CI synchronize and verify all three PDFs before building.

### Local setup

Windows PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/sync_note_assets.ps1
flutter pub get
flutter run
```

Git Bash/Linux/macOS:

```bash
bash scripts/sync_note_assets.sh
flutter pub get
flutter run
```

Git and Git LFS are required for the first synchronization. Verified local PDFs
are reused on later runs.

## 3.6 Responsive and state behavior

- Phone portrait and landscape.
- Tablet portrait.
- Tablet landscape/expanded master-detail.
- Reader capped at 1120px on wide screens.
- Explicit loading, unavailable, and error/retry states.

## 3.7 Quality gates

Phase 3 is complete only when CI passes:

- Dart formatting;
- Flutter analyze;
- widget tests;
- Android debug APK build and identity verification;
- Flutter Web release build;
- verified offline PDF synchronization.
