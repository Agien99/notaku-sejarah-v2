# Phase 3 — Nota

Phase 3 implements the complete native Nota learning flow:

`Nota → Tingkatan → Bab → Native Note Reader`

## Curriculum snapshot

The content in this phase is versioned as:

- Curriculum: **KSSM**
- Effective school session: **2026**
- Content version: **2026.1**
- Reviewed: **25 September 2026**

The content model deliberately separates curriculum metadata from the reader.
This prevents future Kurikulum Persekolahan 2027 content from silently replacing
the KSSM material used by the 2026 cohort.

## Coverage

All five secondary forms are included:

| Form | Chapters |
| --- | ---: |
| Tingkatan 1 | 8 |
| Tingkatan 2 | 10 |
| Tingkatan 3 | 8 |
| Tingkatan 4 | 10 |
| Tingkatan 5 | 10 |
| **Total** | **46** |

Every chapter is stored as a small local JSON asset under:

`assets/notes/kssm_2026/`

The app does not bundle the original large V1 textbook PDFs.

## Native content model

Each chapter contains:

- overview;
- keywords;
- structured subtopics;
- concise bullet-point explanations;
- key facts;
- chapter summary;
- curriculum, version and review metadata.

The notes are revision-oriented summaries rather than page-for-page copies of
the textbooks.

## Responsive experience

### Compact phone

- single reading column;
- chapter hero;
- overview;
- keyword chips;
- subtopic cards;
- key-fact callout;
- chapter summary.

### Medium / tablet portrait

- same reading sequence with wider spacing and content width.

### Expanded / tablet landscape

- chapter table of contents on the left;
- independently scrollable reading content on the right.

## Data integrity

`AssetNoteContentRepository` loads and parses chapter JSON assets.

The reader validates that loaded content matches:

- Tingkatan;
- chapter number;
- chapter title;
- curriculum code;
- content version.

A mismatch is treated as a content error rather than displaying the wrong note.

## States

The native reader includes:

- loading state;
- error state;
- retry action;
- successful structured-content state.

## Quality gates

Phase 3 is complete only when CI passes:

- Dart formatting;
- Flutter analyze;
- all 46 JSON assets parse successfully;
- metadata validation tests;
- compact navigation tests;
- Tingkatan 4 and Tingkatan 5 tests;
- native reader tests;
- tablet landscape tests;
- Android debug APK build and identity verification;
- Flutter Web release build.
