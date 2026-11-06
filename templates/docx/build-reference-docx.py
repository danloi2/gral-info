#!/usr/bin/env python3
# ==============================================================================
# BUILD THE HEFA WORD TEMPLATE (templates/docx/hefa-reference.docx)
# ==============================================================================
# Pandoc formats DOCX output with the styles, page setup, headers and footers
# of a "reference document". This script generates that document so the Word
# version matches the Typst PDF (templates/typst/hefa-style.typ):
#
#   - A4, 2.5 cm margins; EHUSans 11 pt, justified, ~1.5 line spacing.
#   - Chapter headings (Heading 1) on a new page, 16 pt bold.
#   - Running headers: work type + current chapter (STYLEREF field), thin
#     UNIBERDEA rule; mirrored on even/odd pages; on the first page of each
#     chapter: work type + author. Page number on the outer side.
#     Work type and author come from DOCPROPERTY fields that hefa-docx.lua
#     fills from `metadata.tfg`, so this file never needs the student's data.
#   - APA 7 table style "HefaTable" (horizontal rules only), captions, block
#     quotes, footnotes, table of contents levels and the cover page styles
#     used by templates/docx/hefa-docx.lua.
#
# Only the Python standard library is used. The generated .docx is committed,
# so students never need to run this. Re-run it after changing a style here:
#
#   python3 templates/docx/build-reference-docx.py
# ==============================================================================

import pathlib
import re
import zipfile
from xml.sax.saxutils import escape

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent.parent
OUT = HERE / "hefa-reference.docx"

# ------------------------------------------------------------------------------
# Design tokens (keep in sync with templates/typst/hefa-style.typ)
# ------------------------------------------------------------------------------
FONT = "EHUSans"
UNIBERDEA = "5FD790"
GREY = "555555"
LINK = "1A5FB4"

PAGE_W, PAGE_H = 11906, 16838          # A4 in twips (1 cm = 567 twips)
MARGIN = 1417                          # 2.5 cm
TEXT_W = PAGE_W - 2 * MARGIN           # 9072 twips = 16 cm
RULE_W = 1984                          # 3.5 cm green rule under chapter titles


# ------------------------------------------------------------------------------
# styles.xml
# ------------------------------------------------------------------------------
def pstyle(sid, name, based="Normal", nxt=None, ppr="", rpr="", extra=""):
    nxt_xml = f'<w:next w:val="{nxt}"/>' if nxt else ""
    based_xml = f'<w:basedOn w:val="{based}"/>' if based else ""
    return (f'<w:style w:type="paragraph" w:customStyle="1" w:styleId="{sid}">'
            f'<w:name w:val="{name}"/>{based_xml}{nxt_xml}{extra}<w:qFormat/>'
            f'<w:pPr>{ppr}</w:pPr><w:rPr>{rpr}</w:rPr></w:style>')


def cstyle(sid, name, rpr, based=None):
    based_xml = f'<w:basedOn w:val="{based}"/>' if based else ""
    return (f'<w:style w:type="character" w:customStyle="1" w:styleId="{sid}">'
            f'<w:name w:val="{name}"/>{based_xml}<w:rPr>{rpr}</w:rPr></w:style>')


