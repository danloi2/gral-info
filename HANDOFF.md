# Project Handoff Document (HANDOFF.md)

**Project:** UPV/EHU · HEFA — Undergraduate Thesis / GRAL Template (Quarto Book + Typst)  
**Institution:** Faculty of Education, Philosophy and Anthropology (HEFA), University of the Basque Country (UPV/EHU)  
**Last Updated:** November 6, 2026  
**Template Version:** 1.1.0  
**Content Language:** Basque (Euskara)  
**Documentation & Handoff Language:** English  
**Comment Language (all files):** English — see `AGENTS.md` §2  

---

## 1. Executive Summary

Academic monograph template for Undergraduate Theses (TFG / GRAL) at HEFA, UPV/EHU, structured as a **Quarto Book** (`project: type: book`) with three outputs, all written to `build/`:

1. **Typst (PDF):** `build/urtea-abizena-izena-eu.pdf` — official deliverable with the HEFA cover (`templates/typst/hefa-cover.typ`), HEFA/APA 7 styling (`templates/typst/hefa-style.typ`) and alternating running headers.
2. **HTML (Web Book):** `build/index.html` + `build/chapters/0X-*.html` — one page per chapter, sidebar, search, and PDF/DOCX download buttons.
3. **DOCX (Word):** `build/urtea-abizena-izena-eu.docx` — single document for supervisor review.

---

## 2. Technical Stack & Dependencies

- **Quarto:** Verified on `1.10.20`. Requires `>= 1.9` (Typst books + orange-book behaviour described below).
- **Typst:** Bundled with Quarto.
- **Pandoc + citeproc:** Bundled with Quarto (APA 7 via `bibliography/apa.csl`).
- **Chrome headless shell:** Needed by Quarto to rasterise Mermaid diagrams for PDF/DOCX. In sandboxed environments allow access to Quarto's chrome-headless-shell directory.
- **Fonts:** `EHUSans` / `EHUSerif` OTF files in `assets/fonts/`. The PDF loads them directly via `font-paths: assets/fonts`; Word needs them installed system-wide.

---

## 3. Project Architecture

```text
├── _quarto.yml                  # project: book, metadata.tfg (YAML anchors), book.chapters, formats
├── index.qmd                    # Book landing page: hidden title + includes of front-matter/*.qmd
├── .gitignore                   # Ignores build/, .quarto/, *_files/, index.typ
├── front-matter/
│   ├── azala.qmd                # #include of the cover + metadata lets (egilea, lan-mota…) + #prelim-heading
│   ├── eskerrak.qmd             # Acknowledgments
│   ├── laburpenak.qmd           # Trilingual abstracts (eu / es / en) + keywords
│   └── aurkibidea.qmd           # Page counter reset, running headers/footers, #outline (Aurkibidea)
├── chapters/01…08-*.qmd         # Numbered chapters (registered in book.chapters)
├── templates/typst/
│   ├── hefa-style.typ           # Typst rules (include-before-body): headings, APA 7, palette, helpers
│   ├── hefa-cover.typ           # HEFA cover page; reads ../../_quarto.yml with yaml()
│   └── partials/                # Template partials replacing Quarto's orange-book book template
│       ├── typst-show.typ       #   minimal document setup (lang, font, heading numbering); no cover/TOC
│       ├── page.typ             #   A4 + HEFA margins, no page numbering by default
│       └── numbering.typ        #   continuous APA 7 numbering for figures/tables/equations
├── templates/html/
│   ├── hefa.scss                # HTML theme: EHU palette, EHUSans web font, logo sidebar, APA captions/tables
│   └── caption-labels.html      # Wraps caption labels so they can be bold (APA 7)
├── bibliography/                # references.bib + apa.csl
├── assets/images/  assets/fonts/
├── docs/reference/              # Official reference docs (HEFA guide, EHU brand manual, Word cover model)
├── AGENTS.md  README.md  .claude/skills/handoff/SKILL.md   # /handoff skill (.agents/skills/ links to it)
└── build/                       # All outputs (generated)
```

