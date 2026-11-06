-- ==============================================================================
-- KEEP BOLD LEAD-INS WITH THE FOLLOWING BLOCK (PDF and DOCX)
-- ==============================================================================
-- The template uses paragraphs made of a single bold phrase as small
-- subheadings, e.g.
--
--   **Ikerketa kualitatiboetan**
--
--   ::: {.callout-note} ... :::
--
-- Neither Typst nor Word knows they belong to the next block, so they could be
-- left alone at the bottom of a page. This filter marks them:
--   - Typst (PDF): wrapped in `#block(sticky: true)[...]`, which keeps the
--     block on the same page as the next one.
--   - DOCX: custom style "KeepWithNext" (Body Text + keep with next), defined in
--     templates/docx/hefa-reference.docx.
-- HTML has no pages, so it is left untouched.
-- ==============================================================================

local is_typst = quarto.doc.is_format("typst")
local is_docx = quarto.doc.is_format("docx")

if not (is_typst or is_docx) then
  return {}
end

-- A paragraph whose only content is one Strong span (ignoring spaces)
local function is_bold_lead(p)
  local strong = nil
  for _, el in ipairs(p.content) do
    if el.t == "Strong" and strong == nil then
      strong = el
    elseif el.t ~= "Space" and el.t ~= "SoftBreak" then
      return false
    end
  end
  return strong ~= nil
end

return {
  {
    Para = function(p)
      if not is_bold_lead(p) then return nil end
      if is_typst then
        return {
          pandoc.RawBlock("typst", "#block(sticky: true)["),
          p,
          pandoc.RawBlock("typst", "]"),
        }
      end
      return pandoc.Div({ p }, pandoc.Attr("", {}, { ["custom-style"] = "KeepWithNext" }))
    end,
  },
}
