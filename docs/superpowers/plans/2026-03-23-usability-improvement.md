# Usability Improvement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace hardcoded section rendering in `cv.typ` with a YAML-driven `sections` list, and create `data-en.yaml` using the local translation skill.

**Architecture:** Add a `sections` list to each YAML data file that declares render order and visibility (`render: false` to hide). `cv.typ` iterates this list instead of hardcoding section calls. `data-en.yaml` is generated from `data-zh.yaml` via the `cv-yaml-translator` skill.

**Tech Stack:** Typst, YAML, Just (build tool). No new dependencies.

---

## File Map

| File | Change |
|------|--------|
| `data-zh.yaml` | Add `sections` list at top |
| `data-en.yaml` | Create new (translated from `data-zh.yaml`) |
| `cv.typ` | Fix `render_section` guard; replace 6 hardcoded calls with loop |

---

## Task 1: Add `sections` list to `data-zh.yaml`

**Files:**
- Modify: `data-zh.yaml` (top of file)

The `sections` list declares render order. Omitting `render` means visible (default). `contact` must NOT appear here — it is rendered separately by `render_contact()`.

- [ ] **Step 1: Add `sections` at the top of `data-zh.yaml`**

Insert the following block at the very top of `data-zh.yaml`, before the `contact:` key:

```yaml
sections:
  - key: education
  - key: work
  - key: projects
  - key: skills
  - key: languages
  - key: awards
  # Note: `contact` is never listed here — rendered separately

```

- [ ] **Step 2: Verify `cv.typ` still compiles (before touching cv.typ)**

`cv.typ` currently hardcodes `data.education`, `data.work`, etc. — it does NOT read `data.sections` yet, so adding `sections` to the YAML is a purely additive change and must not break compilation.

Run:
```bash
just
```
Expected: `compile pdf success!` and `cv.pdf` is generated with all sections visible.

- [ ] **Step 3: Commit**

```bash
git add data-zh.yaml
git commit -m "data: add sections list to data-zh.yaml"
```

---

## Task 2: Fix `render_section` guard in `cv.typ`

**Files:**
- Modify: `cv.typ` lines 88–98

The current guard `if module.entries == none { return }` will panic at runtime if `module` itself is `none` (e.g., a typo in a `sections` key). In Typst, accessing `.entries` on `none` raises a field-access error before the comparison runs. Add a `module == none` guard first.

- [ ] **Step 1: Update `render_section` in `cv.typ`**

Find this block (lines 88–98):

```typst
// 模块化section渲染
#let render_section(module) = {
  if module.entries == none { return }

  [
    == #module.title
    #chiline()
    #for entry in module.entries [
      #render_entry(entry)
    ]
  ]
}
```

Replace with:

```typst
// 模块化section渲染
#let render_section(module) = {
  if module == none { return }
  if module.at("entries", default: none) == none { return }

  [
    == #module.title
    #chiline()
    #for entry in module.entries [
      #render_entry(entry)
    ]
  ]
}
```

> Using `module.at("entries", default: none)` (rather than `module.entries`) avoids a panic when the `entries` key is entirely absent from the dictionary, not just set to `none`.

- [ ] **Step 2: Verify compilation is unchanged**

```bash
just
```
Expected: `compile pdf success!` — output PDF identical to before.

- [ ] **Step 3: Commit**

```bash
git add cv.typ
git commit -m "fix: guard render_section against none module"
```

---

## Task 3: Replace hardcoded section calls with `sections` loop

**Files:**
- Modify: `cv.typ` lines 100–107

Replace the 6 hardcoded `#render_section(data.X)` calls with a single loop that reads `data.sections`. The `#section[...]` timestamp blocks at lines 109–114 are unchanged.

- [ ] **Step 1: Replace hardcoded calls in `cv.typ`**

Find this block (lines 100–107):

```typst
// 主文档结构
#render_contact()
#render_section(data.education)
#render_section(data.work)
#render_section(data.projects)
#render_section(data.skills)
#render_section(data.languages)
#render_section(data.awards)
```

Replace with:

```typst
// 主文档结构
#render_contact()
#for s in data.sections [
  #if s.at("render", default: true) [
    #render_section(data.at(s.key, default: none))
  ]
]
```

- [ ] **Step 2: Compile and verify all sections still appear**

```bash
just
```
Expected: `compile pdf success!`. Open `cv.pdf` and confirm all 6 sections (education, work, projects, skills, languages, awards) are present and in the same order as before.

- [ ] **Step 3: Verify `render: false` hides a section**

Temporarily edit `data-zh.yaml` — add `render: false` to the `awards` entry:

```yaml
sections:
  ...
  - key: awards
    render: false
```

Run `just` again. Confirm the awards section is absent from `cv.pdf`. Then revert the change.

- [ ] **Step 4: Revert the temporary test edit**

```bash
git checkout HEAD -- data-zh.yaml
```

- [ ] **Step 5: Commit**

```bash
git add cv.typ
git commit -m "feat: replace hardcoded section calls with YAML-driven sections loop"
```

---

## Task 4: Create `data-en.yaml` using the `cv-yaml-translator` skill

**Files:**
- Create: `data-en.yaml`

Use the local skill at `.claude/skills/cv-yaml-translator` to translate `data-zh.yaml` into English. The skill handles which fields to translate vs. preserve (dates, URLs, emails, YAML keys, `sections` structure).

- [ ] **Step 1: Invoke `cv-yaml-translator` skill**

@.claude/skills/cv-yaml-translator

Translate `data-zh.yaml` → `data-en.yaml` (target language: English). The `sections` list structure, `render` flags, `key` values, `contact.email`, `contact.phone`, `contact.github.url/text`, and all date strings (except locale words like "至今" → "Present") must be preserved exactly.

- [ ] **Step 2: Verify `data-en.yaml` contains a `sections` list**

```bash
grep -c "^sections:" data-en.yaml
```
Expected: `1` — confirms the translator preserved the `sections` list.

- [ ] **Step 3: Verify `data-en.yaml` compiles**

```bash
just compile en concise
```
Expected: `compile pdf[la=en, output=concise] success!` and `cv_en_concise.pdf` is generated with English content.

- [ ] **Step 4: Verify full build**

```bash
just compile-all
```
Expected output (3 compile lines followed by):
```
generate all types of files success!
```

- [ ] **Step 5: Commit**

```bash
git add data-en.yaml
git commit -m "feat: add English CV data file (data-en.yaml)"
```

---

## Task 5: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`

Add a note about the `sections` list and the translation skill so future agents know how to use them.

- [ ] **Step 1: Update the Data Schema section in `CLAUDE.md`**

In the `Data Schema (YAML)` section, replace line 48:

**Old:**
```markdown
Sections rendered: `contact`, `education`, `work`, `projects`, `skills`, `languages`, `awards`.
```

**New:**
```markdown
Sections are declared in the `sections` list at the top of each YAML file, not hardcoded.

### sections list

Each YAML data file starts with a `sections` list controlling render order and visibility:

\```yaml
sections:
  - key: education      # omitting `render` = visible (preferred)
  - key: projects
    render: false       # hidden, content preserved
\```

- `key` must match a top-level YAML key in the same file
- `contact` is never listed here — rendered separately by `render_contact()`
- To translate a data file, use the local skill: `.claude/skills/cv-yaml-translator`
```

- [ ] **Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: update CLAUDE.md with sections list and translator skill"
```
