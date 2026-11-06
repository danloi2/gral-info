// ==============================================================================
// OFFICIAL COVER PAGE: HEFA - UPV/EHU UNDERGRADUATE THESIS (GRAL)
// ==============================================================================
// Builds the standard HEFA cover page (model: `docs/reference/gral-portada.docx`).
// Inserted by `front-matter/azala.qmd` with `#include`.
//
// Do NOT type the student's data here: it is read from `metadata.tfg` in
// `_quarto.yml`. The defaults below are only used if a key is missing.
// ==============================================================================

// ------------------------------------------------------------------------------
// 1. METADATA
// ------------------------------------------------------------------------------
// Read `_quarto.yml` with Typst's `yaml()` (path relative to this file).
#let config = yaml("../../_quarto.yml")

// Look for the data under `metadata.tfg`, or under a top-level `tfg` key
#let tfg = if "metadata" in config and "tfg" in config.metadata {
  config.metadata.tfg
} else if "tfg" in config {
  config.tfg
} else {
  (:) // Empty dictionary: every field falls back to its default
}

// Cover fields, each with a fallback value
#let titulua = tfg.at("titulua", default: "LANAREN IZENBURUA")
#let azpititulua = tfg.at("azpititulua", default: "Laburra, esanguratsua, zehatza, bereizgarria,erakargarria, argia, garrantzia, interesa, atentzioa")
#let egilea = tfg.at("egilea", default: "Izena Abizena1 Abizena2")
#let nan = tfg.at("nan", default: "12345678Z")
#let gradua = tfg.at("gradua", default: "Lehen Hezkuntzako Gradua")
#let zuzendaria = tfg.at("zuzendaria", default: "Daniel Losada Iglesias, dk.")
#let saila = tfg.at("saila", default: "Didaktika eta Eskola Antolakuntza Saila")
#let deialdia = tfg.at("deialdia", default: "2026/2027 Ikasturtea - Ohiko deialdia (Ekaina)")

// Fake small caps for the title (EHUSans has no real small caps): lowercase
// letters are drawn as smaller uppercase. An ALL-CAPS title is first turned
// into Title Case so the effect is visible.
#let versalitas(txt) = {
  let raw-str = str(txt)
  let has-lower = raw-str.contains(regex("[a-zà-ÿá-úñ]"))
  let processed-str = if not has-lower {
    raw-str.split(" ").map(w => {
      if w.len() > 1 {
        upper(w.first()) + lower(w.slice(1))
      } else {
        w
      }
    }).join(" ")
  } else {
    raw-str
  }
  
  let res = ()
  for ch in processed-str {
    if ch.contains(regex("[a-zà-ÿá-úñ]")) {
      res.push(text(0.76em, tracking: 0.03em)[#upper(ch)])
    } else {
      res.push(ch)
    }
  }
  res.join()
}

// ------------------------------------------------------------------------------
// 2. COVER PAGE GEOMETRY
// ------------------------------------------------------------------------------
// Own margins (top/bottom 2.5 cm, left/right 3 cm), no running header, and a
// footer with the HEFA faculty contact details.
#page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 3cm),
  header: none,
  footer: align(center)[
    #text(size: 8pt, fill: rgb("#555555"), font: "EHUSans")[
      Eraikin II, Oñati Plaza, 3, 20018 Donostia - San Sebastián #h(0.8em)·#h(0.8em) hefa.idazkaritza2\@ehu.eus #h(0.8em)·#h(0.8em) Tel: 943 01 7041 - 943 01 8456
    ]
  ]
)[
  // ----------------------------------------------------------------------------
  // 3. INSTITUTIONAL LOGO
  // ----------------------------------------------------------------------------
  #v(0.2cm)
  #align(center)[
    #image("../../assets/images/portada-logo.jpeg", width: 90%)
  ]

  #v(2.2cm)

  // ----------------------------------------------------------------------------
  // 4. WORK TYPE AND TITLE
  // ----------------------------------------------------------------------------
  #align(center)[
    // Work type label
    #text(size: 11pt, tracking: 0.12em)[
      #text(weight: "bold")[GRADU AMAIERAKO LANA]
    ]
    
    // Decorative UNIBERDEA rule
    #v(0.6cm)
    #line(length: 4.5cm, stroke: 2pt + rgb("#5FD790"))
    #v(0.6cm)

    // Title: EHUSans bold, fake small caps
    #text(size: 19pt, weight: "bold", font: "EHUSans")[
      #versalitas(titulua)
    ]
    
    // Subtitle: italic, dark grey
    #v(0.4cm)
    #text(size: 12pt, style: "italic", fill: rgb("#333333"))[
      #azpititulua
    ]
  ]

  // Flexible space (1fr) pushes the data block to the bottom of the page
  #v(1fr)

  // ----------------------------------------------------------------------------
  // 5. STUDENT AND THESIS DATA
  // ----------------------------------------------------------------------------
  // Two-column grid: Basque labels and values from `metadata.tfg`
  #align(left)[
    #line(length: 100%, stroke: 1.5pt + rgb("#5FD790"))
    #v(0.6em)
    #grid(
      columns: (auto, 1fr),
      row-gutter: 1.1em,
      column-gutter: 1.5em,
      [*EGILEA:*], [#egilea],
      [*NAN:*], [#nan],
      [*GRADUA:*], [#gradua],
      [*ZUZENDARIA:*], [#zuzendaria],
      [*SAILA:*], [#saila],
      [*DEIALDIA – URTEA:*], [#deialdia]
    )
    #v(0.6em)
    #line(length: 100%, stroke: 1.5pt + rgb("#5FD790"))
  ]
  #v(0.8cm)
]