### Key design decisions

1. **orange-book override.** Quarto ≥ 1.9 renders Typst books through its built-in *orange-book* extension (own cover, outline and chapter styling). This used to replace the HEFA cover and override the level-1 heading rule. `format.typst.template-partials` now points to `templates/typst/partials/*.typ`, which replace orange-book's `typst-show.typ`, `page.typ` and `numbering.typ`. orange-book's Lua filter still runs, but it only acts on `part`/`appendix` book items, which this project does not use — **do not add `parts:` or `appendices:` to `book:`** without revisiting this.
2. **Chapter titles.** Quarto Book converts the first heading of every file into a level-1 chapter heading. `index.qmd` therefore starts with `# Atariko atalak {#sec-atariko-atalak .unnumbered .unlisted}`; in Typst the level-1 show rule returns nothing for the `<sec-atariko-atalak>` label. In HTML/DOCX it appears as the heading grouping the preliminaries.
3. **Level-1 headings (PDF).** Defined only in `hefa-style.typ`: `pagebreak(weak: true, to: "odd")` outside the block, 16 pt EHUSans bold, number + body, 3.5 cm UNIBERDEA rule. Chapters no longer need explicit `#pagebreak` blocks.
4. **Shared Typst scope.** In the book PDF all chapters are concatenated into one Typst file, so `#let` bindings from `front-matter/azala.qmd` (`egilea`, `lan-mota`, `prelim-heading`…) are visible in later sections (`front-matter/aurkibidea.qmd` headers use them).
5. **Single source of metadata.** `metadata.tfg` holds all student data; `book.title/subtitle/author` are YAML aliases (`*titulua`, `*azpititulua`, `*egilea`). Output name: `book.output-file: "urtea-abizena-izena-eu"`.

---

## 4. Completed Milestones