def styles_xml() -> str:
    green_rule = (f'<w:pBdr><w:bottom w:val="single" w:sz="16" w:space="1" '
                  f'w:color="{UNIBERDEA}"/></w:pBdr>')
    s = []
    # Built-in base styles
    s.append('<w:style w:type="paragraph" w:default="1" w:styleId="Normal">'
             '<w:name w:val="Normal"/><w:qFormat/></w:style>')
    s.append('<w:style w:type="character" w:default="1" w:styleId="DefaultParagraphFont">'
             '<w:name w:val="Default Paragraph Font"/><w:uiPriority w:val="1"/>'
             '<w:semiHidden/><w:unhideWhenUsed/></w:style>')
    s.append('<w:style w:type="table" w:default="1" w:styleId="TableNormal">'
             '<w:name w:val="Normal Table"/><w:semiHidden/><w:unhideWhenUsed/>'
             '<w:tblPr><w:tblInd w:w="0" w:type="dxa"/><w:tblCellMar>'
             '<w:top w:w="0" w:type="dxa"/><w:left w:w="108" w:type="dxa"/>'
             '<w:bottom w:w="0" w:type="dxa"/><w:right w:w="108" w:type="dxa"/>'
             '</w:tblCellMar></w:tblPr></w:style>')

    # Body text
    s.append(pstyle("BodyText", "Body Text"))
    s.append(pstyle("FirstParagraph", "First Paragraph", based="BodyText", nxt="BodyText"))
    s.append(pstyle("Compact", "Compact", based="BodyText",
                    ppr='<w:spacing w:before="40" w:after="40"/><w:jc w:val="left"/>'))
    s.append(cstyle("BodyTextChar", "Body Text Char", ""))
    # Bold lead-in paragraphs used as small subheadings (templates/filters/
    # keep-with-next.lua): stay on the same page as the next block
    s.append(pstyle("KeepWithNext", "Keep With Next", based="BodyText", nxt="BodyText",
                    ppr='<w:keepNext/><w:keepLines/>'))

    # Pandoc title block (removed by the Lua filter; kept for completeness)
    for sid, name, rpr in [("Title", "Title", '<w:b/><w:sz w:val="38"/>'),
                           ("Subtitle", "Subtitle", '<w:i/><w:sz w:val="24"/>'),
                           ("Author", "Author", ""), ("Date", "Date", ""),
                           ("AbstractTitle", "Abstract Title", '<w:b/>'),
                           ("Abstract", "Abstract", '<w:sz w:val="20"/>')]:
        s.append(pstyle(sid, name, based="Normal", nxt="BodyText",
                        ppr='<w:jc w:val="center"/>', rpr=rpr))
    s.append(cstyle("TitleChar", "Title Char", '<w:b/><w:sz w:val="38"/>'))
    s.append(cstyle("SubtitleChar", "Subtitle Char", '<w:i/><w:sz w:val="24"/>'))

    # APA 7 reference list: hanging indent 1.27 cm, not justified
    s.append(pstyle("Bibliography", "Bibliography", based="Normal",
                    ppr='<w:ind w:left="720" w:hanging="720"/><w:jc w:val="left"/>'))

    # Headings (same sizes as the PDF: 16 / 13 / 11.5 pt)
    # (no pageBreakBefore: each chapter opens an odd-page section, see hefa-docx.lua)
    head = [(1, 32, '<w:spacing w:before="480" w:after="60"/>'),
            (2, 26, '<w:spacing w:before="360" w:after="120"/>'),
            (3, 23, '<w:spacing w:before="280" w:after="100"/>')]
    for lvl in range(4, 10):
        head.append((lvl, 22, '<w:spacing w:before="200" w:after="80"/>'))
    for lvl, size, sp in head:
        ppr = f'<w:keepNext/><w:keepLines/>{sp}<w:jc w:val="left"/><w:outlineLvl w:val="{lvl - 1}"/>'
        rpr = f'<w:b/><w:bCs/><w:color w:val="000000"/><w:sz w:val="{size}"/><w:szCs w:val="{size}"/>'
        if lvl >= 4:
            rpr += '<w:i/>'
        s.append(f'<w:style w:type="paragraph" w:styleId="Heading{lvl}">'
                 f'<w:name w:val="heading {lvl}"/><w:basedOn w:val="Normal"/>'
                 f'<w:next w:val="BodyText"/><w:uiPriority w:val="9"/><w:qFormat/>'
                 f'<w:pPr>{ppr}</w:pPr><w:rPr>{rpr}</w:rPr></w:style>')
        s.append(cstyle(f"Heading{lvl}Char", f"Heading {lvl} Char", rpr))

    # Front-matter headings (Eskerrak, Laburpena, Aurkibidea...): chapter look,
    # but not numbered, not in the TOC and not picked up by the running header
    prelim_ppr = '<w:keepNext/><w:spacing w:before="480" w:after="60"/><w:jc w:val="left"/>'
    prelim_rpr = '<w:b/><w:bCs/><w:sz w:val="32"/><w:szCs w:val="32"/>'
    s.append(pstyle("PrelimHeading", "Prelim Heading", nxt="FirstParagraph",
                    ppr=prelim_ppr, rpr=prelim_rpr))
    s.append(pstyle("TOCHeading", "TOC Heading", nxt="BodyText",
                    ppr=prelim_ppr, rpr=prelim_rpr))

    # Short UNIBERDEA rule under chapter and front-matter titles (empty paragraph)
    s.append(pstyle("HefaRule", "HEFA Rule", nxt="FirstParagraph",
                    ppr=(f'<w:keepNext/>{green_rule}<w:spacing w:before="0" w:after="300" '
                         f'w:line="120" w:lineRule="exact"/>'
                         f'<w:ind w:left="0" w:right="{TEXT_W - RULE_W}"/>'),
                    rpr='<w:sz w:val="4"/>'))

    # Block quotes (> 40 words): 10 pt, 0.5 cm indent, single spacing, green bar
    s.append(pstyle("BlockText", "Block Text", based="BodyText", nxt="BodyText",
                    ppr=(f'<w:pBdr><w:left w:val="single" w:sz="16" w:space="8" '
                         f'w:color="{UNIBERDEA}"/></w:pBdr>'
                         '<w:spacing w:before="120" w:after="120" w:line="240" w:lineRule="auto"/>'
                         '<w:ind w:left="454" w:right="0"/>'),
                    rpr='<w:sz w:val="20"/><w:szCs w:val="20"/>'))

    # Footnotes: 9.5 pt, single spacing, justified
    s.append(pstyle("FootnoteText", "Footnote Text",
                    ppr='<w:spacing w:before="0" w:after="60" w:line="240" w:lineRule="auto"/>',
                    rpr='<w:sz w:val="19"/><w:szCs w:val="19"/>'))
    s.append(pstyle("FootnoteBlockText", "Footnote Block Text", based="FootnoteText"))
    s.append(cstyle("FootnoteReference", "Footnote Reference", '<w:vertAlign w:val="superscript"/>'))

    # Captions (APA 7): left-aligned 10 pt; the filter makes the label bold and
    # puts the italic title on the next line
    cap_ppr = '<w:keepNext/><w:spacing w:before="200" w:after="120" w:line="264" w:lineRule="auto"/><w:jc w:val="left"/>'
    cap_rpr = '<w:sz w:val="20"/><w:szCs w:val="20"/>'
    s.append(pstyle("Caption", "Caption", ppr=cap_ppr, rpr=cap_rpr))
    s.append(pstyle("TableCaption", "Table Caption", based="Caption", ppr=cap_ppr, rpr=cap_rpr))
    s.append(pstyle("ImageCaption", "Image Caption", based="Caption", ppr=cap_ppr, rpr=cap_rpr))
    s.append(pstyle("Figure", "Figure", ppr='<w:keepNext/><w:jc w:val="center"/>'))
    s.append(pstyle("CaptionedFigure", "Captioned Figure", based="Figure",
                    ppr='<w:keepNext/><w:jc w:val="center"/>'))

    # Callout title row (Quarto draws callouts as 2-row tables). keepNext keeps
    # the title row on the same page as the body row, so a callout is never
    # split between its title and its text. Bold 10 pt, like the PDF.
    s.append(pstyle("CalloutTitle", "Callout Title",
                    ppr=('<w:keepNext/><w:keepLines/><w:spacing w:before="0" w:after="0" '
                         'w:line="240" w:lineRule="auto"/><w:textAlignment w:val="center"/><w:jc w:val="left"/>'),
                    rpr='<w:b/><w:sz w:val="20"/><w:szCs w:val="20"/>'))

    s.append(pstyle("DefinitionTerm", "Definition Term", nxt="Definition",
                    ppr='<w:keepNext/><w:spacing w:after="0"/>', rpr='<w:b/>'))
    s.append(pstyle("Definition", "Definition"))
    s.append(cstyle("VerbatimChar", "Verbatim Char",
                    '<w:rFonts w:ascii="Consolas" w:hAnsi="Consolas"/><w:sz w:val="20"/>'))
    s.append(cstyle("SectionNumber", "Section Number", ""))
    s.append(cstyle("Hyperlink", "Hyperlink", f'<w:color w:val="{LINK}"/>'))

    # Table of contents
    toc_tab = f'<w:tabs><w:tab w:val="right" w:leader="dot" w:pos="{TEXT_W}"/></w:tabs>'
    for lvl, ind, rpr, before in [(1, 0, '<w:b/>', 160), (2, 284, "", 40), (3, 567, "", 20)]:
        s.append(f'<w:style w:type="paragraph" w:styleId="TOC{lvl}">'
                 f'<w:name w:val="toc {lvl}"/><w:basedOn w:val="Normal"/><w:next w:val="Normal"/>'
                 f'<w:uiPriority w:val="39"/><w:unhideWhenUsed/>'
                 f'<w:pPr>{toc_tab}<w:spacing w:before="{before}" w:after="20" w:line="276" w:lineRule="auto"/>'
                 f'<w:ind w:left="{ind}"/><w:jc w:val="left"/></w:pPr><w:rPr>{rpr}</w:rPr></w:style>')

    # Running header / footer
    s.append(f'<w:style w:type="paragraph" w:styleId="Header"><w:name w:val="header"/>'
             f'<w:basedOn w:val="Normal"/><w:pPr><w:tabs><w:tab w:val="right" w:pos="{TEXT_W}"/></w:tabs>'
             f'<w:pBdr><w:bottom w:val="single" w:sz="4" w:space="4" w:color="{UNIBERDEA}"/></w:pBdr>'
             f'<w:spacing w:after="0" w:line="240" w:lineRule="auto"/><w:jc w:val="left"/></w:pPr>'
             f'<w:rPr><w:color w:val="{GREY}"/><w:sz w:val="17"/><w:szCs w:val="17"/></w:rPr></w:style>')
    s.append('<w:style w:type="paragraph" w:styleId="Footer"><w:name w:val="footer"/>'
             '<w:basedOn w:val="Normal"/><w:pPr><w:spacing w:after="0"/></w:pPr>'
             '<w:rPr><w:b/><w:sz w:val="18"/><w:szCs w:val="18"/></w:rPr></w:style>')

    # Cover page (built by templates/docx/hefa-docx.lua from metadata.tfg)
    s.append(pstyle("CoverLogo", "Cover Logo",
                    ppr='<w:spacing w:before="0" w:after="2000"/><w:jc w:val="center"/>'))
    s.append(pstyle("CoverLabel", "Cover Label",
                    ppr='<w:spacing w:before="0" w:after="200"/><w:jc w:val="center"/>',
                    rpr='<w:b/><w:spacing w:val="26"/><w:sz w:val="22"/>'))
    s.append(pstyle("CoverRuleShort", "Cover Rule Short",
                    ppr=(f'<w:pBdr><w:bottom w:val="single" w:sz="16" w:space="1" w:color="{UNIBERDEA}"/></w:pBdr>'
                         '<w:spacing w:before="0" w:after="340" w:line="120" w:lineRule="exact"/>'
                         f'<w:ind w:left="{(TEXT_W - 2551) // 2}" w:right="{(TEXT_W - 2551) // 2}"/>'),
                    rpr='<w:sz w:val="4"/>'))
    s.append(pstyle("CoverTitle", "Cover Title",
                    ppr='<w:spacing w:before="0" w:after="200" w:line="300" w:lineRule="auto"/><w:jc w:val="center"/>',
                    rpr='<w:b/><w:smallCaps/><w:sz w:val="38"/><w:szCs w:val="38"/>'))
    s.append(pstyle("CoverSubtitle", "Cover Subtitle",
                    ppr='<w:spacing w:before="0" w:after="0"/><w:jc w:val="center"/>',
                    rpr='<w:i/><w:color w:val="333333"/><w:sz w:val="24"/><w:szCs w:val="24"/>'))
    s.append(pstyle("CoverData", "Cover Data",
                    ppr=('<w:tabs><w:tab w:val="left" w:pos="2552"/></w:tabs>'
                         '<w:spacing w:before="0" w:after="140" w:line="240" w:lineRule="auto"/>'
                         '<w:ind w:left="2552" w:hanging="2552"/><w:jc w:val="left"/>')))
    s.append(pstyle("CoverDataFirst", "Cover Data First", based="CoverData",
                    ppr=(f'<w:pBdr><w:top w:val="single" w:sz="12" w:space="10" w:color="{UNIBERDEA}"/></w:pBdr>'
                         '<w:spacing w:before="3700"/>')))
    s.append(pstyle("CoverDataLast", "Cover Data Last", based="CoverData",
                    ppr=(f'<w:pBdr><w:bottom w:val="single" w:sz="12" w:space="10" w:color="{UNIBERDEA}"/></w:pBdr>'
                         '<w:spacing w:after="300"/>')))
    s.append(pstyle("CoverFooter", "Cover Footer",
                    ppr='<w:spacing w:before="0" w:after="0" w:line="240" w:lineRule="auto"/><w:jc w:val="center"/>',
                    rpr=f'<w:color w:val="{GREY}"/><w:sz w:val="16"/><w:szCs w:val="16"/>'))

    # Default table style used by Quarto for figure layouts and callouts: no rules
    s.append('<w:style w:type="table" w:styleId="Table"><w:name w:val="Table"/>'
             '<w:basedOn w:val="TableNormal"/><w:qFormat/><w:tblPr><w:tblInd w:w="0" w:type="dxa"/>'
             '<w:tblCellMar><w:top w:w="0" w:type="dxa"/><w:left w:w="108" w:type="dxa"/>'
             '<w:bottom w:w="0" w:type="dxa"/><w:right w:w="108" w:type="dxa"/></w:tblCellMar></w:tblPr></w:style>')

    # APA 7 data tables (assigned by the Lua filter to tables with a header row):
    # top 1 pt, below header 0.5 pt, bottom 1 pt; no vertical lines; 10 pt text
    s.append('<w:style w:type="table" w:customStyle="1" w:styleId="HefaTable"><w:name w:val="HEFA Table"/>'
             '<w:basedOn w:val="TableNormal"/><w:qFormat/>'
             '<w:pPr><w:spacing w:before="40" w:after="40" w:line="240" w:lineRule="auto"/><w:jc w:val="left"/></w:pPr>'
             '<w:rPr><w:sz w:val="20"/><w:szCs w:val="20"/></w:rPr>'
             '<w:tblPr><w:tblBorders><w:top w:val="single" w:sz="8" w:space="0" w:color="000000"/>'
             '<w:bottom w:val="single" w:sz="8" w:space="0" w:color="000000"/></w:tblBorders>'
             '<w:tblCellMar><w:top w:w="80" w:type="dxa"/><w:left w:w="160" w:type="dxa"/>'
             '<w:bottom w:w="80" w:type="dxa"/><w:right w:w="160" w:type="dxa"/></w:tblCellMar></w:tblPr>'
             '<w:tblStylePr w:type="firstRow"><w:pPr><w:jc w:val="center"/></w:pPr><w:rPr><w:b/></w:rPr>'
             '<w:tcPr><w:tcBorders><w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>'
             '</w:tcBorders><w:vAlign w:val="bottom"/></w:tcPr></w:tblStylePr></w:style>')

    defaults = (
        '<w:docDefaults><w:rPrDefault><w:rPr>'
        f'<w:rFonts w:ascii="{FONT}" w:hAnsi="{FONT}" w:eastAsia="{FONT}" w:cs="{FONT}"/>'
        '<w:sz w:val="22"/><w:szCs w:val="22"/><w:lang w:val="eu-ES" w:eastAsia="eu-ES" w:bidi="ar-SA"/>'
        '</w:rPr></w:rPrDefault><w:pPrDefault><w:pPr>'
        '<w:spacing w:before="0" w:after="160" w:line="312" w:lineRule="auto"/><w:jc w:val="both"/>'
        '</w:pPr></w:pPrDefault></w:docDefaults>')

    return ('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
            '<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" '
            'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">'
            + defaults + "".join(s) + "</w:styles>")


