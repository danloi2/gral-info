// ==============================================================================
// QUARTO TEMPLATE PARTIAL: typst-show.typ (replaces orange-book's version)
// ==============================================================================
// For `type: book` projects, Quarto (>= 1.9) renders Typst through its built-in
// "orange-book" template, which adds its own cover page, table of contents and
// chapter heading style, overriding `hefa-cover.typ` and `hefa-style.typ`.
//
// This partial (registered in `_quarto.yml` -> `template-partials`) replaces
// orange-book's and only sets document metadata, language, font and heading
// numbering. It deliberately emits NO cover and NO outline:
// - the cover is inserted by `front-matter/azala.qmd`;
// - the outline (Aurkibidea) by `front-matter/aurkibidea.qmd`.
// All visual styling lives in `templates/typst/hefa-style.typ`.
// ==============================================================================

#set document(
$if(title)$
  title: [$title$],
$endif$
$if(by-author)$
  author: ($for(by-author)$"$it.name.literal$",$endfor$),
$endif$
)

#set text(
$if(lang)$
  lang: "$lang$",
$endif$
$if(mainfont)$
  font: ("$mainfont$",),
$endif$
$if(fontsize)$
  size: $fontsize$,
$endif$
)

// Chapter and section numbering (e.g. "1.", "1.1.", "1.1.1.")
$if(section-numbering)$
#set heading(numbering: "$section-numbering$")
$endif$
