# AI Assistant & Contributor Guidelines (AGENTS.md)

**Project:** UPV/EHU · HEFA — Undergraduate Thesis / GRAL Template (Quarto + Typst)  
**Academic Institution:** Faculty of Education, Philosophy and Anthropology (HEFA), University of the Basque Country (UPV/EHU)  
**Document Type:** Undergraduate Thesis (TFG / GRAL - *Gradu Amaierako Lana*)  
**Primary Content Language:** Basque (Euskara)  
**Technical & Operational Guidelines Language:** English  

---

## 1. Project Domain & Purpose

This repository provides an institutional, publication-grade academic template for writing and compiling undergraduate monographs (TFG / GRAL) at UPV/EHU HEFA. It is configured as a multi-format Quarto project supporting:
- **Web (HTML Book):** Interactive, multi-page web document where each chapter is an independent HTML page with sidebar navigation and search.
- **Print / PDF (Typst):** Official monograph publication with custom cover, corporate typography (`EHUSans`), running headers/footers, and APA 7 layout.
- **Word (DOCX):** Single, cohesive `.docx` document for academic tutor review, annotations, and track-changes feedback.

---

## 2. Language & Localization Rules

- **Academic Monograph Content:** The thesis text itself is written strictly in **Basque (Euskara)** (`lang: eu`). All chapter titles, captions, callouts, and academic texts must use standard Basque academic register (Euskara Batua).
- **Trilingual Abstracts:** The abstract section (`front-matter/laburpenak.qmd`) must contain three versions:
  1. *Laburpena* (Basque)
  2. *Resumen* (Spanish)
  3. *Abstract* (English)
- **Technical Documentation & Rules:** Developer/agent instructions, git commits, skills, and handoff documents (`HANDOFF.md`, `AGENTS.md`, `SKILL.md`) are maintained in **English**.
- **Code & Configuration Comments:** Every comment in project files MUST be written in **English**: `_quarto.yml`, Typst files (`templates/typst/*.typ`, `templates/typst/partials/*.typ`), raw Typst blocks and HTML comments (`<!-- -->`) inside `.qmd` files, Lua filters, scripts and settings. This applies to new comments and to any existing comment you edit. Only the thesis content itself (text, captions, headings, callouts) stays in Basque.

---

## 3. Academic & Citation Standards (APA 7th Edition)

All agents modifying content or layout must enforce strict compliance with APA 7 standards:
1. **Captions on Top:**
   - Both Figure captions (`fig-cap-location: top`) and Table captions (`tbl-cap-location: top`) MUST be placed above the element.
2. **Scientific Tables:**
   - Three horizontal rules only (top border, bottom border, and header bottom border).
   - No vertical lines.
   - Table notes placed beneath the table (in Typst using `#taula-oharra[...]`).
3. **Bibliography & In-Text Citations:**
   - Centralized BibTeX database at `bibliography/references.bib`.
   - CSL style sheet at `bibliography/apa.csl`.
   - Always keep `citeproc: true` and `link-citations: true` enabled.
   - Use standard Pandoc citation keys (`[@citationKey]`, `@citationKey`).

---

## 4. Institutional Corporate Identity (UPV/EHU 2026 Brand Manual)

- **Corporate Primary Color:** `UNIBERDEA` (`#5FD790`, PANTONE 2412 C).
- **Secondary Palette:**
  - *Berde-leuna* (`#B0FBC1`)
  - *Lurra* (`#EEECE9`)
  - *Egurra* (`#B1AB9F`)
  - *Zerua* (`#7E8EFE`)
  - *Egunsentia* (`#FE8B66`)
  - *Argia* (`#E4F568`)
- **Typography:** Corporate font `EHUSans` (OpenType files provided in `assets/fonts/`).

---

## 5. Architectural Integrity & Best Practices

1. **Metadata Ingestion (`_quarto.yml`):**
   - Personal and administrative student metadata is stored under `metadata.tfg` in `_quarto.yml`.
   - Do NOT hardcode student names, thesis titles, or dates inside `templates/typst/hefa-cover.typ` or chapter files; they are dynamically ingested via `yaml("_quarto.yml")`.
