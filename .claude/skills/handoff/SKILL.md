---
name: handoff
description: Generates, updates, and structures comprehensive project handoff documents (HANDOFF.md) in English so work can be seamlessly continued across sessions, agents, or environments.
---

# Project Handoff Skill

This skill defines the standard procedure for generating, maintaining, and updating a `HANDOFF.md` document at the root of the project. Use this skill whenever transferring context to another AI agent, moving work across machines/workspaces, or closing a development milestone.

## Objectives of a Handoff

1. **Zero Context Loss**: Ensure another agent or developer can immediately understand the project state, goals, architectural decisions, and current blockers.
2. **Actionable Continuity**: Clearly list pending tasks, ongoing discussions, and immediate next steps.
3. **Reproducibility**: Provide exact commands to build, test, and render outputs across all supported formats (`html`, `docx`, `typst`).

## Structure of HANDOFF.md

When generating or updating `HANDOFF.md`, maintain the following sections in clear, professional English:

### 1. Executive Summary
- Brief description of the project (e.g., UPV/EHU HEFA Undergraduate Thesis / GRAL template).
- Main purpose of the repository.
- Core languages (content language vs. technical orchestration).

### 2. Tech Stack & Environment Prerequisites
- Core tools and required versions:
  - Quarto (`quarto --version`, >= 1.9; Typst books)
  - Typst (integrated with Quarto or standalone)
  - Pandoc & Pandoc Citeproc
  - Browser/Chrome headless shell (required by Quarto for server-side Mermaid rendering to PDF/DOCX)
  - Fonts: `EHUSans` / `EHUSerif` in `assets/fonts/` (loaded by Typst via `font-paths`).

### 3. Architecture & Repository Map
- Map and explanation of crucial directories and configuration files:
  - `_quarto.yml`: Central configuration file for global metadata, bibliography, and formats.
  - `index.qmd`: Book landing page; includes the front matter only.
  - `front-matter/`: Unnumbered preliminary sections (cover, acknowledgements, abstracts, table of contents), included from `index.qmd`.
  - `chapters/`: Numbered thesis chapters `01-*` through `08-*`, registered in `book.chapters`.
  - `templates/typst/`: Typst styling rules (`hefa-style.typ`), cover template (`hefa-cover.typ`) and `partials/` overriding Quarto's orange-book template.
  - `templates/html/`, `templates/docx/`, `templates/filters/`: HTML theme, Word reference document + filter, shared Lua filters.
  - `.github/workflows/publish.yml`: GitHub Pages build and deploy.
  - `assets/`: `images/` and `fonts/`. `docs/reference/`: official HEFA/EHU reference documents (local only, git-ignored).
  - `bibliography/`: BibTeX database (`references.bib`) and APA 7 citation style (`apa.csl`).
  - `build/`: Target directory for rendered artifacts.

### 4. Current State & Completed Milestones
- Specific, detailed account of what has been implemented so far.
- Key configurations established (e.g., multi-format support for HTML, DOCX, and Typst).
- Verified rendering results and artifact locations.

### 5. In-Progress Discussions & Technical Decisions
- Open architectural options under discussion with the user (e.g., single continuous HTML vs. multi-page Quarto Book `project: type: book`).
- Trade-offs, required file changes, and migration considerations.

### 6. Immediate Next Steps & Action Items
- Bulleted, prioritized list of exact tasks for the incoming agent.
- Potential edge cases (e.g., relative image paths when migrating to book mode, unnumbered headings).

### 7. Build, Verification & Command Cheat Sheet
- Exact terminal commands to compile each format:
  ```bash
  # Render HTML web version
  quarto render --to html

  # Render Word DOCX version
  quarto render --to docx

  # Render Typst PDF version
  quarto render --to typst

  # Render all configured formats
  quarto render
  ```

## Maintenance Rules

- **Language**: The `HANDOFF.md` document must always be maintained in **English**.
- **Accuracy**: Keep file paths relative to repository root and verify that all build commands match the actual `_quarto.yml` configuration.
- **Timestamping**: Always include the last updated date/time and project version at the top of the handoff document.

## Language Rule

- Write `HANDOFF.md` in English, and keep every comment in project files (`_quarto.yml`, `.typ`, `.qmd` raw blocks and HTML comments) in English, as required by `AGENTS.md`.
