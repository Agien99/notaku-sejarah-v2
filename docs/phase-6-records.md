# Phase 6 — Rekod & Statistik

Completed quiz submissions now persist locally. Leaving an unfinished quiz does
not create a record. Save failure retains the submitted result, offers a retry,
and warns before leaving. A UUID and database transaction prevent duplicate
records when the same save is retried. Starting another attempt creates a new ID.

## Storage

Sembast stores versioned records in the application support directory on native
platforms and IndexedDB on Web. No account, server, or cross-device sync is used.
Clearing application/browser data or uninstalling may remove history. Phase 5
in-memory attempts cannot be recovered retroactively.

Each record contains its UUID, form/chapter/title, UTC start/end timestamps and
immutable question/selected-answer/correct-answer/explanation snapshots. Scores
are derived from these snapshots, never from the current question bank. Dates
are shown in the device timezone. Time spent includes time with the quiz open
in the background. If the device clock moves backwards, duration is clamped to zero.

## Screens and calculations

- Rekod: newest attempts first, form/chapter filters, 20-attempt display batches.
- Details: score, date, elapsed time, all answer explanations, and chapter retry.
- Statistics: attempt count, best percentage, arithmetic mean of unrounded
  attempt percentages, distinct form/chapter count. All follow current filters.
- Performance groups: by form globally, by chapter after selecting a form.
- Utama: latest result and the latest three completed quizzes update after saving.
- Empty, loading, and retryable storage-error states do not invent results.

Statistics describe completed attempts only, not syllabus mastery. Note-reading
activity and note progress are not part of the quiz records database.

## Validation

Tests cover disk close/reopen, immutable answer snapshots, duplicate save,
chronological sorting, open failure/recovery, unrounded averages, empty records,
form filtering/detail review on compact/landscape/tablet sizes with large text,
and home updates after saving. Existing quiz flow tests exercise submission and
retry. CI must pass format, analysis, tests, Android APK and Web build before merge.

## Manual device checks

1. Complete a quiz, confirm the saved message and open its Rekod detail.
2. Close/relaunch the APK (or reload the same Web origin): the result must remain.
3. Retry the same chapter: confirm a second record and updated statistics.
4. Exit an unfinished quiz: verify no new record is created.
5. Check filters, answer review, portrait/landscape and increased text size.

The PR build produces APK/Web artifacts. GitHub Pages updates only after merge
to main; device relaunch and browser reload checks should be done on that build.
