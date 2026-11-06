-- ==============================================================================
-- HEFA DOCX FILTER (Word output only)
-- ==============================================================================
-- Makes the Word version follow the Typst PDF layout. Works together with the
-- styles in `templates/docx/hefa-reference.docx` (see build-reference-docx.py).
-- Registered in `_quarto.yml` -> format.docx.filters with `at: post-render`, so
-- it runs after Quarto has built captions and cross-references.
--
--  1. Removes Pandoc's default title block (title/subtitle/author).
--  2. Replaces `::: {.hefa-docx-cover}` with the HEFA cover page, built from
--     `metadata.tfg` in `_quarto.yml` (same data as `hefa-cover.typ`).
--  3. Replaces `::: {.hefa-docx-toc}` with a section break (front matter has no
--     running header) and a Word table of contents, so the TOC sits after the
--     abstracts as in the PDF.
--  4. Turns the PDF page breaks (`#pagebreak` raw Typst blocks) into Word page
--     breaks.
--  5. Front-matter titles (`## Title {.prelim}`) get the chapter look without
--     being numbered or listed; every chapter title gets the short green rule.
--  6. APA 7 captions: bold label ("Taula 1") and italic title on the next line.
--  7. Data tables (tables with a header row) use the APA "HefaTable" style;
--     figure layouts and callouts keep the plain "Table" style.
--  8. Callout titles use the "CalloutTitle" style (keep with next), so a
--     callout's title row never stays alone at the bottom of a page; the body
--     row may break across pages (as in the PDF), so a long callout does not
--     leave its title alone on an otherwise empty page.
-- ==============================================================================

if not quarto.doc.is_format("docx") then
  return {}
end

local LANDING_TITLE_ID = "sec-atariko-atalak"   -- hidden landing-page title (index.qmd)
local COVER_LOGO = "assets/images/portada-logo.jpeg"
local COVER_FOOTER = "Eraikin II, Oñati Plaza, 3, 20018 Donostia - San Sebastián  ·  "
  .. "hefa.idazkaritza2@ehu.eus  ·  Tel: 943 01 7041 - 943 01 8456"

