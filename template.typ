#let chineseNumMap(num) = {
  let digits = ("零", "一", "二", "三", "四", "五", "六", "七", "八", "九")

  let underTenThousand(num) = {
    if num < 1 {
      str(num)
    } else {
      let units = ((1000, "千"), (100, "百"), (10, "十"))
      let n = num
      let result = ""
      let needs-zero = false

      for unit in units {
        let base = unit.at(0)
        let unit-name = unit.at(1)
        let digit = calc.floor(n / base)
        n = n - digit * base

        if digit > 0 {
          if needs-zero {
            result = result + "零"
          }

          if not (base == 10 and digit == 1 and result == "") {
            result = result + digits.at(digit)
          }
          result = result + unit-name
          needs-zero = false
        } else if result != "" and n > 0 {
          needs-zero = true
        }
      }

      if n > 0 {
        if needs-zero {
          result = result + "零"
        }
        result = result + digits.at(n)
      }

      result
    }
  }

  if num < 1 {
    str(num)
  } else if num < 10000 {
    underTenThousand(num)
  } else if num < 100000000 {
    let high = calc.floor(num / 10000)
    let low = num - high * 10000
    let result = underTenThousand(high) + "万"

    if low > 0 {
      if low < 1000 {
        result = result + "零"
      }
      result = result + underTenThousand(low)
    }

    result
  } else {
    let high = calc.floor(num / 100000000)
    let low = num - high * 100000000
    let result = chineseNumMap(high) + "亿"

    if low > 0 {
      if low < 10000000 {
        result = result + "零"
      }
      result = result + chineseNumMap(low)
    }

    result
  }
}

#let romanNumMap(num) = {
  if num < 1 {
    str(num)
  } else {
    let values = (1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1)
    let symbols = ("M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I")
    let n = num
    let result = ""

    for i in range(values.len()) {
      let value = values.at(i)
      let symbol = symbols.at(i)

      while n >= value {
        result = result + symbol
        n = n - value
      }
    }

    result
  }
}

#let FONTSIZE = (
  ErHao: 22pt,
  SanHao: 16pt,
  XiaoSan: 15pt,
  SiHao: 14pt,
  XiaoSi: 12pt,
  WuHao: 10.5pt,
  XiaoWu: 9pt,
)

#let FONTSET = (
  English: "Times New Roman",
  // Hei: "SimHei",
  Hei: "Source Han Sans SC",
  // Song: "STSong",
  // Song: "SimSun",
  Song: "Source Han Serif SC",
  Kai: "STKaiti",
  // Mono: "Cascadia Mono",
  Mono: "Consolas",
)

#let tableCounter = counter("Table")
#let figureCounter = counter("Figure")
#let equationCounter = counter("Equation")

