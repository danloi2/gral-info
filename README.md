# UPV/EHU · HEFA — Quarto + Typst template for the Undergraduate Thesis (GRAL / TFG)

[![Version](https://img.shields.io/badge/version-v1.1.0-5FD790?style=for-the-badge&logo=semver&logoColor=white)](https://github.com/danloi2/gral-info)
[![Quarto](https://img.shields.io/badge/Quarto-%3E%3D1.9-blue?style=for-the-badge&logo=quarto&logoColor=white)](https://quarto.org)
[![Typst](https://img.shields.io/badge/Typst-bundled%20with%20Quarto-239dad?style=for-the-badge&logo=typst&logoColor=white)](https://typst.app)
[![HEFA - UPV/EHU](https://img.shields.io/badge/HEFA-UPV%2FEHU-black?style=for-the-badge)](https://www.ehu.eus/hefa)
[![ORCID](https://img.shields.io/badge/ORCID-0000--0003--3842--7694-A6CE39?style=for-the-badge&logo=orcid&logoColor=white)](https://orcid.org/0000-0003-3842-7694)
[![Publish to GitHub Pages](https://github.com/danloi2/gral-info/actions/workflows/publish.yml/badge.svg)](https://github.com/danloi2/gral-info/actions/workflows/publish.yml)

> **Version:** `v1.1.0` (November 2026)  
> **Author:** Daniel Losada — [ORCID 0000-0003-3842-7694](https://orcid.org/0000-0003-3842-7694) (HEFA, UPV/EHU)  
> **License:** MIT  
> **Live example:** <https://danloi2.github.io/gral-info/> — web book with PDF and Word downloads

Academic template for writing and typesetting **undergraduate theses (TFG / GRAL — *Gradu Amaierako Lana*)** at the **Faculty of Education, Philosophy and Anthropology (HEFA)** of the University of the Basque Country / Euskal Herriko Unibertsitatea (UPV/EHU).

It is a **Quarto book** (`project: type: book`) built with **[Quarto](https://quarto.org/)** and the **[Typst](https://typst.app/)** typesetting engine: you write plain Markdown, and the template produces a print-quality PDF, a web book and a Word document, all following the HEFA guidelines, the EHU brand manual and APA 7. Every section includes a step-by-step **writing guide** (in Basque) explaining what it must contain.

The thesis content is in **Basque (Euskara)**; the trilingual abstract adds Spanish and English versions.

---

## Features

- **One source, three outputs:**
  - **PDF (Typst):** the official submission, `build/urtea-abizena-izena-eu.pdf`, with the HEFA cover page.
  - **HTML:** multi-page web book (`build/index.html`), one page per chapter, with sidebar navigation, search and white download icons (PDF / Word) at the bottom of the sidebar.
  - **DOCX:** a single Word file, `build/urtea-abizena-izena-eu.docx`, for supervisor review and track changes, **laid out like the PDF**: HEFA cover, front matter without running headers, table of contents after the abstracts, chapters on odd pages, mirrored headers with the chapter title, page numbers on the outer side, APA 7 captions and tables. When Word asks whether to update fields, answer **Yes** (or press F9) to build the table of contents and the headers.
- **EHU brand identity (2026 brand manual):** primary colour **UNIBERDEA (`#5FD790`)** and the full official palette (*Lurra, Egurra, Zerua, Egunsentia, Argia, Behe-lainoa*); corporate typeface **EHUSans** (OTF files in `assets/fonts/`), used by the PDF and served as a web font in the HTML book.
- **HEFA cover page** modelled on the official GRAL cover: institutional logo, title in small caps, UNIBERDEA rules, student and thesis data, faculty contact footer.
- **Single source of metadata:** title, subtitle, author, ID number, degree, supervisor, department, academic year and exam session are entered once in `_quarto.yml` and flow into the cover, running headers and appendices of every format.
- **Modular structure:** `index.qmd` is the landing page and gathers the unnumbered front matter; the eight chapters are listed in `_quarto.yml` → `book.chapters`.
- **Built-in writing guide (`.callout-note` boxes)** in every section and subsection:
  - **Edukia:** what the HEFA guidelines require in that section.
  - **Luzera orientagarria:** suggested length as a share of the whole thesis.
  - **Aditz-denborak (APA 7):** verb tenses to use.
  - **Galdera orientagarriak:** guiding questions.
  - **Adibideak:** sample academic sentences from education research.
  - **Aipu bibliografikoak:** whether citations are required, recommended or not expected.
- **Front matter:**
  - `front-matter/azala.qmd`: cover page (PDF and Word).
  - `front-matter/eskerrak.qmd`: acknowledgements.
  - `front-matter/laburpenak.qmd`: mandatory trilingual abstract (**Basque / Laburpena**, **Spanish / Resumen**, **English / Abstract**) with keywords from standard thesauri (UNESCO / ERIC).
  - `front-matter/aurkibidea.qmd`: table of contents (*Aurkibidea*); page numbering restarts here.
- **Running headers and footers (PDF and Word):**
  - **Even pages:** current chapter on the left, `Gradu Amaierako Lana (GRAL)` on the right; page number bottom left.
  - **Odd pages (chapter start):** `Gradu Amaierako Lana (GRAL)` on the left, author on the right; page number bottom right.
  - **Odd pages (other):** `Gradu Amaierako Lana (GRAL)` on the left, current chapter on the right.
  - Thin UNIBERDEA rule under the header.
- **APA 7th edition:**
  - **Tables:** caption above (bold number, italic title), horizontal rules only (1 pt top and bottom, 0.5 pt below the header), no vertical lines, left-aligned cells, table notes with `#taula-oharra[...]`.
  - **Figures and diagrams:** caption above, continuous numbering ("Irudia 1, 2, 3…" in the PDF and Word). Native **Mermaid** diagrams.
  - **Block quotes (> 40 words):** 0.5 cm indent, 10 pt, single spacing, UNIBERDEA side rule.
  - **References:** BibTeX (`bibliography/references.bib`) processed by Pandoc citeproc with the APA 7 CSL (`bibliography/apa.csl`), clickable citations and a hanging indent in the reference list.
- **Careful page breaks:** callout titles and one-line bold subheadings are never left alone at the bottom of a page.
- **Appendices (`chapters/08-eranskinak.qmd`):** generative AI use statement, ethics and data protection (informed consent, anonymity), and space for instruments, interview guides, timelines and analysis matrices.
- **Automatic publishing:** a GitHub Actions workflow renders all formats and publishes the web book on GitHub Pages.

---

## Repository structure

```text
├── _quarto.yml                  # Book configuration: metadata, chapters (book.chapters), formats
├── index.qmd                    # Landing page: includes the front-matter/ sections
├── README.md                    # This guide
├── AGENTS.md · HANDOFF.md       # Instructions and handoff notes for AI assistants and contributors
├── .github/workflows/
│   └── publish.yml              # Renders all formats and deploys build/ to GitHub Pages
├── front-matter/                # Unnumbered preliminary sections, included from index.qmd
│   ├── azala.qmd                # Cover page and the #prelim-heading helper
│   ├── eskerrak.qmd             # Acknowledgements
│   ├── laburpenak.qmd           # Laburpena, Resumen, Abstract + keywords
│   └── aurkibidea.qmd           # Table of contents and running headers/footers
├── chapters/                    # Numbered chapters (listed in book.chapters)
│   ├── 01-sarrera.qmd           # 1. Introduction
│   ├── 02-marko.qmd             # 2. Theoretical framework
│   ├── 03-metodo.qmd            # 3. Method
│   ├── 04-emaitzak.qmd          # 4. Results
│   ├── 05-eztabaida.qmd         # 5. Discussion
│   ├── 06-ondorioak.qmd         # 6. Conclusions
│   ├── 07-erreferentziak.qmd    # 7. References ({#refs} container)
│   └── 08-eranskinak.qmd        # 8. Appendices
├── templates/typst/             # PDF layout
│   ├── hefa-style.typ           # Typst rules: typography, headings, APA 7, boxes, EHU palette
│   ├── hefa-cover.typ           # HEFA cover page (reads metadata from _quarto.yml)
│   └── partials/                # Replace Quarto's orange-book template (DO NOT delete)
│       ├── typst-show.typ       #   minimal document setup, no automatic cover or TOC
│       ├── page.typ             #   A4 and HEFA margins
│       └── numbering.typ        #   continuous APA 7 numbering of figures and tables
├── templates/html/
│   ├── hefa.scss                # HTML theme: EHUSans, colours, sidebar, APA 7 captions and tables
│   └── caption-labels.html      # Makes caption labels bold (APA 7) in the web book
├── templates/docx/              # Word layout
│   ├── hefa-reference.docx      # Styles, page setup and headers (generated)
│   ├── build-reference-docx.py  # Generates the reference document (only when changing styles)
│   └── hefa-docx.lua            # Filter: cover, TOC, page breaks, APA captions and tables
├── templates/filters/           # Lua filters shared by PDF and Word
│   ├── keep-with-next.lua       # Keeps bold one-line subheadings (**Like this**) with the next block
│   └── apa-references.lua       # APA hanging indent in the PDF reference list
├── bibliography/
│   ├── references.bib           # BibTeX database
│   └── apa.csl                  # APA 7th edition citation style
├── assets/
│   ├── images/                  # Institutional logos and thesis images
│   └── fonts/                   # EHUSans and EHUSerif corporate fonts (OTF)
└── build/                       # Generated output: PDF, DOCX and HTML book (do not edit; git-ignored)
```

Official reference documents (HEFA GRAL guide, EHU brand manual, Word cover model) can be kept locally in `docs/reference/`; that folder is git-ignored and not published.

---

## Quick start

### 0. Get the template

Click **Use this template** / **Fork** on GitHub, or clone it:

```bash
git clone https://github.com/danloi2/gral-info.git
```

### 1. Enter your thesis data

Open `_quarto.yml` and edit the `metadata.tfg` section:

```yaml
metadata:
  tfg:
    titulua: &titulua "IRAKASLE-IDENTITATEAREN ERAIKUNTZA ETA METODOLOGIA BERRITZAILEAK LEHEN HEZKUNTZAN"
    azpititulua: &azpititulua "Hezkuntza proiektu berritzaile baten azterketa eta esku-hartze proposamena"
    egilea: &egilea "Ane Garcia Goikoetxea"
    nan: "12345678Z"
    gradua: "Lehen Hezkuntzako Gradua"
    zuzendaria: "Zuzendariaren Izena, dk."
    saila: "Didaktika eta Eskola Antolakuntza Saila"
    ikasturtea: "2026/2027"
    lan-mota: "Gradu Amaierako Lana (GRAL)"
    deialdia: "2026/2027 Ikasturtea - Ohiko deialdia (Ekaina)"
```

> **Edit once, used everywhere:** these values feed the cover page and running headers of the PDF and Word files. The title, subtitle and author are reused in the `book:` section through YAML anchors (`&titulua` → `*titulua`), so you never type them twice. Edit only the quoted text and keep the `&titulua`, `&azpititulua` and `&egilea` anchors.

#### Output file name

In a Quarto book the PDF and DOCX name is set **without extension** in `book:`:

```yaml
book:
  output-file: "urtea-abizena-izena-eu"   # → build/urtea-abizena-izena-eu.pdf and .docx
```

If you change it, update the two download links in `book.sidebar.footer` as well.

#### Adding, removing or reordering chapters

Chapters are listed in `_quarto.yml` (not in `index.qmd`):

```yaml
book:
  chapters:
    - index.qmd                     # landing page (front matter)
    - chapters/01-sarrera.qmd
    - chapters/02-marko.qmd
    # ...
```

Each chapter file must start with a single level-1 heading (`# SARRERA {#sec-sarrera}`). In the PDF and Word files it starts on an odd page, gets the short UNIBERDEA rule and appears in the running headers.

> **Do not delete** the heading `# Atariko atalak {#sec-atariko-atalak ...}` in `index.qmd`. Quarto needs one title per file; without it, it takes the first heading it finds ("Eskerrak") and prints it before the cover. The heading is hidden in the PDF and Word; in the web book it groups the front matter.

---

### 2. Writing with the built-in guide

Every chapter in `chapters/` is ready to edit and contains guidance boxes like this one:

```markdown
::: {.callout-note}
## Edukia: Sarrera

Ikerketaren aurkezpena, testuingurua eta justifikazioa...

**Luzera orientagarria:** Lan osoaren % 10–15 (% 12 inguru).
**Aditz-denborak (APA 7):** Oraina, nagusiki.
**Aipu bibliografikoak:** Gomendagarriak dira, eta normalean nahitaezkoak 1.1 eta 1.2 azpiataletan.
:::
```

#### Recommended workflow

1. **Read the guide:** check the requirements, guiding questions, verb tenses and suggested length before writing.
2. **Write your text:** use standard Markdown below the boxes, replacing the `{{< lipsum ... >}}` placeholder paragraphs.
3. **Final version:** before submitting, delete or comment out the `::: {.callout-note}` boxes so the document contains only your academic text.

---

### 3. Academic writing: citations, tables, figures and diagrams

#### Citations (APA 7)

Add your sources to `bibliography/references.bib` and cite them in the text:

- **Parenthetical:** `[@anderson2001]` → *(Anderson et al., 2001)*
- **Narrative:** `@carrington2016` → *Carrington (2016)*
- **Several works:** `[@ainscow2020; @booth2011]`
- Citations link to their entry in the reference list.
- **Only works cited in the text appear in `chapters/07-erreferentziak.qmd`** (APA rule). The template includes sample citations in chapters 1–3 (`@ainscow2020`, `@booth2011`, `@creswell2018`, `@hernandez2018`, `@braun2006`, `@onu2015`); replace them with your own.

#### APA 7 tables with notes

Write tables in plain Markdown and add a note with the Typst helper `#taula-oharra[...]`:

````markdown
| Fasea | Jarduera nagusiak | Denboralizazioa |
|:------|:------------------|:----------------|
| 1. Diagnostikoa | Ikasgelako behaketa eta elkarrizketak | Urria - Azaroa |
| 2. Diseinua | Esku-hartze didaktikoaren diseinua | Abendua - Urtarrila |
| 3. Garapena | Ikasgelako inplementazioa | Otsaila - Apirila |
| 4. Ebaluazioa | Datuen bilketa eta triangulazioa | Maiatza |

: Ikerketaren garapen-faseak eta denboralizazio orokorra. {#tbl-kronograma}

```{=typst}
#taula-oharra[Ikastetxeko zuzendaritzarekin eta irakasleekin adostutako behin-betiko egutegia.]
```
````

#### Figures

Give every figure a descriptive caption and a `#fig-...` label:

```markdown
![Esku-hartze didaktikoaren eredu pedagogikoa eta dimentsioak.](/assets/images/eredua.png){#fig-eredua}
```

Refer to it in the text with `@fig-eredua`. The caption is placed above the figure, as APA 7 requires.

#### Diagrams (Mermaid)

Quarto renders **Mermaid** diagrams directly:

````markdown
```{mermaid}
%%| label: fig-faseak
%%| fig-cap: "Ikerketaren fase metodologikoen sekuentziazioa eta fluxua."
%%| fig-width: 5.8
%%| fig-align: center

flowchart LR
  A[1. Diagnostikoa] --> B[2. Diseinua]
  B --> C[3. Garapena]
  C --> D[4. Ebaluazioa]

  style A fill:#EEECE9,stroke:#5FD790,stroke-width:1.5px
  style B fill:#EEECE9,stroke:#5FD790,stroke-width:1.5px
  style C fill:#B0FBC1,stroke:#5FD790,stroke-width:1.5px
  style D fill:#EEECE9,stroke:#5FD790,stroke-width:1.5px
```
````

#### Ethics and Sustainable Development Goals (JGH / ODS) boxes

Use a Quarto callout:

```markdown
::: {.callout-tip}
## Garapen Jasangarrirako Helburuekiko (JGH / ODS) lotura eta konpromiso etikoa

Lan honek Garapen Jasangarrirako Helburuekin (JGH) lotura zuzena du:
- **4. JGH: Kalitatezko hezkuntza.** Hezkuntza inklusiboa, bidezkoa eta kalitatezkoa bermatzea da lanaren ardatza...
:::
```

*(In the PDF you can also use the Typst helper `#kutxa-nabarmena(titulua: [...])[...]`.)*

---

### 4. Official UPV/EHU colour palette (2026 brand manual)

Recommended for your own figures, diagrams and charts:

| Colour | HEX | Meaning and suggested use |
|:---|:---|:---|
| **UNIBERDEA** | `#5FD790` | Main corporate green (identity, sustainability, future). |
| **BERDE LEUNA** | `#B0FBC1` | Learning, reflection, clarity. |
| **LURRA** | `#EEECE9` | Warm neutral background for boxes and highlights. |
| **EGURRA** | `#B1AB9F` | Warm neutral for borders and secondary rules. |
| **ZERUA** | `#7E8EFE` | Sky blue: scientific rigour, research, method. |
| **EGUNSENTIA** | `#FE8B66` | Dawn: teamwork, community, cooperation. |
| **ARGIA** | `#E4F568` | Light: innovation, dynamism, creativity. |
| **BEHE LAINOA** | `#C6ACF5` | Mist: sensitivity, balance, university life. |

---

## Building

Run the commands from the project root (do **not** render `index.qmd` on its own; the book needs the whole project):

```bash
# All formats (PDF + DOCX + HTML)
quarto render

# Official PDF only (build/urtea-abizena-izena-eu.pdf)
quarto render --to typst

# Word only (build/urtea-abizena-izena-eu.docx)
quarto render --to docx

# Web book only (build/index.html)
# Note: this empties build/, so the web download buttons return 404
# until you run `quarto render` again.
quarto render --to html

# Live web preview with automatic reload
quarto preview
```

---

## Publishing on GitHub Pages

`.github/workflows/publish.yml` runs on every push to `main`: GitHub Actions installs Quarto (and Chrome Headless Shell for the Mermaid diagrams), renders all three formats and publishes `build/` at **<https://danloi2.github.io/gral-info/>** — the web book with PDF and Word download buttons. You can also run it by hand: *Actions* → *Publish to GitHub Pages* → *Run workflow*.

To publish your own copy, enable **Settings → Pages → Source: GitHub Actions** in your repository and update `book.site-url` and `book.repo-url` in `_quarto.yml`.

---

## Contributing

- **Comments are always in English** in every project file (`_quarto.yml`, `.typ` files, raw Typst blocks and `<!-- -->` comments in `.qmd` files, Lua filters, scripts). The thesis content (text, headings, captions and guidance boxes) stays in Basque.
- Detailed instructions for AI assistants and contributors are in `AGENTS.md`; the current project state is in `HANDOFF.md`.

---

## Requirements and fonts

1. **Quarto CLI** 1.9 or later (tested with 1.10.20) — [quarto.org](https://quarto.org/).
2. **Typst:** bundled with Quarto; no separate installation needed.
3. **Corporate fonts:** the PDF and the web book use the EHUSans files in `assets/fonts/` directly (`font-paths: assets/fonts` in `_quarto.yml`), so nothing needs to be installed for them. **To see EHUSans in the Word file**, install the fonts on your computer:
   - **Linux:** copy the `.otf` files to `~/.local/share/fonts/` and run `fc-cache -f`.
   - **macOS:** open the `.otf` files with *Font Book* and install them.
   - **Windows:** select the `.otf` files, right-click and choose *Install for all users*.
4. **Python 3** only if you change the Word styles and need to regenerate `templates/docx/hefa-reference.docx` (`python3 templates/docx/build-reference-docx.py`).