-- ------------------------------------------------------------------------------
-- OpenXML helpers
-- ------------------------------------------------------------------------------
local function esc(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"))
end

local function run(text, rpr)
  return '<w:r>' .. (rpr and ('<w:rPr>' .. rpr .. '</w:rPr>') or '')
    .. '<w:t xml:space="preserve">' .. esc(text) .. '</w:t></w:r>'
end

local function para(style, runs)
  return '<w:p><w:pPr><w:pStyle w:val="' .. style .. '"/></w:pPr>' .. (runs or '') .. '</w:p>'
end

local function raw(xml)
  return pandoc.RawBlock("openxml", xml)
end

local PAGE_BREAK = '<w:p><w:r><w:br w:type="page"/></w:r></w:p>'

-- Paragraph that CLOSES the current section; its <w:sectPr> describes the
-- section that ends here (OOXML rule). Every section starts on an odd page
-- (`oddPage`), like `pagebreak(to: "odd")` in the PDF.
--   headers: the closed section shows the running headers/footers
--            (relationship IDs defined in hefa-reference.docx)
--   restart: the closed section restarts page numbering at 1
local function section_break(headers, restart)
  local refs = ""
  if headers then
    -- "first" header (work type | author) on the opening page, as in the PDF
    refs = '<w:headerReference w:type="default" r:id="rIdHdrOdd"/>'
      .. '<w:headerReference w:type="even" r:id="rIdHdrEven"/>'
      .. '<w:headerReference w:type="first" r:id="rIdHdrFirst"/>'
      .. '<w:footerReference w:type="default" r:id="rIdFtrOdd"/>'
      .. '<w:footerReference w:type="even" r:id="rIdFtrEven"/>'
      .. '<w:footerReference w:type="first" r:id="rIdFtrOdd"/>'
  end
  return '<w:p><w:pPr><w:sectPr>' .. refs
    .. '<w:type w:val="oddPage"/>'
    .. '<w:pgSz w:w="11906" w:h="16838"/>'
    .. '<w:pgMar w:top="1417" w:right="1417" w:bottom="1417" w:left="1417" w:header="709" w:footer="709" w:gutter="0"/>'
    .. (restart and '<w:pgNumType w:start="1"/>' or '')
    .. '<w:cols w:space="708"/>' .. (headers and '<w:titlePg/>' or '')
    .. '</w:sectPr></w:pPr></w:p>'
end

local GREEN_RULE = para("HefaRule")

-- ------------------------------------------------------------------------------
-- Metadata
-- ------------------------------------------------------------------------------
local tfg = {}

local function meta_str(key, default)
  local v = tfg[key]
  if v == nil then return default end
  return pandoc.utils.stringify(v)
end

-- Same rule as `versalitas()` in hefa-cover.typ: an ALL-CAPS title is turned
-- into Title Case first, so Word's small caps are visible.
local function cover_title_text(title)
  if title:match("%l") or pandoc.text.lower(title) == title then
    return title
  end
  local words = {}
  for w in title:gmatch("%S+") do
    local first = pandoc.text.sub(w, 1, 1)
    local rest = pandoc.text.sub(w, 2)
    table.insert(words, first .. pandoc.text.lower(rest))
  end
  return table.concat(words, " ")
end

-- ------------------------------------------------------------------------------
-- 2. Cover page
-- ------------------------------------------------------------------------------
local function cover_blocks()
  local blocks = pandoc.List()
  local logo = pandoc.Image({}, COVER_LOGO, "", pandoc.Attr("", {}, { width = "90%" }))
  blocks:insert(pandoc.Div(pandoc.Para({ logo }), pandoc.Attr("", {}, { ["custom-style"] = "CoverLogo" })))

  local xml = para("CoverLabel", run("GRADU AMAIERAKO LANA"))
    .. para("CoverRuleShort")
    .. para("CoverTitle", run(cover_title_text(meta_str("titulua", "LANAREN IZENBURUA"))))
    .. para("CoverSubtitle", run(meta_str("azpititulua", "")))

  local rows = {
    { "EGILEA:", meta_str("egilea", "") },
    { "NAN:", meta_str("nan", "") },
    { "GRADUA:", meta_str("gradua", "") },
    { "ZUZENDARIA:", meta_str("zuzendaria", "") },
    { "SAILA:", meta_str("saila", "") },
    { "DEIALDIA – URTEA:", meta_str("deialdia", "") },
  }
  for i, row in ipairs(rows) do
    local style = (i == 1 and "CoverDataFirst") or (i == #rows and "CoverDataLast") or "CoverData"
    xml = xml .. para(style, run(row[1], "<w:b/>") .. '<w:r><w:tab/></w:r>' .. run(row[2]))
  end
  xml = xml .. para("CoverFooter", run(COVER_FOOTER))
  blocks:insert(raw(xml))
  return blocks
end

-- ------------------------------------------------------------------------------
-- 3. Table of contents (starts the main-matter section)
-- ------------------------------------------------------------------------------
local function toc_blocks()
  -- The front matter was already closed by the odd-page break before
  -- `aurkibidea.qmd`, so the TOC opens the first main-matter section.
  local field = '<w:p><w:pPr><w:pStyle w:val="TOC1"/></w:pPr>'
    .. '<w:r><w:fldChar w:fldCharType="begin" w:dirty="true"/></w:r>'
    .. '<w:r><w:instrText xml:space="preserve"> TOC \\o "1-3" \\h \\z \\u </w:instrText></w:r>'
    .. '<w:r><w:fldChar w:fldCharType="separate"/></w:r>'
    .. run('Aurkibidea eguneratzeko: eskuineko botoia → "Eguneratu eremua" (F9).')
    .. '<w:r><w:fldChar w:fldCharType="end"/></w:r></w:p>'
  return { raw(para("TOCHeading", run("Aurkibidea")) .. GREEN_RULE .. field) }
end

-- ------------------------------------------------------------------------------
-- 6. APA 7 captions
-- ------------------------------------------------------------------------------
-- Quarto emits captions as: RawInline(openxml pPr with *Caption style),
-- Str "Taula", Str nbsp, Str "1:", Space, title...  ->  **Taula 1** ↵ *title*
local function apa_caption(p)
  local first = p.content[1]
  if not (first and first.t == "RawInline" and first.format == "openxml"
          and first.text:match('Caption"')) then
    return nil
  end
  local label, title, found = pandoc.List(), pandoc.List(), false
  for i = 2, #p.content do
    local el = p.content[i]
    if not found then
      if el.t == "Str" and el.text:match(":$") then
        local text = el.text:gsub(":$", "")
        if text ~= "" then label:insert(pandoc.Str(text)) end
        found = true
      else
        label:insert(el)
      end
    elseif not (#title == 0 and el.t == "Space") then
      title:insert(el)
    end
  end
  if not found then return nil end
  return pandoc.Para({ first, pandoc.Strong(label), pandoc.LineBreak(), pandoc.Emph(title) })
end

-- ------------------------------------------------------------------------------
-- 8. Callout titles
-- ------------------------------------------------------------------------------
-- Quarto emits the title row of a callout as: RawInline(openxml pPr with
-- textAlignment), Image(icon from Quarto's formats/docx/), title text...
-- Pandoc already writes a <w:pPr>, so the raw one would be a duplicate: drop
-- it and let the CalloutTitle style carry spacing, alignment and keepNext.
local function callout_title(p)
  local first, second = p.content[1], p.content[2]
  if not (first and first.t == "RawInline" and first.format == "openxml"
          and first.text:match("textAlignment")
          and second and second.t == "Image" and second.src:match("formats/docx/")) then
    return nil
  end
  local inlines = pandoc.List(p.content)
  inlines:remove(1)
  return pandoc.Div({ pandoc.Para(inlines) }, pandoc.Attr("", {}, { ["custom-style"] = "CalloutTitle" }))
end

-- ------------------------------------------------------------------------------
-- Main walk
-- ------------------------------------------------------------------------------
-- Section state while walking the document
local in_main = false          -- true once the TOC (main matter) has started
local first_chapter = true     -- the first chapter closes the TOC section

local function transform(blocks)
  local out = pandoc.List()
  for _, b in ipairs(blocks) do
    if b.t == "Div" and b.classes:includes("hefa-docx-cover") then
      out:extend(cover_blocks())
    elseif b.t == "Div" and b.classes:includes("hefa-docx-toc") then
      in_main = true
      out:extend(toc_blocks())
    elseif b.t == "RawBlock" and b.format == "typst" then
      -- 4. Keep only the page breaks of raw Typst blocks. `to: "odd"` breaks
      -- close a front-matter section (no running header); plain ones are
      -- ordinary page breaks (Laburpena -> Resumen -> Abstract).
      if b.text:match('#pagebreak%(to: "odd"%)') and not in_main then
        out:insert(raw(section_break(false, false)))
      elseif b.text:match("#pagebreak") then
        out:insert(raw(PAGE_BREAK))
      end
    elseif b.t == "Header" and b.identifier == LANDING_TITLE_ID then
      -- 1b. Hidden landing-page title: drop it
    elseif b.t == "Header" and b.classes:includes("prelim") then
      -- 5. Front-matter title
      out:insert(raw(para("PrelimHeading", run(pandoc.utils.stringify(b.content))) .. GREEN_RULE))
    elseif b.t == "Header" and b.level == 1 then
      -- Each chapter opens an odd-page section with running headers. The
      -- first one closes the TOC section, where page numbering restarts at 1.
      out:insert(raw(section_break(true, first_chapter)))
      first_chapter = false
      out:insert(b)
      out:insert(raw(GREEN_RULE))
    elseif b.t == "RawBlock" and b.format == "openxml" and b.text:match("<w:cantSplit/>") then
      -- 8b. Quarto's callout tables forbid row splitting; allow it
      out:insert(raw((b.text:gsub("<w:cantSplit/>", ""))))
    elseif b.t == "Div" then
      b.content = transform(b.content)
      out:insert(b)
    else
      out:insert(b)
    end
  end
  return out
end

function Pandoc(doc)
  tfg = doc.meta.tfg or {}
  -- 1. No Pandoc title block: the HEFA cover replaces it
  doc.meta.title = nil
  doc.meta.subtitle = nil
  doc.meta.author = nil
  doc.meta.date = nil
  -- Custom document properties read by the running headers (DOCPROPERTY
  -- fields in hefa-reference.docx)
  doc.meta["hefa-egilea"] = pandoc.MetaString(meta_str("egilea", ""))
  doc.meta["hefa-lan-mota"] = pandoc.MetaString(meta_str("lan-mota", "Gradu Amaierako Lana (GRAL)"))

  doc.blocks = transform(doc.blocks)
  doc = doc:walk({
    Para = function(p) return apa_caption(p) or callout_title(p) end,
    Table = function(t)
      -- 7. APA style only for real data tables
      if #t.head.rows > 0 then
        t.attr.attributes["custom-style"] = "HefaTable"
        return t
      end
    end,
  })
  return doc
end
