// ==============================================================================
// QUARTO TEMPLATE PARTIAL: page.typ (replaces orange-book's version)
// ==============================================================================
// Base page geometry: A4 and the HEFA margins defined in `_quarto.yml`.
// Running headers/footers are switched on in `front-matter/aurkibidea.qmd`.
// ==============================================================================
#set page(
  paper: $if(papersize)$"$papersize$"$else$"a4"$endif$,
$if(margin)$
  margin: ($for(margin/pairs)$$margin.key$: $margin.value$,$endfor$),
$else$
  margin: 2.5cm,
$endif$
  numbering: none,
)
