# Phase 5 — Kuiz

## Experience

Select Tingkatan → Bab → answer 15 questions → confirm submission → view score
and explanations → retry or return to the chapter list. The existing Modern
Heritage theme is shared with Nota and Utama.

- Each attempt samples 15 distinct questions and shuffles each question's options.
- Answer IDs remain stable; visible A/B/C/D labels follow the shuffled order.
- Answers can be changed, and users can jump between questions without losing them.
- Progress counts answered questions. All 15 must be answered before submission.
- Submission locks the attempt. Review shows the chosen answer, correct answer,
  correctness as text and a symbol, and explanation for every question.
- Retry creates a new random attempt with no previous answers. A random draw may
  overlap an earlier attempt; it does not promise a completely disjoint set.
- Toolbar and system back ask before discarding an active attempt.
- Active attempts use a separate route so the shell navigation cannot discard them.
- Unregistered chapters are disabled with “Belum tersedia”. Load failures can be
  retried; banks below 15 questions cannot start.

## Content

All 46 Tingkatan 1–5 chapters now contain 40 original practice questions each
(1,840 total). Each attempt still samples 15 questions without replacement.
These are foundational matching/understanding items, not official examination
questions or a complete KBAT assessment. See `quiz-bank-coverage.md` for scope,
source references, authoring workflow and editorial limitations.

## Architecture and scope

`QuizRepository` loads and validates the bank. `QuizSession` owns copied,
immutable randomized questions, selected option IDs, submission and scoring.
The presentation layer does not parse assets or calculate correctness by display
position. Random injection supports reproducible engine tests.

Attempts are in memory. Persistent history and integration with Rekod/Utama belong
to the next phase; closing/reloading the application does not preserve an attempt.

## Verification

Engine tests cover the real bank, unique sampling, independent answer shuffling,
source immutability, answer-key preservation, edits, scoring, incomplete submission,
locked results, retries, insufficient banks and duplicate question IDs.
Widget tests cover selection, unavailable chapters, a complete attempt, review,
retry, exit confirmation, loading errors and small/landscape/tablet screens with
larger text. The existing CI quality, Android and Web gates remain enabled.
