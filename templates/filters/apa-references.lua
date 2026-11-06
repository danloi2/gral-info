-- ==============================================================================
-- APA 7 REFERENCE LIST LAYOUT IN THE PDF (Typst only)
-- ==============================================================================
-- Pandoc writes each citeproc entry as a plain `#block[...] <ref-key>`, so the
-- PDF reference list had no hanging indent. This filter wraps the `{#refs}`
-- container (chapters/07-erreferentziak.qmd) in a Typst scope that applies the
-- APA 7 layout: 1.27 cm hanging indent, left-aligned (not justified).
-- HTML and DOCX already get it from the CSL / the "Bibliography" Word style.
-- ==============================================================================

if not quarto.doc.is_format("typst") then
  return {}
end

return {
  {
    Div = function(div)
      if div.identifier ~= "refs" then return nil end
      return {
        pandoc.RawBlock("typst", "#[\n#set par(hanging-indent: 1.27cm, justify: false, first-line-indent: 0pt)"),
        div,
        pandoc.RawBlock("typst", "]"),
      }
    end,
  },
}