- **v1.1.0 (2026-11-06) — Published.** Public repo https://github.com/danloi2/gral-info; `.github/workflows/publish.yml` renders all formats with Quarto 1.10.20 (+ Chrome Headless Shell for Mermaid) and deploys `build/` to GitHub Pages (https://danloi2.github.io/gral-info/). `docs/reference/` is git-ignored (not published).
- **v1.1.0 (2026-11-06) — Page-break polish and sample references.** Callout titles stay with their body in DOCX (`CalloutTitle` style, Quarto's `cantSplit` removed); bold one-line subheadings stay with the next block in PDF and DOCX (`templates/filters/keep-with-next.lua`); APA hanging indent in the PDF reference list (`templates/filters/apa-references.lua`). Added five real references (Ainscow 2020; Booth & Ainscow 2011; Braun & Clarke 2006; Creswell & Poth 2018; Hernández-Sampieri & Mendoza 2018) with sample citations in chapters 1–3, so chapter 7 lists references in all formats. Fixed chapter title typo ERFERENTZIAK → ERREFERENTZIAK.
- **v1.1.0 (2026-11-06) — DOCX mirrors the PDF.** New `templates/docx/` (reference doc + generator script + post-render Lua filter): HEFA cover from `metadata.tfg`, no Pandoc title block, front matter without running headers, TOC after the abstracts, odd-page sections like the PDF, mirrored headers with chapter (STYLEREF) and author/work type (DOCPROPERTY), outer page numbers, APA captions and tables. Chapter start pages match the PDF for the first chapters; the DOCX grows ~10% longer because Word callouts are taller.
- **v1.1.0 (2026-11-06) — EHU look for the HTML book** (ported from the Practicum III guide in `tmp/`): HEFA logo on an UNIBERDEA docked sidebar, EHUSans web fonts, accessible link colour, page footer, APA 7 captions (bold label / italic title) and tables. Fixed duplicate float numbers in the PDF ("Irudia 1" in two chapters) by bypassing Quarto's per-chapter counter reset; DOCX is now continuous too; HTML numbers per chapter. Output name is now `urtea-abizena-izena-eu` (`book.output-file`).
- **v1.1.0 (2026-11-06) — Visible HTML download buttons.** `book.sidebar.footer` adds "Deskargatu PDF" / "Deskargatu Word (DOCX)" buttons (styled in `templates/html/hefa.scss`); Quarto's native `downloads` icon was too discreet. Note: an HTML-only render deletes the PDF/DOCX from `build/` (404 on the buttons); always run `quarto render`.
- **v1.1.0 (2026-11-06) — Repository reorganised.**
  - English folder names: `capitulos/` → `chapters/` + `front-matter/`, `recursos/` → `templates/typst/` (+ `partials/`), `images/` and `fonts/` → `assets/`, reference PDFs/DOCX → `docs/reference/`.
  - Front-matter files renamed: `00-azala` → `azala`, `00-eskerrak` → `eskerrak`, `00-laburpenak` → `laburpenak`, `00-tabla-contenido` → `aurkibidea`. Typst files: `estilo-hefa.typ` → `hefa-style.typ`, `portada-hefa.typ` → `hefa-cover.typ`.
  - Removed unused files: `cover.png` (EPUB logo), `_extension.yml`, `test_cond_files/`, `test_main_files/`. Added `.gitignore`.
  - All code/config comments are now in English (`_quarto.yml`, `templates/typst/**`, `index.qmd`, `front-matter/*.qmd`); inaccurate comments were corrected along the way (no font fallback exists; footer starts in `aurkibidea.qmd`; cover labels are Basque-only).
- **v1.1.0 (2026-11-06) — Working Quarto Book.**
  - Added the missing `book:` section (chapters, downloads, search, output-file); removed `project.render` and top-level `downloads`/`search`, which caused `ERROR: Book contents must include a home page`.
  - `index.qmd` reduced to preliminaries only; chapters moved to `book.chapters`.
  - Replaced orange-book partials → HEFA cover is page 1 of the PDF; no default Quarto/orange-book cover or outline.
  - Rewrote the level-1 heading rule (odd-page start, consistent size, green rule).
  - Removed dead duplicated code at the end of `hefa-cover.typ`; added `lan-mota` to `metadata.tfg`.
  - Verified `quarto render` builds PDF (83 pages), DOCX and HTML with no warnings.
- **v1.0.0 (2026-10)** — Initial single-document template (Typst cover, APA 7 styles, trilingual abstracts, guidance callouts).

---

## 5. Build Commands

Run from the repository root:

```bash
quarto render                 # all formats
quarto render --to typst      # build/urtea-abizena-izena-eu.pdf
quarto render --to docx       # build/urtea-abizena-izena-eu.docx
quarto render --to html       # build/index.html (multi-page book)
quarto preview                # live web preview
quarto render --to typst -M keep-typ:true   # debug: keeps ./index.typ (delete afterwards)
```

---

## 6. Known Issues & Next Steps

1. **Cover footer wraps to two lines** (address · email · phone) at 8 pt; consider reducing size or splitting deliberately.
2. **DOCX not verified in Microsoft Word** (only via LibreOffice). Expected Word-only behaviour to confirm: TOC and DOCPROPERTY header fields refresh after accepting the "update fields" prompt; chapter-opening pages show "work type | author" (`titlePg`; LibreOffice shows the chapter instead). Header chapter text includes the number ("1. SARRERA") because Pandoc writes heading numbers as text.
3. **HTML landing page** shows the book title plus the "Atariko atalak" heading; the `front-matter/aurkibidea.qmd` guidance callout also appears there (it is meaningful mainly for the PDF).
4. Content authoring: students edit `chapters/01-*.qmd` … `08-*.qmd` and `metadata.tfg`; replace `{{< lipsum >}}` placeholders and remove guidance callouts for the final submission.