2. **Modular Chapter Structure:**
   - Do NOT combine chapter files into a single huge file.
   - Keep each chapter isolated in `chapters/0X-*.qmd`; unnumbered preliminaries live in `front-matter/`.
   - Folder layout: `front-matter/`, `chapters/`, `templates/typst/` (+ `partials/`), `bibliography/`, `assets/images/`, `assets/fonts/`, `docs/reference/` (official guides, not rendered), `build/` (generated, git-ignored). Folder names are English; content file names stay in Basque.
   - In Quarto Book mode, chapters are registered in `_quarto.yml` under `book.chapters`.
   - `index.qmd` serves as the book's landing page hosting ONLY the preliminary sections (`front-matter/azala.qmd`, `front-matter/eskerrak.qmd`, `front-matter/laburpenak.qmd`, `front-matter/aurkibidea.qmd`) via `{{< include >}}`. Never include numbered chapters from `index.qmd`.
   - Every chapter file must start with exactly one level-1 heading (`# TITLE {#sec-id}`). Quarto Book turns the first heading of each file into the chapter title.
   - `index.qmd` keeps the technical heading `# Atariko atalak {#sec-atariko-atalak .unnumbered .unlisted}`. Without it Quarto promotes the first heading it finds ("Eskerrak") and places it *before* the cover page. It is hidden in Typst by a label check in `hefa-style.typ`; if you rename the label, update both places.
   - Title / subtitle / author are defined once in `metadata.tfg` with YAML anchors (`&titulua`, `&azpititulua`, `&egilea`) and aliased in `book:`. Keep the anchors.
   - Output file base name is set in `book.output-file` (no extension). Do NOT set `output-file` under `format.typst` / `format.docx`; book projects ignore it.
3. **Typst Book Template (orange-book override) — CRITICAL:**
   - Since Quarto 1.9, `type: book` + Typst automatically applies Quarto's built-in **orange-book** template, which injects its own cover page, outline and chapter heading styling, overriding `hefa-cover.typ` and `hefa-style.typ`.
   - This is neutralised by `format.typst.template-partials` in `_quarto.yml`, pointing to `templates/typst/partials/typst-show.typ`, `page.typ` and `numbering.typ`. Never remove these partials or the `template-partials` key.
   - `typst-show.typ` must NOT emit a title block, cover or `#outline`: the cover comes from `front-matter/azala.qmd` and the outline from `front-matter/aurkibidea.qmd`. `toc: false` stays set for Typst.
   - All visual styling of headings lives in `templates/typst/hefa-style.typ`. The level-1 show rule calls `pagebreak(weak: true, to: "odd")` *outside* the `block` (Typst forbids page breaks inside containers), so chapters start on odd pages without explicit breaks in the `.qmd` files.
   - To debug, render with `quarto render --to typst -M keep-typ:true` and inspect the generated `index.typ` at the project root (delete it afterwards).
4. **Image Paths:**
   - Use root-relative paths like `/assets/images/filename.png` or ensure relative paths resolve cleanly across both the root landing page and subfolder chapter files.
5. **HTML Theme (`templates/html/hefa.scss`):**
   - Layered on Bootstrap `cosmo`. Sets the EHU palette, EHUSans web fonts, the UNIBERDEA docked sidebar with the HEFA logo (`assets/images/hefa-logo-positive.svg`, official positive version on its white background), APA 7 captions and tables, and the page footer (`book.page-footer`).
   - `@font-face` URLs are relative to the project root (`assets/fonts/...`); Quarto copies the fonts next to the compiled CSS. Do not add `project.resources` for fonts; an unanchored glob there also matches nested folders such as `tmp/`.
   - Text links use `#078743` instead of UNIBERDEA, which is too light on white (WCAG contrast).
   - APA captions in HTML need both `format.html.crossref.title-delim: "<br>"` and `templates/html/caption-labels.html`.
6. **Figure/Table Numbering:**
   - PDF and DOCX: continuous ("Taula 1, 2, 3"). Top-level `crossref.chapters: false` handles DOCX. For the PDF, Quarto injects a level-1 heading rule that resets float counters at every chapter; `front-matter/azala.qmd` re-applies `hefa-chapter-heading` at the top of the body so Quarto's reset never runs. Keep that line first.
   - HTML: per chapter ("Taula 3.1", `format.html.crossref.chapters: true`), because each chapter is a separate page and continuous numbering is not possible.
