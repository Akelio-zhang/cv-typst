## Structure

- cv.typ: Content of the CV.
- meta.typ: CV template code.
- justfile: Recipe file for building.

## Features

- [x] Support both Chinese and English in one file. Default to Chinese.
- [x] Support hiding some sections for conciseness. Default to display all.

## Generation

- Upload cv.typ and meta.typ to [typst](https://typst.app/), and use web app to generate.
- Using [just](https://github.com/casey/just), with arguments:
  - `la`: Choose between Chinese (zh) or English (en).
  - `output`: Choose between concise or full for output.
- Examples:
  - `just` generates a concise PDF file in Chinese.
  - `just compile-all` generates all types of PDF files.
  - `just compile en full` generates a full PDF file in English.
- Using `bash`

```bash
echo '#let render_mode = (la: "zh", output: "concise")' > f.typ && sed 1d cv.typ >> f.typ && typst compile f.typ cv.pdf && rm f.typ
```

![cv.png](cv.png))

## Reference

- [typst](https://typst.app/docs/)
  - [conditional render](https://typst.app/docs/reference/scripting/#conditionals)
- [chicv](https://github.com/skyzh/chicv)
- [just](https://just.systems/man/zh/)

## FAQ

- Why font seems not work? A: check with `typst fonts`. 