# ------------------------------------------------------------------------------
# Headers, footers, document and package parts
# ------------------------------------------------------------------------------
W_NS = ('xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" '
        'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"')

CHAPTER_FIELD = ('<w:r><w:fldChar w:fldCharType="begin"/></w:r>'
                 '<w:r><w:instrText xml:space="preserve"> STYLEREF "heading 1" \\* MERGEFORMAT </w:instrText></w:r>'
                 '<w:r><w:fldChar w:fldCharType="separate"/></w:r><w:r><w:t>Kapitulua</w:t></w:r>'
                 '<w:r><w:fldChar w:fldCharType="end"/></w:r>')
def docprop_field(name: str, placeholder: str) -> str:
    """Field showing a custom document property written by hefa-docx.lua."""
    return ('<w:r><w:fldChar w:fldCharType="begin" w:dirty="true"/></w:r>'
            f'<w:r><w:instrText xml:space="preserve"> DOCPROPERTY {name} \\* MERGEFORMAT </w:instrText></w:r>'
            f'<w:r><w:fldChar w:fldCharType="separate"/></w:r><w:r><w:t>{placeholder}</w:t></w:r>'
            '<w:r><w:fldChar w:fldCharType="end"/></w:r>')


WORK_TYPE_FIELD = docprop_field("hefa-lan-mota", "Gradu Amaierako Lana (GRAL)")
AUTHOR_FIELD = docprop_field("hefa-egilea", "Egilea")

