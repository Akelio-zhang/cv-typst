# Design: CV Project Usability Improvement

**Date:** 2026-03-23
**Status:** Approved

## Problem

Two usability pain points in the current cv-typst project:

1. **Structure extension requires touching two places** — adding a new CV section means updating both the YAML data file and hardcoded `#render_section(...)` calls in `cv.typ`.
2. **Section visibility is not declarative** — hiding a section requires commenting out code in `cv.typ` or removing data, rather than a simple flag in the data file.

Bilingual content sync (zh/en) is handled externally via LLM, so dual-file maintenance is acceptable.

## Solution

### Data Structure Change

Add a `sections` list at the top of each YAML data file (`data-zh.yaml`, `data-en.yaml`). This list:
- Declares the render order of sections
- Supports `render: false` to hide a section without deleting its content (default is `true`)

Example (`data-zh.yaml`):

```yaml
sections:
  - key: education       # omitting `render` means visible (preferred)
  - key: work
  - key: projects
    render: false        # hidden, content preserved
  - key: skills
  - key: languages
  - key: awards
  # Note: `contact` is never listed here — it is rendered separately

contact:
  ...
education:
  title: 教育经历
  entries: ...
```

### cv.typ Change

Replace the 6 hardcoded `#render_section(...)` calls with a single loop. `contact` is **not** included in `sections` — it retains its separate `#render_contact()` call because it has a distinct data shape (no `entries` list).

```typst
#render_contact()
#for s in data.sections [
  #if s.at("render", default: true) [
    #render_section(data.at(s.key, default: none))
  ]
]
```

`data.at(s.key, default: none)` — if a key listed in `sections` is absent from the YAML body (e.g. a typo), `render_section` receives `none`. The existing guard `if module.entries == none { return }` is **not** sufficient here: accessing `.entries` on `none` in Typst raises a field-access panic before the comparison runs. The implementation must add a `module == none` guard first:

```typst
#let render_section(module) = {
  if module == none { return }
  if module.entries == none { return }
  ...
}
```

### data-en.yaml

Create `data-en.yaml` mirroring the structure of `data-zh.yaml` with English content, including the same `sections` list. Note: `contact` must remain present in the YAML body as `render_contact()` reads it directly. Until `data-en.yaml` exists, `just compile en concise` and `just compile-all` will fail at runtime.

**Translation workflow:** A local skill `.claude/skills/cv-yaml-translator` is available for agents to perform this translation. When asked to create or sync a language file, invoke this skill. It handles field-level translation rules (what to translate vs. preserve), date localization, and YAML formatting.

## Outcomes

- **Add a new section:** Add data under a new key in YAML + add one line to `sections`. No changes to `cv.typ`.
- **Hide a section:** Set `render: false` in `sections`. Content is preserved and easy to re-enable.
- **Reorder sections:** Reorder lines in `sections`.
- **cv.typ** becomes stable — changes to section structure no longer require editing the template.

## Out of Scope

- Per-entry `output: full` filtering already exists and is unchanged.
- Build system (`justfile`) is unchanged.
- Font or layout changes.
