# Phase 4 — Quiz Data Refactor

Phase 4 establishes the quiz data foundation before the interactive quiz engine is implemented.

## Architecture

```text
Quiz presentation
      |
QuizRepository
      |
Quiz asset manifest
      |
assets/quiz/kssm_2026/<form>_<chapter>.json
```

The presentation layer must not read JSON assets directly. It requests questions from `QuizRepository` by form and chapter.

## Question schema

Each question contains a globally unique `id`, `form`, `chapter`, `prompt`, answer `options`, `correctOptionId`, a non-empty `explanation`, and optional `tags`.

Question IDs use the convention `t<form>-b<chapter>-q<sequence>`, for example `t1-b01-q001`.

## Data integrity

`QuizRepository.validateQuestions` rejects empty or duplicate question IDs, wrong form/chapter metadata, empty prompts or explanations, invalid options, and answer keys that do not exist.

An unregistered chapter intentionally returns an empty question list. Question banks can therefore be added incrementally without coupling presentation code to asset paths.

## Initial bank

Phase 4 includes a small Tingkatan 1 Bab 1 bank derived from the existing local note content. Its purpose is to prove the schema, loading path and validation. Expanding the full curriculum question bank is content work and does not require changes to the repository contract.

## Verification

CI continues to enforce formatting, analysis, tests, Android APK build and Flutter Web build. Phase 5 can build quiz sessions, randomisation, scoring and result UX on this stable data layer.
