# Rasch Measurement Explorations

Simulation studies and methods notes from the development of the R package
[easyRasch2](https://github.com/pgmj/easyRasch2), collected as a Quarto book.

Read it at <https://pgmj.github.io/rasch_book/>.

## Layout

- `index.qmd`: preface, including the status and versioning conventions.
- `chapters/`: one `.qmd` per study.
- `scripts/<topic>/`: simulations too slow to run at render time.
- `results/<topic>/`: saved simulation results that chapters read with
  `readRDS()`. A chapter whose simulation runs inline caches its results here.
- `_common.R`: sourced by every chapter's setup chunk.
- `references.bib`: shared bibliography.
- `_freeze/`: stored chapter output. Commit it.
- `slides/`: prebuilt revealjs decks and PDFs, listed on `presentations.qmd`.
  The sources live in `presentations/` outside this repo. Re-render a deck
  there and copy the self-contained `.html` (and `.pdf`) here to update it.

## Rendering

```bash
quarto render
```

Chapters are frozen, so only changed chapters re-run. The GitHub Pages workflow
publishes from `_freeze/` without running R.

## Adding a study from easyRasch2/dev

1. Copy the `.qmd` into `chapters/` and its scripts into `scripts/<topic>/`.
2. Replace the setup chunk with `source("_common.R")`.
3. Add the "About this chapter" box and summary (copy from an existing chapter).
4. Label sections (`{#sec-...}`) and figures (`#| label: fig-...`), and turn
   references to other studies into cross-references.
5. Move references into `references.bib`.
6. Add the chapter to `_quarto.yml` and render.
7. Leave a one-line pointer in `easyRasch2/dev` to the book chapter.

## Citation and DOIs

Connect the repository to Zenodo to get a DOI for each GitHub release. Release
when a chapter is added or a result changes.

## License

To be decided. A common choice is CC BY 4.0 for text and figures and MIT for code.
