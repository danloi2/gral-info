// ==============================================================================
// HEFA - UPV/EHU STYLE RULES (Typst)
// ==============================================================================
// Injected before the document body through `include-before-body` in
// `_quarto.yml`, so every rule here applies to the whole PDF.
//
// Global set/show rules implementing:
// 1. The official layout guidelines of the Faculty of Education, Philosophy
//    and Anthropology (HEFA - UPV/EHU).
// 2. APA 7th edition rules for tables, figures, block quotes and footnotes.
//
// It also defines helpers used from the .qmd files: the colour palette,
// `#taula-oharra[...]` (table notes) and `#kutxa-nabarmena(...)` (boxes).
// ==============================================================================

// ------------------------------------------------------------------------------
// 1. BASE TYPOGRAPHY AND PARAGRAPHS
// ------------------------------------------------------------------------------
// - Font: EHUSans (UPV/EHU corporate typeface), loaded from `assets/fonts/`.
//   No fallback font is set: if EHUSans is missing, Typst warns and uses its default.
// - Size: 11pt (HEFA allows 11-12pt). These values override `fontsize` and
//   `mainfont` in `_quarto.yml`; keep both in sync.
// - Language: Basque ("eu") for correct hyphenation.
// - Line spacing: `leading: 1.05em` (extra space between lines).
// - Alignment: fully justified, no first-line indent.
#set text(font: "EHUSans", size: 11pt, lang: "eu")
#set par(justify: true, leading: 1.05em, first-line-indent: 0pt)
#set page(footer: none) // No footer on the front matter; headers/footers start in `front-matter/aurkibidea.qmd`

// ------------------------------------------------------------------------------
// 2. UPV/EHU CORPORATE COLOUR PALETTE (EHU BRAND MANUAL 2026)
// ------------------------------------------------------------------------------
// Main colours (pp. 50-52 of `docs/reference/guia-marca-ehu.pdf`):
#let uniberdea = rgb("#5FD790")       // Main corporate green (PANTONE 2412 C)
#let berde-leuna = rgb("#B0FBC1")     // Soft green: learning, reflection, clarity (PANTONE 351 C)
#let lurra = rgb("#EEECE9")           // Warm neutral, background for boxes (RGB 238, 236, 233)
#let egurra = rgb("#B1AB9F")          // Warm neutral, borders and rules (RGB 177, 171, 159)
#let haritz-zuria = rgb("#FFFFFF")    // Institutional white

// Secondary colours for figures and charts (pp. 53-56):
#let zerua = rgb("#7E8EFE")           // Sky blue: rigorous thinking, science, research
#let egunsentia = rgb("#FE8B66")      // Dawn: teamwork, community, collaboration
#let argia = rgb("#E4F568")           // Light: dynamism, innovation, creativity
#let behe-lainoa = rgb("#C6ACF5")     // Mist: sensitivity, balance, university life


// ------------------------------------------------------------------------------
// 3. HEADINGS
// ------------------------------------------------------------------------------
// All headings use EHUSans bold. Level-1 headings (chapters) get extra space
// above and a short UNIBERDEA rule below.
#show heading: set text(font: "EHUSans", weight: "bold")

// Level 1 (chapters)
// - Each chapter starts on an odd page. The `pagebreak` sits outside the
//   block because Typst does not allow page breaks inside containers.
// - `weak: true` avoids an extra blank page when a break already precedes it.
// - The number and body are drawn from `it.numbering` / `it.body` instead of
//   `#it`, so no other heading rule (e.g. from a book template) decorates it again.
//
// Defined as a function so `front-matter/azala.qmd` can apply it again after
// Quarto's own level-1 rule (see the note there).
#let hefa-chapter-heading(it) = {
  // Technical title of the book landing page (`index.qmd`): never shown in the PDF.
  if it.at("label", default: none) == <sec-atariko-atalak> { return }
  pagebreak(weak: true, to: "odd")
  block(width: 100%, breakable: false, above: 0pt, below: 0pt)[
    #v(1.4em)
    #text(size: 16pt)[
      #if it.numbering != none [#counter(heading).display(it.numbering)#h(0.4em)]#it.body
    ]
    #v(0.3em)
    #line(length: 3.5cm, stroke: 2pt + uniberdea)
    #v(0.5em)
  ]
}
#show heading.where(level: 1): hefa-chapter-heading

// Level 2 (sections)
#show heading.where(level: 2): it => {
  v(1.1em)
  it
  v(0.5em)
}

// Level 3 (subsections)
#show heading.where(level: 3): it => {
  v(0.9em)
  it
  v(0.4em)
}

// ------------------------------------------------------------------------------
// 4. BLOCK QUOTES (> 40 WORDS)
// ------------------------------------------------------------------------------
// HEFA guideline: single line spacing, 0.5 cm indent, no quotation marks and
// a font one point smaller (10pt).
// A vertical UNIBERDEA rule on the left is added as a visual cue.
#show quote: set text(size: 10pt)
#show quote: set par(leading: 0.65em, justify: true)
#show quote: it => pad(left: 0.5cm, right: 0cm)[
  #block(
    stroke: (left: 2pt + uniberdea),
    inset: (left: 0.8em, top: 0.2em, bottom: 0.2em)
  )[#it.body]
]