#let bupt-doc(
  titleZH: "",
  abstract: [],
  keywords: (),
  keyword-label: [关键词],
  body,
) = {
  set page(paper: "a4", margin: 2.5cm)
  set text(font: (FONTSET.at("English"), FONTSET.at("Song")).flatten(), weight: "regular", size: FONTSIZE.XiaoSi)
  set math.equation(numbering: "1")

  show math.equation.where(block: true): it => if it.fields().keys().contains("label") {
    context {
      set math.equation(numbering: none)
      set par(leading: 1.5em)
      let levels = counter(heading).at(here())
      let chapterLevel = if levels.len() > 0 {
        levels.first()
      } else {
        0
      }

      grid(
        columns: (100pt, 1fr, 100pt),
        [],
        align(center, it.body),
        align(horizon + right)[
          #text(
            font: (FONTSET.at("English"), FONTSET.at("Song")).flatten(),
            [式（#chapterLevel\-#equationCounter.display()）],
          )
        ],
      )

      equationCounter.step()
    }
  } else {
    align(center, it.body)
  }

  show ref: it => if it.element != none and it.element.func() == math.equation {
    context {
      let loc = it.element.location()
      let levels = counter(heading).at(loc)
      let chapterLevel = if levels.len() > 0 {
        levels.first()
      } else {
        0
      }
      let equationNumber = counter("Equation").at(loc).first()

      [式（#chapterLevel\-#equationNumber）]
    }
  } else {
    it
  }

  show raw: set text(
    font: (FONTSET.at("Mono"), FONTSET.at("English"), FONTSET.at("Song")).flatten(),
    size: FONTSIZE.XiaoWu,
  )

  /* custom code block: use `style_lang`, such as `border_python` */
  show raw: it => {
    if it.lang != none and it.lang.contains("_") {
      let parts = it.lang.split("_")
      let style-prefix = parts.at(0)
      let lang = parts.slice(1).join("_")

      if style-prefix == "border" {
        block(
          stroke: 0.5pt,
          width: 100%,
          inset: 1em,
        )[
          #text[
            #if lang == "" {
              raw(it.text, block: true)
            } else {
              raw(it.text, lang: lang, block: true)
            }
          ]
        ]
      } else {
        it
      }
    } else {
      it
    }
  }

  /* 目录 */
  set page(
    footer: context {
      [
        #align(center)[
          #text(font: FONTSET.at("English"), size: FONTSIZE.XiaoWu)[
            // 这里默认了摘要只有 2 页，根据实际情况修改
            #romanNumMap(counter(page).at(here()).at(0))
          ]
        ]
      ]
    },
  )
  counter(page).update(1)

  let has-abstract = abstract != []
  let has-keywords = keywords.len() > 0

  if has-abstract or has-keywords {
    set par(first-line-indent: 0em, leading: 1.5em)

    if titleZH != "" {
      align(center)[
        #text(font: FONTSET.at("Hei"), weight: "semibold", size: FONTSIZE.SanHao, titleZH)
      ]
      v(1em)
    }

    if has-abstract {
      align(center)[
        #text(font: FONTSET.at("Hei"), weight: "semibold", size: FONTSIZE.SanHao)[摘要]
      ]
      v(1em)
      set par(first-line-indent: 2em, justify: true)
      abstract
    }

    if has-keywords {
      v(1em)
      set par(first-line-indent: 0em, justify: true)
      text(font: FONTSET.at("Hei"), weight: "semibold", keyword-label)
      h(1em)
      text(keywords.join("  "))
    }

    pagebreak()
  }

  show outline: it => {
    align(center)[
      #text(font: FONTSET.at("Hei"), weight: "semibold", tracking: 2em, size: FONTSIZE.SanHao, [目录\ \ ])
    ]

    it
  }

  show outline.entry.where(
    level: 1,
  ): set text(font: (FONTSET.at("Hei")), size: FONTSIZE.XiaoSi, weight: "semibold")

  outline(title: none, depth: 4, indent: auto)

  /* 章节标题配置 */
  set heading(numbering: "1.1")
  show heading: it => context {
    let levels = counter(heading).at(here())

    set par(first-line-indent: 0em)
    set text(font: FONTSET.at("Hei"), weight: "semibold")

    if it.level == 1 {
      tableCounter.update(1)
      figureCounter.update(1)
      equationCounter.update(1)

      align(left)[
        #grid(
          rows: 1em,
          row-gutter: 0.2em,
          columns: 1fr,
          [],
          text(size: FONTSIZE.SanHao, [#chineseNumMap(levels.at(0))、#it.body]),
        )
      ]
    } else if it.level == 2 {
      grid(
        rows: (0.25em, 1em, 0.25em),
        columns: 1fr,
        [],
        [
          #numbering("1.1", ..levels)
          #text(size: FONTSIZE.SiHao, h(1em) + it.body)
        ],
        []
      )
    } else {
      // level >= 3
      grid(
        rows: (0.5em, 1em, 0.5em),
        columns: 1fr,
        [], [
          #numbering("1.1", ..levels)
          #text(size: FONTSIZE.XiaoSi, h(1em) + it.body)
        ],
        []
      )
    }
  }

  /* 引用 */
  show cite: it => {
    text(font: FONTSET.at("English"), it)
  }

  /* 页眉页脚 */
  set page(
    header: [
      #align(center)[
        #pad(bottom: -8pt)[
          #pad(
            bottom: -8pt,
            text(font: FONTSET.at("Song"), size: FONTSIZE.XiaoWu, titleZH),
          )
          #line(length: 100%, stroke: 0.5pt)
        ]
      ]
    ],
    footer: context {
      align(center)[
        #text(font: FONTSET.at("English"), size: FONTSIZE.XiaoWu)[
          #counter(page).display()
        ]
      ]
    },
  )
  counter(page).update(1)

  body
}

