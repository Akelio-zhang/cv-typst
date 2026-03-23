# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

Requires [Just](https://github.com/casey/just) and [Typst](https://typst.app/) installed.

```bash
just                        # Build default: Chinese, concise → cv.pdf
just compile zh full        # Build Chinese full version → cv_zh_full.pdf
just compile en concise     # Build English concise version → cv_en_concise.pdf
just compile-all            # Build all 3 variants
```

Without `just`:
```bash
echo '#let render_mode = (la: "zh", output: "concise")' > f.typ && sed 1d cv.typ >> f.typ && typst compile f.typ cv.pdf && rm f.typ
```

Check available fonts: `typst fonts`

## Architecture

The build system injects a `render_mode` variable at the top of `cv.typ` before compilation (since Typst doesn't support CLI variable injection natively). The justfile prepends the mode line and strips the placeholder first line of `cv.typ`.

### Files

- **cv.typ** — Main document. Line 1 is a placeholder `render_mode` declaration (overwritten at build time). Defines rendering helpers and calls section renderers.
- **meta.typ** — Utility functions: `today()` (Chinese date) and `today_en()` (English date).
- **data-zh.yaml** — CV content in Chinese. An `data-en.yaml` file should be created for English output.
- **justfile** — Build recipes.

### Render Mode

`render_mode` is a dict with two keys:
- `la`: `"zh"` or `"en"` — selects the language data file (`data-{la}.yaml`) and controls which `#section(la: ...)` blocks render
- `output`: `"concise"` or `"full"` — entries with `output: "full"` are hidden in concise mode

### Data Schema (YAML)

Each module in the YAML has `title` and `entries`. Entry fields:
- `name`, `date`, `desc`, `location` — displayed inline
- `details` — list of bullet points
- `output` — optional, `"full"` to hide in concise mode
- `links` — optional list of `{url, text}` (defined in data but not yet rendered by default template)

Sections are declared in the `sections` list at the top of each YAML file, not hardcoded.

### sections list

Each YAML data file starts with a `sections` list controlling render order and visibility:

```yaml
sections:
  - key: education      # omitting `render` = visible (preferred)
  - key: projects
    render: false       # hidden, content preserved
```

- `key` must match a top-level YAML key in the same file
- `contact` is never listed here — rendered separately by `render_contact()`
- To translate a data file, use the local skill: `.claude/skills/cv-yaml-translator`

To add a new language, create `data-en.yaml` (or another language code) mirroring the structure of `data-zh.yaml`.
