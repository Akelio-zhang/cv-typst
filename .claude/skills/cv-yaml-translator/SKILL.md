---
name: cv-yaml-translator
description: Translates a CV data YAML file from one language to another, producing a new data file (e.g., data-zh.yaml → data-en.yaml). Use this skill whenever asked to translate CV data between languages, create a new language version of the CV, or generate data-en.yaml from data-zh.yaml (or vice versa).
---

# CV YAML Translator

Translate a CV data YAML file from one language to another, preserving structure exactly.

## Inputs

- **Source file**: e.g. `data-zh.yaml`
- **Target language**: e.g. `en` (English) or `zh` (Chinese)
- **Output file**: e.g. `data-en.yaml` (default: `data-<target>.yaml` in same directory)

## What to translate vs. preserve

**Translate these fields** — they contain human-readable text meant to be read by the CV audience:

| Field | Example |
|-------|---------|
| `contact.name` | 张三 → Zhang San |
| `<section>.title` | 教育经历 → Education |
| `entry.name` | 某某大学计算机科学 → CS, XX University |
| `entry.desc` | 全栈开发工程师 → Full-Stack Engineer |
| `entry.location` | 上海 → Shanghai |
| `entry.details[]` | each bullet point string |
| `entry.links[].text` | 项目演示 → Project Demo |

**Preserve these fields exactly** — they are identifiers, URLs, dates, or structured data that must not change:

- `contact.email`, `contact.phone`
- `contact.github.url`, `contact.github.text` (it's a URL display string)
- `entry.date` (date ranges like `2020/07 -- 至今` should be localized: → `2020/07 -- Present`)
- `entry.links[].url`
- All YAML keys (structural field names)
- `sections` list structure, `key` values, `render` flags
- `entry.output` flags

**Special case — `entry.date`**: Date ranges are structural but contain locale-specific words like "至今" (→ "Present") or "现在". Translate only such words, keep the date format intact.

## Process

1. Read the source YAML file.
2. Parse it mentally (or with a script) to identify every translatable field.
3. Translate all translatable fields to the target language. Use natural, professional CV phrasing appropriate for the target language — don't translate too literally.
4. Write the output YAML file, preserving:
   - Exact key names
   - Exact indentation and structure
   - Comment lines (e.g. `# 其他部分结构类似...`)
   - Field ordering within each mapping

## Output

Write the translated content directly to the output file using the Write tool. Construct the full YAML text with all translations applied, preserving exact indentation, key names, and comment lines.

YAML formatting rules to follow manually:
- Strings containing `:` or `#` must be quoted (e.g. `"Languages: Python, Java"`)
- List items use `- ` prefix with consistent indentation
- Preserve blank lines between sections as in the source

After writing, confirm the output file was created and briefly list any fields where you made a translation judgment call (e.g., company names left untranslated, technical terms kept in English).