#let PrimaryHeading(
  title,
) = {
  grid(
    columns: 1fr,
    row-gutter: 0.2em,
    rows: (1em, 1em, 1em),
    [], [#title], []
  )
}

/* 引用块，同 Markdown 中的 `>` */
#let blockquote(body) = {
  block(
    stroke: (left: 0.25em + rgb("#d0d7de")),

    inset: (left: 1em, y: 0.6em),

    spacing: 1.2em,

    width: 100%,

    text(fill: rgb("#656d76"), body),
  )
}

#let EnumStyles = (
  "num-dot": "1.", // 1.
  "num-paren": "(1)", // (1)
  "num-paren-zh": "（1）", // （1）
  "num-rparen": "1)", // 1)
  "num-rparen-zh": "1）", // 1）
  "num-bracket": "[1]", // [1]
  "num-circle": "①", // ①
  "alpha-dot": "a.", // a.
  "alpha-paren": "(a)", // (a)
  "alpha-rparen": "a)", // a)
  "roman-dot": "I.", // I.
  "roman-lower-dot": "i.", // i.
)

#let CustomList(
  body,
  style: EnumStyles.num-paren,
) = {
  set enum(numbering: style)
  body
}

/* 附录 */
#let Appendix(
  bibliographyFile: none,
  body,
) = {
  show heading: it => context {
    set par(first-line-indent: 0em)

    let levels = counter(heading).at(here())

    if it.level == 1 {
      align(center)[
        #text(font: FONTSET.at("Hei"), size: FONTSIZE.SanHao, it.body)
      ]
    } else if it.level == 2 {
      text(size: FONTSIZE.SiHao, it.body)
    }
  }

  if bibliographyFile != none {
    pagebreak()
    PrimaryHeading([= 参考文献])

    set text(
      font: (FONTSET.at("English"), FONTSET.at("Song")).flatten(),
      size: FONTSIZE.WuHao,
      lang: "zh",
    )
    set par(first-line-indent: 0em)
    bibliography(
      bibliographyFile,
      title: none,
      style: "gb-7714-2015-numeric",
    )
    show bibliography: it => {}
  }

  body
}

/* 图: figure with Chinese caption */
#let figureCC(
  content,
  caption,
  height: auto,
  width: 100%,
) = block(breakable: false, width: 100%)[
  #context {
    let chapterLevel = counter(heading).get().first()
    let figureBody = if type(content) == str {
      image(content, height: height, width: width)
    } else {
      content
    }

    align(center)[
      #figureBody
      #text(
        font: (FONTSET.at("English"), FONTSET.at("Kai")).flatten(),
        size: FONTSIZE.WuHao,
        [图 #chapterLevel\-#figureCounter.display() #caption],
      )
    ]
  }

  #figureCounter.step()
]

/* 表格 */
#let Table(caption, columnsSet, alignSet, inset: 8pt, breakable: false, ..cells) = block(
  breakable: breakable,
  width: 100%,
)[
  #context {
    let chapterLevel = counter(heading).get().first()
    align(center)[
      #text(
        font: (FONTSET.at("English"), FONTSET.at("Kai")).flatten(),
        size: FONTSIZE.WuHao,
      )[表 #chapterLevel\-#tableCounter.display() #caption]
    ]
  }

  #tableCounter.step()

  #align(center)[
    #set text(size: FONTSIZE.WuHao)

    #table(
      columns: columnsSet,
      align: alignSet,
      inset: inset,
      stroke: none,

      table.hline(y: 0, stroke: 1.5pt),
      table.hline(y: 1, stroke: 0.5pt),
      ..cells,
      table.hline(stroke: 1.5pt),
    )
  ]
]

#let booktabs_table(
  caption: "",
  columns: (auto,),
  align: left,
  header_rows: 1,
  ..cells,
) = {
  // Style the caption to be at the top and formatted correctly
  show figure.where(kind: table): set figure.caption(position: top, separator: ": ")

  // Define the table inside a figure for auto-numbering and referencing
  figure(
    caption: caption,
    kind: table,
    supplement: [Table],
    block(width: auto, {
      table(
        columns: columns,
        align: align,
        stroke: none, // Disable all default borders
        inset: (x: 0.8em, y: 0.5em), // Professional padding

        // Top Rule
        table.hline(y: 0, stroke: 1.5pt),

        // The Cells
        ..cells,

        // Bottom Rule
        table.hline(stroke: 1.5pt),
      )
    }),
  )
}

#let today = datetime.today()
