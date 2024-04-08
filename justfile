default: compile-default

compile-default:
  @echo '#let render_mode = (la: "zh", output: "concise")' > f.typ && sed 1d cv.typ >> f.typ
  typst compile f.typ cv.pdf
  @rm f.typ
  @echo 'compile pdf success!'

# la should be zh or en; output should be concise or full.
compile la output:
  @echo '#let render_mode = (la: "{{la}}", output: "{{output}}")' > f.typ && sed 1d cv.typ >> f.typ
  typst compile f.typ cv_{{la}}_{{output}}.pdf
  @rm f.typ
  @echo 'compile pdf[la={{la}}, output={{output}}] success!'

# generate all types of files.
compile-all: (compile-default) (compile "zh" "full") (compile "en" "concise")
  @echo 'generate all types of files success!'
