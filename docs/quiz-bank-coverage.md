# Question bank — KSSM 2026.2

| Tingkatan | Bab | Soalan setiap bab | Jumlah |
| --- | ---: | ---: | ---: |
| 1 | 8 | 40 | 320 |
| 2 | 10 | 40 | 400 |
| 3 | 8 | 40 | 320 |
| 4 | 10 | 40 | 400 |
| 5 | 10 | 40 | 400 |
| Total | 46 | 40 | 1,840 |

## Scope and editorial status

These are original Malay-language practice items, not copied examination papers,
not endorsed by KPM and not yet independently reviewed by a qualified History
teacher. They focus on foundational recall, matching descriptions, basic
understanding and short contextual applications. They are not a complete
exam-style or KBAT bank. Teacher review of historical nuance, distractor quality,
curriculum depth and difficulty remains recommended before high-stakes use.

Questions are grouped by their chapter, with four alternatives and one keyed
answer. Explanations restate the matched fact concisely. Related ideas recur
across chapters where the curriculum revisits them; wording and context differ.
Technical uniqueness checks do not prove semantic uniqueness or historical truth.

## Authoring and maintenance

- Editable sources: `content/quiz/t1.txt` through `t5.txt`.
- `#N` starts a chapter. A block header has a question category and four answers.
- Four separately authored descriptions follow, each mapped to its corresponding
  answer. The compiler does not invent additional facts or reverse questions.
- Run `python3 scripts/build_quiz_banks.py` to generate JSON and the manifest.
- Run `python3 scripts/build_quiz_banks.py --check` to verify reproducibility.
- Do not edit generated JSON directly; correct the authoring source and rebuild.
- Every chapter has ten stored answer keys in each A/B/C/D position. The session
  engine independently shuffles choices and samples 15 distinct questions.
- Question IDs retain the established form/chapter/sequence convention. This
  expansion replaces the initial sample bank before persistent history exists.
  Once history is introduced, content-version-aware snapshots will be required.

## Checks

CI verifies that sources reproduce the committed assets. Flutter tests load every
registered chapter through `QuizRepository`, check 40 questions, unique IDs and
prompts, four distinct options, valid keys, explanations and balanced key positions.
A full-correct 15-question session is scored for every chapter after shuffling.
Existing selection, quiz/review/retry, exit, error and responsive tests still run.

## Source and cross-check trail

The original chapter organisation follows the bundled note assets and the
official JMM/IPIM DSKP-to-textbook mappings. These mappings establish scope; they
are not a claim that every practice item appears verbatim in a textbook.

- [JMM/IPIM curriculum mappings, Tingkatan 1–5](https://ipim.jmm.gov.my/pengenalan-1p1m/senarai-rph-ppm/dokumen-kurikulum)
- [Johor royal history: Sultan Alauddin Riayat Shah II](https://royal.johor.my/timeline/sultan-aladdin-riayat-shah-ii/)
- [Selangor State Assembly: Bukit Malawati and Raja Lumu](https://dewan.selangor.gov.my/question/bukit-malawati/)
- [UniSZA: Kesultanan Terengganu](https://kesultanantrg.unisza.edu.my/)
- [Arkib Negara: chronology towards 31 August 1957](https://pustakailmu.arkib.gov.my/index.php/ms/pustaka-ilmu/jendela-sejarah/menjejaki-31-ogos-1957)
- [Arkib Negara: Reid Commission](https://pustakailmu.arkib.gov.my/index.php/ms/pustaka-ilmu/jendela-sejarah/suruhanjaya-perlembagaan-reid)
- [Arkib Negara: Malayan Union](https://pustakailmu.arkib.gov.my/index.php/ms/pustaka-ilmu/jendela-sejarah/malayan-union-teladan-buat-generasi-kini-akan-datang)
- [Parliament: composition of Parliament](https://www.parlimen.gov.my/struktur-parlimen.html?uweb=p)
- [Ministry of Economy: development planning](https://ekonomi.gov.my/ms/pembangunan-ekonomi/rancangan-pembangunan/rmk/rancangan-malaysia-keempat-rmke-4-1981-1985)
- [Government portal: Rukun Negara](https://www.malaysia.gov.my/government/kenali-malaysia/rukun-negara)

Cross-check date: 26 September 2026. These references support selected dates,
institutions and chapter coverage. They are not a substitute for a full educator
review of all 1,840 items.
