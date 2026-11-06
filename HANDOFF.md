# Project Handoff Document (HANDOFF.md)

**Project:** UPV/EHU · HEFA — Undergraduate Thesis / GRAL Template (Quarto Book + Typst)  
**Institution:** Faculty of Education, Philosophy and Anthropology (HEFA), University of the Basque Country (UPV/EHU)  
**Author / maintainer:** Daniel Losada (ORCID [0000-0003-3842-7694](https://orcid.org/0000-0003-3842-7694))  
**Repository:** <https://github.com/danloi2/gral-info> (public) · **Live site:** <https://danloi2.github.io/gral-info/>  
**Last Updated:** 2026-11-06 15:00 CET · commit `67c8cb2` on `main`  
**Template Version:** 1.1.0  
**Content Language:** Basque (Euskara) · **Documentation, commits & code comments:** English (see `AGENTS.md` §2)

---

## 1. Executive Summary

Publication-grade template for undergraduate theses (TFG / GRAL — *Gradu Amaierako Lana*) at HEFA, UPV/EHU. It is a **Quarto Book** (`project: type: book`) that renders one Markdown source into three outputs in `build/`:

1. **PDF (Typst):** `build/urtea-abizena-izena-eu.pdf` — the official deliverable: HEFA cover, HEFA/APA 7 styles, odd-page chapters, mirrored running headers.
2. **HTML web book:** `build/index.html` + `build/chapters/0X-*.html` — EHU-branded (UNIBERDEA sidebar, HEFA logo, EHUSans web font), search, white PDF/Word download icons.
3. **DOCX:** `build/urtea-abizena-izena-eu.docx` — supervisor review copy that mirrors the PDF layout.

Each section contains Basque guidance callouts (*Edukia*, *Luzera orientagarria*, *Aditz-denborak*…) telling students what to write. GitHub Actions rebuilds everything and publishes the site on every push to `main`.

---

## 2. Tech Stack & Environment Prerequisites

| Tool | Version / notes |
|:--|:--|
| **Quarto** | `1.10.20` verified (`quarto --version`). **Requires ≥ 1.9** (Typst book support and the orange-book behaviour handled below). Pinned in CI. |
| **Typst** | Bundled with Quarto (0.15.1 in 1.10.20); needs `block(sticky: true)` (≥ 0.12). |
| **Pandoc + citeproc** | Bundled with Quarto (Pandoc 3.10). APA 7 via `bibliography/apa.csl`. |
| **Chrome Headless Shell** | Needed to rasterise Mermaid diagrams for PDF/DOCX. Local: `quarto install chrome-headless-shell`. CI installs it. In sandboxes, allow access to Quarto's chrome-headless-shell directory. |
| **Fonts** | `EHUSans` / `EHUSerif` OTF in `assets/fonts/` (published with the user's consent). PDF loads them via `font-paths: assets/fonts`; HTML via `@font-face` in `templates/html/hefa.scss`; Word needs them installed system-wide. |
| **Python 3** | Only to regenerate `templates/docx/hefa-reference.docx` (`python3 templates/docx/build-reference-docx.py`, stdlib only). |
| **LibreOffice** (optional) | Only for visual DOCX checks without Word (see §7). |

---

## 3. Architecture & Repository Map

```text
├── _quarto.yml                  # project: book; metadata.tfg (YAML anchors); book.chapters/sidebar/page-footer; formats; filters
├── index.qmd                    # Landing page: hidden "Atariko atalak" title + {{< include >}} of front-matter/*
├── README.md · AGENTS.md · HANDOFF.md
├── .github/workflows/publish.yml # quarto render → GitHub Pages (checkout v7, configure-pages v6, upload-pages-artifact v5, deploy-pages v5)
├── .claude/skills/handoff/SKILL.md   # /handoff skill (Claude Code); .agents/skills/handoff/SKILL.md is a symlink to it
├── front-matter/
│   ├── azala.qmd                # Typst: re-applies hefa-chapter-heading, #include cover, metadata lets, #prelim-heading; DOCX cover placeholder
│   ├── eskerrak.qmd             # Acknowledgements ({.prelim} heading)
│   ├── laburpenak.qmd           # Laburpena / Resumen / Abstract + keywords ({.prelim} headings)
│   └── aurkibidea.qmd           # Typst: page counter reset, running headers/footers, #outline; DOCX TOC placeholder
├── chapters/01…08-*.qmd         # Numbered chapters (book.chapters); 07 holds ::: {#refs}
├── templates/
│   ├── typst/hefa-style.typ     # include-before-body: fonts, headings (hefa-chapter-heading), APA captions/tables, quotes, helpers
│   ├── typst/hefa-cover.typ     # HEFA cover; reads ../../_quarto.yml with yaml()
│   ├── typst/partials/          # typst-show.typ, page.typ, numbering.typ — replace Quarto's orange-book partials (DO NOT delete)
│   ├── html/hefa.scss           # HTML theme over Bootstrap cosmo
│   ├── html/caption-labels.html # Wraps caption labels for bold APA labels
│   ├── docx/hefa-reference.docx # Word styles/page/headers (generated — never edit by hand)
│   ├── docx/build-reference-docx.py # Generator of the reference doc
│   ├── docx/hefa-docx.lua       # post-render DOCX filter (cover, TOC, sections, captions, tables, callouts)
│   ├── filters/keep-with-next.lua   # PDF/DOCX: bold one-line subheadings stick to the next block
│   └── filters/apa-references.lua   # PDF: APA hanging indent in the reference list
├── bibliography/references.bib · apa.csl
├── assets/images/ · assets/fonts/
├── docs/reference/              # Local only (git-ignored): HEFA guide, EHU brand manual, Word cover model
└── build/                       # Generated output (git-ignored)
```

### Key design decisions (do not undo without reading)

1. **orange-book override.** Quarto ≥ 1.9 renders Typst books through its built-in *orange-book* template (own cover, outline, chapter style). `format.typst.template-partials` replaces its `typst-show.typ`, `page.typ` and `numbering.typ`. orange-book's Lua filter still runs but only acts on `parts:` / `appendices:` — **do not add those to `book:`**.
2. **Hidden landing title.** Quarto Book turns each file's first heading into the chapter title. `index.qmd` starts with `# Atariko atalak {#sec-atariko-atalak .unnumbered .unlisted}`; hidden in Typst (label check in `hefa-style.typ`) and removed by `hefa-docx.lua`.
3. **Continuous float numbering in the PDF.** Quarto injects a level-1 heading rule (after `hefa-style.typ`) that resets figure/table counters per chapter → duplicate "Irudia 1". `front-matter/azala.qmd` re-applies `#show heading.where(level: 1): hefa-chapter-heading` at the very top of the body so Quarto's reset never runs. DOCX: top-level `crossref.chapters: false`. HTML: `format.html.crossref.chapters: true` ("Taula 3.1") because pages are separate.
4. **Shared Typst scope.** All chapters become one Typst file, so `#let` values from `azala.qmd` (`egilea`, `lan-mota`, `prelim-heading`) are used later in `aurkibidea.qmd`.
5. **Single source of metadata.** `metadata.tfg` (`titulua`, `azpititulua`, `egilea`, `nan`, `gradua`, `zuzendaria`, `saila`, `ikasturtea`, `lan-mota`, `deialdia`); `book.title/subtitle/author` are YAML aliases. Output name: `book.output-file: "urtea-abizena-izena-eu"` — the HTML download hrefs in `book.sidebar.footer` hardcode it.
6. **DOCX mirrors the PDF** through `hefa-reference.docx` + `hefa-docx.lua` (`at: post-render`): odd-page sections, front matter without headers, TOC section restarts numbering, `STYLEREF` chapter in headers, `DOCPROPERTY hefa-lan-mota` / `hefa-egilea` on chapter-opening pages (`titlePg`), `HefaTable` only for tables with a header row (figure layouts and callouts are also tables), `CalloutTitle` + removal of Quarto's `cantSplit` so callout titles never sit alone.
7. **Page-break safety.** In the PDF callouts are unbreakable (Quarto default); bold one-line subheadings get `block(sticky: true)`.

---

## 4. Current State & Completed Milestones

**State at handoff:** clean working tree, `main` in sync with `origin/main`. `quarto render` (verified 2026-11-06 15:00 CET in `/home/danloi/Descargas/gral-info`) builds all formats with **no warnings**: PDF 83 pages, DOCX, HTML book (+ `sitemap.xml`, `robots.txt` from `site-url`). GitHub Actions run for `85f7b0f` succeeded (build 45 s, deploy 1 m 12 s, no Node 20 warnings); site and downloads return HTTP 200.

Milestones (all v1.1.0, 2026-11-06):

- **Working Quarto Book** — added the missing `book:` section (previously `ERROR: Book contents must include a home page`), chapters moved to `book.chapters`, orange-book partials replaced, HEFA cover is page 1, odd-page chapter headings with UNIBERDEA rule.
- **Repository reorganised** — English folder names (`front-matter/`, `chapters/`, `templates/`, `assets/`, `docs/reference/`), Basque content file names; unused files removed; `.gitignore` added; all code comments in English (inaccurate ones corrected).
- **EHU look for HTML** — HEFA logo (white background) on UNIBERDEA docked sidebar, EHUSans web fonts, link colour `#078743` (WCAG), page footer, APA captions/tables, icon-only white download buttons.
- **DOCX mirrors the PDF** — see design decision 6.
- **Page-break polish** — no orphan callout titles / bold subheadings (0 in PDF; 1 residual inside a DOCX callout body in LibreOffice only).
- **Sample references** — Ainscow 2020, Booth & Ainscow 2011, Braun & Clarke 2006, Creswell & Poth 2018, Hernández-Sampieri & Mendoza 2018 (+ existing ONU 2015) cited in chapters 1–3; chapter 7 lists them in all formats; APA hanging indent in the PDF. Typo fixed: ERFERENTZIAK → ERREFERENTZIAK.
- **Published** — public repo `danloi2/gral-info` (English README with author/ORCID, English About + topics), GitHub Pages via Actions; `docs/reference/` kept out of the repo by the user's choice.
- **Tooling** — workflow actions updated to Node 24 releases; `/handoff` skill moved to `.claude/skills/` (Claude Code only scans that folder).
- **v1.0.0 (2026-10)** — initial single-document template.

---

## 5. In-Progress Discussions & Technical Decisions

- **License.** README states MIT, but there is **no `LICENSE` file**. The EHUSans/EHUSerif fonts and the EHU logos are institutional assets, not necessarily MIT. Needs the user's decision (add `LICENSE` with an explicit exception for fonts/logos, or another licence).
- **Word fidelity.** The DOCX was only checked through LibreOffice. Still unconfirmed in Microsoft Word: TOC and DOCPROPERTY fields refreshing after the "update fields" prompt, `titlePg` header ("work type | author") on chapter-opening pages, keep-with-next inside split callout cells. The DOCX is ~2 pages longer than the PDF (85 vs 83) because Word callouts are taller.
- **Original working folder.** `/home/danloi/Descargas/gral-txantiloia/` is the pre-git copy (not a repository). It still contains `tmp/guia-del-alumnado-p3/` (the Practicum III example the HTML theme was ported from) and `docs/reference/`. Work now happens in the clone `/home/danloi/Descargas/gral-info/`.
- **CI runner.** GitHub notes that `ubuntu-latest` moves to Ubuntu 26 from 2026-10-19; nothing to change unless the build breaks (could pin `ubuntu-24.04`).

---

## 6. Immediate Next Steps & Action Items

1. **Decide and add a `LICENSE`** (see §5); keep README consistent.
2. **Open the DOCX in Microsoft Word**, accept "update fields", and check TOC, running headers on chapter-opening pages and callout page breaks; adjust `templates/docx/*` if needed (re-run `build-reference-docx.py` after style changes).
3. **Cover footer** (address · email · phone) wraps to two lines at 8 pt in the PDF; shorten or split deliberately in `templates/typst/hefa-cover.typ` and the DOCX cover in `hefa-docx.lua`.
4. **HTML landing page** shows the book title plus the "Atariko atalak" heading and the `aurkibidea.qmd` guidance callout (mostly meaningful in the PDF); consider hiding them for HTML.
5. **Running-header chapter text in DOCX** includes the number ("1. SARRERA"); the PDF shows the title only.

Edge cases to keep in mind:
- Renaming `book.output-file` → also update the two hrefs in `book.sidebar.footer`.
- `quarto render --to html` empties `build/` (download buttons 404 until a full render).
- New chapters must start with one level-1 heading; new figures/tables keep captions on top.
- Only cited works appear in chapter 7; keep at least the sample citations in the template.
- Do not add `project.resources` globs for fonts (unanchored globs also match nested folders).

---

## 7. Build, Verification & Command Cheat Sheet

Run from the repository root (never `quarto render index.qmd` alone):

```bash
# Render all configured formats (use this before publishing)
quarto render

# Render Typst PDF version → build/urtea-abizena-izena-eu.pdf
quarto render --to typst

# Render Word DOCX version → build/urtea-abizena-izena-eu.docx
quarto render --to docx

# Render HTML web version → build/index.html (empties build/: PDF/DOCX disappear)
quarto render --to html

# Live web preview
quarto preview

# Debug the Typst source (keeps ./index.typ; delete it afterwards)
quarto render --to typst -M keep-typ:true

# Regenerate the Word reference document after changing DOCX styles
python3 templates/docx/build-reference-docx.py
```

Visual DOCX check without Word (LibreOffice; fontconfig must include `assets/fonts/`, and keep odd-page blanks):

```bash
soffice --headless --convert-to 'pdf:writer_pdf_Export:{"IsSkipEmptyPages":{"type":"boolean","value":"false"}}' --outdir /tmp build/urtea-abizena-izena-eu.docx
```

Publishing: push to `main` → *Actions* → **Publish to GitHub Pages** (or *Run workflow* manually). Check with `gh run list -R danloi2/gral-info`.