PAGE_FIELD = ('<w:r><w:fldChar w:fldCharType="begin"/></w:r>'
              '<w:r><w:instrText xml:space="preserve"> PAGE </w:instrText></w:r>'
              '<w:r><w:fldChar w:fldCharType="separate"/></w:r><w:r><w:t>1</w:t></w:r>'
              '<w:r><w:fldChar w:fldCharType="end"/></w:r>')


def header_xml(left: str, right: str) -> str:
    return (f'<?xml version="1.0" encoding="UTF-8" standalone="yes"?><w:hdr {W_NS}>'
            f'<w:p><w:pPr><w:pStyle w:val="Header"/></w:pPr>{left}<w:r><w:tab/></w:r>{right}</w:p></w:hdr>')


def footer_xml(align: str) -> str:
    return (f'<?xml version="1.0" encoding="UTF-8" standalone="yes"?><w:ftr {W_NS}>'
            f'<w:p><w:pPr><w:pStyle w:val="Footer"/><w:jc w:val="{align}"/></w:pPr>{PAGE_FIELD}</w:p></w:ftr>')


def document_xml() -> str:
    # Final section = last chapter. hefa-docx.lua closes every earlier section
    # (front matter without headers; TOC restarting page numbers at 1; one
    # section per chapter) with the same geometry and these relationship IDs.
    # Every section starts on an odd page, like the PDF.
    sect = (f'<w:sectPr><w:headerReference w:type="default" r:id="rIdHdrOdd"/>'
            f'<w:headerReference w:type="even" r:id="rIdHdrEven"/>'
            f'<w:headerReference w:type="first" r:id="rIdHdrFirst"/>'
            f'<w:footerReference w:type="default" r:id="rIdFtrOdd"/>'
            f'<w:footerReference w:type="even" r:id="rIdFtrEven"/>'
            f'<w:footerReference w:type="first" r:id="rIdFtrOdd"/>'
            f'<w:footnotePr><w:numRestart w:val="continuous"/></w:footnotePr>'
            f'<w:type w:val="oddPage"/><w:pgSz w:w="{PAGE_W}" w:h="{PAGE_H}"/>'
            f'<w:pgMar w:top="{MARGIN}" w:right="{MARGIN}" w:bottom="{MARGIN}" w:left="{MARGIN}" '
            f'w:header="709" w:footer="709" w:gutter="0"/>'
            f'<w:cols w:space="708"/><w:titlePg/></w:sectPr>')
    return (f'<?xml version="1.0" encoding="UTF-8" standalone="yes"?><w:document {W_NS}><w:body>'
            f'<w:p><w:pPr><w:pStyle w:val="BodyText"/></w:pPr><w:r><w:t>HEFA</w:t></w:r></w:p>'
            f'{sect}</w:body></w:document>')


