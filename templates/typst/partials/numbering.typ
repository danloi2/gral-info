// ==============================================================================
// QUARTO TEMPLATE PARTIAL: numbering.typ (replaces orange-book's version)
// ==============================================================================
// APA 7: figures, tables and equations are numbered continuously
// ("1", "2", "3"...) with no chapter prefix.
// ==============================================================================
#let equation-numbering = "(1)"
#let callout-numbering = "1"
#let subfloat-numbering(n-super, subfloat-idx) = {
  numbering("1a", n-super, subfloat-idx)
}

#let theorem-inherited-levels = 0
#let theorem-numbering(loc) = "1.1"
#let theorem-render(prefix: none, title: "", full-title: auto, body) = {
  if full-title != "" and full-title != auto and full-title != none {
    strong[#full-title.]
    h(0.5em)
  }
  body
}
