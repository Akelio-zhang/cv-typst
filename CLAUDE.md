# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

Requires [Just](https://github.com/casey/just) and [Typst](https://typst.app/) installed.

```bash
just                        # Default: Chinese concise
just zh                     # Chinese concise (shortcut)
just zh-full                # Chinese full
just en                     # English concise (shortcut)
just en-full                # English full
just all                    # All variants
just clean                  # Clean PDFs
just fonts                  # Check available fonts
```

Without `just`:
```bash
typst compile --input la=zh --input output=concise cv.typ cv.pdf
```

Check available fonts: `typst fonts`

## Architecture

The build system passes variables via `--input` flags. `cv.typ` reads from `sys.inputs` with defaults.

### Files

- **cv.typ** — Main document. Defines rendering helpers and calls section renderers.
- **meta.typ** — Utility functions: `today()` (Chinese date) and `today_en()` (English date).
- **data-zh.yaml** — CV content in Chinese.
- **data-en.yaml** — CV content in English (translated using `.claude/skills/cv-yaml-translator`).
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