// ------------------------------------------------------------------------------
// 5. FOOTNOTES
// ------------------------------------------------------------------------------
// HEFA guideline: notes at the foot of the page, numbered in ascending order,
// same typeface as the body, single line spacing and justified.
#show footnote.entry: set par(leading: 0.65em, justify: true)
#show footnote.entry: set text(size: 9.5pt, font: "EHUSans")

// ------------------------------------------------------------------------------
// 6. FIGURE AND TABLE CAPTIONS (APA 7)
// ------------------------------------------------------------------------------
// - Caption above the element.
// - Continuous numbering: "1", "2", "3"...
// - Line 1: bold label ("Taula 1" / "Irudia 1").
// - Line 2: italic descriptive title.
#set figure.caption(position: top)
#set figure(numbering: "1")

#show figure.caption: it => {
  // Numbering pattern of the figure (default: "1")
  let num-pattern = if it.numbering != none { it.numbering } else { "1" }
  align(left)[
    #block(width: 100%, below: 0.8em)[
      // Line 1: bold label (`context` is required to read the counter)
      #text(weight: "bold", size: 10pt)[#it.supplement #context it.counter.display(num-pattern)] \
      #v(0.25em)
      // Line 2: italic title
      #text(style: "italic", size: 10pt)[#it.body]
    ]
  ]
}

// Images and diagrams wider than the text block are scaled down to fit it
#show image: it => layout(size => {
  let is-overflow = if type(it.width) == length {
    it.width > size.width
  } else {
    false
  }
  if is-overflow {
    // Too wide: redraw at 100% of the available width, keeping the aspect ratio
    box(width: size.width, image(it.source, width: 100%, height: auto))
  } else {
    it
  }
})


// ------------------------------------------------------------------------------
// 7. TABLES (APA 7)
// ------------------------------------------------------------------------------
// 1. No vertical lines.
// 2. Horizontal rules only: top (1pt), below the header (0.5pt) and bottom (1pt).
// 3. Stub column (column 0) left-aligned; header cells centred and bold.
// 4. 10pt text with comfortable cell padding.
#show figure.where(kind: table): set text(size: 10pt)
#show table.cell: set text(size: 10pt)
#show table.cell: set par(justify: false) // No justification in cells (avoids uneven word gaps)
#show table.cell.where(x: 0): set align(left)     // Stub column left-aligned
#show table.cell.where(y: 0): set align(center)   // Header cells centred
#show table.cell.where(y: 0): set text(weight: "bold") // Header text bold
#set table.hline(stroke: 0.5pt + black)
#set table(
  stroke: none,             // Remove all default grid lines
  fill: none,               // No cell background
  inset: (x: 8pt, y: 6pt),  // Cell padding
)

// Top and bottom 1pt rules framing the table
#show table: it => block(width: 100%)[
  #line(length: 100%, stroke: 1pt + black)
  #v(-0.6em)
  #it
  #v(-0.6em)
  #line(length: 100%, stroke: 1pt + black)
]

// ------------------------------------------------------------------------------
// 8. TABLE NOTES HELPER (APA 7)
// ------------------------------------------------------------------------------
// Adds a note below a table, in a raw Typst block right after the table:
//   #taula-oharra[Note text...]
// Renders "Oharra." in italics followed by the text, 9pt, left-aligned.
#let taula-oharra(gorputza) = block(width: 100%, inset: (top: 0.3em, bottom: 0.5em))[
  #align(left)[#text(size: 9pt, font: "EHUSans")[_Oharra._ #gorputza]]
]

// ------------------------------------------------------------------------------
// 9. LINKS AND CITATIONS
// ------------------------------------------------------------------------------
// Hyperlinks and linked citations in a muted blue.
#show link: set text(fill: rgb("#1a5fb4"))

// ------------------------------------------------------------------------------
// 10. HIGHLIGHT BOX HELPER (NOTES / SDG REFLECTION)
// ------------------------------------------------------------------------------
// Box for notices, definitions or the Sustainable Development Goals
// (JGH / ODS) reflection required by HEFA. `lurra` background, `uniberdea`
// left border. Usage:
//   #kutxa-nabarmena(titulua: [Title])[Body text...]
#let kutxa-nabarmena(titulua: none, gorputza) = block(
  width: 100%,
  fill: lurra,
  stroke: (left: 3pt + uniberdea),
  radius: (right: 4pt),
  inset: (x: 1.1em, y: 0.9em),
  outset: 0pt,
)[
  #if titulua != none [
    #text(weight: "bold", size: 10.5pt, fill: rgb("#222222"), font: "EHUSans")[#titulua]
    #v(0.35em)
  ]
  #text(size: 10pt, font: "EHUSans")[#gorputza]
]