7. **HTML Download Buttons:**
   - Quarto's `book.downloads` only renders a small dropdown icon next to the sidebar title. Icon-only white buttons (label as `title`/`aria-label`) are added in `book.sidebar.footer` (`_quarto.yml`) and styled in `templates/html/hefa.scss`.
   - Their hrefs hardcode the file names: keep them in sync with `book.output-file`.
   - `quarto render --to html` wipes `build/` and deletes the PDF/DOCX, so the buttons return 404. Use `quarto render` (all formats) before publishing or checking downloads.
8. **DOCX Layout (mirrors the PDF):**
   - `templates/docx/hefa-reference.docx` holds styles, A4 page, mirrored running headers (STYLEREF chapter; DOCPROPERTY `hefa-lan-mota` / `hefa-egilea` on chapter-opening pages) and outer page numbers. It is generated by `templates/docx/build-reference-docx.py` (stdlib only); edit the script, never the .docx by hand, and re-run it.
   - `templates/docx/hefa-docx.lua` (`at: post-render`, DOCX only) removes Pandoc's title block, builds the cover from `metadata.tfg` (placeholder `::: {.hefa-docx-cover}` in `front-matter/azala.qmd`), inserts the Word TOC at `::: {.hefa-docx-toc}` (`front-matter/aurkibidea.qmd`), turns raw-Typst `#pagebreak(to: "odd")` into odd-page section breaks (front matter: no header) and opens one odd-page section per chapter (TOC section restarts numbering at 1), styles `{.prelim}` headings, APA captions and `HefaTable` for tables with a header row.
   - Callouts (Quarto draws them as 2-row raw OpenXML tables): the title paragraph gets the `CalloutTitle` style (keepNext) and the filter strips Quarto's `<w:cantSplit/>`, so the title always stays with the first lines of the body and long bodies flow onto the next page instead of leaving the title alone.
   - Keep `format.docx.toc: false`; Pandoc's TOC would land before the cover.
   - Section-break `r:id`s (`rIdHdrOdd`, `rIdHdrEven`, `rIdHdrFirst`, `rIdFtrOdd`, `rIdFtrEven`) must match the reference document.
   - Visual check without Word: convert with LibreOffice using a fontconfig that includes `assets/fonts/` and the PDF export option `IsSkipEmptyPages=false` (otherwise odd-page blanks are dropped). LibreOffice does not refresh the TOC/DOCPROPERTY fields; Word does when the user accepts "update fields".
9. **Shared Filters (`templates/filters/`, top-level `filters:` in `_quarto.yml`):**
   - `keep-with-next.lua`: paragraphs made only of bold text (`**Like this**`, used as small subheadings) become `#block(sticky: true)` in Typst and the `KeepWithNext` style in DOCX, so they never stay alone at a page bottom. In the PDF, callouts themselves are unbreakable blocks (Quarto default).
   - `apa-references.lua`: wraps `::: {#refs}` in a Typst scope with a 1.27 cm hanging indent and no justification (APA 7). HTML/DOCX get it from the CSL and the `Bibliography` Word style.
   - Only cited works are listed in the references chapter; keep at least the sample citations so the list is not empty in the template.
10. **Mermaid & Diagram Rendering:**
   - Mermaid diagrams render client-side in HTML via Mermaid.js.
   - For Typst and DOCX, Quarto requires Chrome headless shell. Ensure appropriate sandbox execution permissions when building diagrams.

---

## 6. Build Commands Reference

Always verify changes by compiling the affected formats from the project root (never `quarto render index.qmd` alone). Outputs go to `build/`: `urtea-abizena-izena-eu.pdf`, `urtea-abizena-izena-eu.docx`, and the HTML book (`index.html`, `chapters/*.html`).

```bash
# Compile HTML Web Book
quarto render --to html

# Compile Word DOCX
quarto render --to docx

# Compile Typst PDF
quarto render --to typst

# Compile all formats simultaneously
quarto render
```