def main() -> None:
    base = HERE / ".pandoc-default-reference.docx"
    import subprocess
    subprocess.run(["quarto", "pandoc", "-o", str(base), "--print-default-data-file",
                    "reference.docx"], check=True)

    lm = WORK_TYPE_FIELD
    parts = {
        "word/styles.xml": styles_xml(),
        "word/document.xml": document_xml(),
        # Odd pages: work type | chapter. Even pages: chapter | work type.
        "word/header1.xml": header_xml(lm, CHAPTER_FIELD),
        "word/header2.xml": header_xml(CHAPTER_FIELD, lm),
        # First page of each chapter (and of the TOC): work type | author
        "word/header3.xml": header_xml(lm, AUTHOR_FIELD),
        # Page number on the outer side
        "word/footer1.xml": footer_xml("right"),
        "word/footer2.xml": footer_xml("left"),
    }

    with zipfile.ZipFile(base) as zin, zipfile.ZipFile(OUT, "w", zipfile.ZIP_DEFLATED) as zout:
        for item in zin.infolist():
            data = zin.read(item.filename)
            if item.filename in parts:
                continue
            if item.filename == "word/_rels/document.xml.rels":
                rels = data.decode("utf-8")
                extra = "".join(
                    f'<Relationship Id="{rid}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/{kind}" Target="{target}"/>'
                    for rid, kind, target in [("rIdHdrOdd", "header", "header1.xml"),
                                              ("rIdHdrEven", "header", "header2.xml"),
                                              ("rIdHdrFirst", "header", "header3.xml"),
                                              ("rIdFtrOdd", "footer", "footer1.xml"),
                                              ("rIdFtrEven", "footer", "footer2.xml")])
                data = rels.replace("</Relationships>", extra + "</Relationships>").encode("utf-8")
            elif item.filename == "[Content_Types].xml":
                ct = data.decode("utf-8")
                extra = "".join(
                    f'<Override PartName="/word/{n}.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.{k}+xml"/>'
                    for n, k in [("header1", "header"), ("header2", "header"), ("header3", "header"),
                                 ("footer1", "footer"), ("footer2", "footer")])
                data = ct.replace("</Types>", extra + "</Types>").encode("utf-8")
            elif item.filename == "word/settings.xml":
                st = data.decode("utf-8")
                # Mirrored headers on even/odd pages; ask Word to refresh the
                # table of contents and the chapter fields when the file opens
                # (OOXML requires this element order: evenAndOddHeaders before
                # the drawing grid settings, updateFields before footnotePr)
                st = re.sub(r"<w:evenAndOddHeaders\s*/>|<w:updateFields[^>]*/>", "", st)
                st = st.replace("<w:drawingGridHorizontalSpacing", "<w:evenAndOddHeaders/><w:drawingGridHorizontalSpacing", 1)
                st = st.replace("<w:footnotePr", '<w:updateFields w:val="true"/><w:footnotePr', 1)
                data = st.encode("utf-8")
            zout.writestr(item, data)
        for name, xml in parts.items():
            zout.writestr(name, xml.encode("utf-8"))
    base.unlink()
    print(f"Written {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
