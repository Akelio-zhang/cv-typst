#let render_mode = (la: "zh", output: "concise")

#import "meta.typ": *

#set text(font: ("New Computer Modern", "Noto Serif CJK SC"))
#show heading: set text(font: ("Linux Biolinum", "Noto Serif CJK SC"))

#show link: underline


// Uncomment the following lines to adjust the size of text
// The recommend resume text size is from `10pt` to `12pt`
// #set text(
//   size: 12pt,
// )

// Custom heading color: https://typst.app/docs/reference/visualize/color/
#let head_color = black

// Feel free to change the margin below to best fit your own CV
#set page(
  margin: (x: 0.9cm, y: 1.3cm),
)

// For more customizable options, please refer to official reference: https://typst.app/docs/reference/
#set par(justify: true)
#show heading: set text(fill: head_color)

#let chiline() = {v(-3pt); line(length: 100%, stroke: head_color); v(-5pt)}

// support language and output render mode switch
#let section(body, la: "zh", output: "concise") = {
  let mode = (la: la, output: output)
  if mode.la == render_mode.la and (mode.output == "concise" or mode.output == render_mode.output) [
    #body
  ]
}


// default with Chinese and concise page
#section[
= 张三

hello\@outlook_ms.com |
+86 188 8888 8888 |
#link("https://www.github.com")[github.com]
]

// for English and concise page
#section(la: "en")[
= ZHANG San

hello\@outlook_ms.com |
+86 188 8888 8888 |
#link("https://www.github.com")[github.com]
]

#section[
== 教育经历
#chiline()

#link("https://typst.app/")[*#lorem(2)*] #h(1fr) 2333/23 -- 2333/23 \
#lorem(5) #h(1fr) #lorem(2) \
- #lorem(10)

*#lorem(2)* #h(1fr) 2333/23 -- 2333/23 \
#lorem(5) #h(1fr) #lorem(2) \
- #lorem(10)
]


#section[
== 工作经历
#chiline()

*#lorem(2)* #h(1fr) 2333/23 -- 2333/23 \
#lorem(5) #h(1fr) #lorem(2) \
- #lorem(20)
- #lorem(40)

*#lorem(2)* #h(1fr) 2333/23 -- 2333/23 \
#lorem(5) #h(1fr) #lorem(2) \
- #lorem(30)
- #lorem(10)
]

#section[
== 项目经历
#chiline()

*#lorem(2)* #h(1fr) 2333/23 -- 2333/23 \
#lorem(5) #h(1fr) #lorem(2) \
- #lorem(20)
- #lorem(30)

*#lorem(2)* #h(1fr) 2333/23 -- 2333/23 \
#lorem(5) #h(1fr) #lorem(2) \
- #lorem(20)
]

#section(la: "zh", output: "full")[

其他项目 \
- *#lorem(2)*#lorem(5)
- *#lorem(1)*#lorem(10)

]

#section[
== 技术特点
#chiline()

- #lorem(2)
- #lorem(5)

]

#section[
== 语言能力
#chiline()

- #lorem(2)
- #lorem(2)

]


#section[
== 获奖经历
#chiline()

- #lorem(5)

]

#section[
#align(right, text(fill: gray)[更新于 #today()])
]
#section(la: "en")[
#align(right, text(fill: gray)[Last Updated on #today_en()])
]