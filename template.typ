#let chineseNumMap(num) = {
  let chineseNum = (
    "一",
    "二",
    "三",
    "四",
    "五",
    "六",
    "七",
    "八",
    "九",
    "十",
    "十一",
    "十二",
    "十三",
    "十四",
    "十五",
    "十六",
    "十七",
    "十八",
    "十九",
    "二十",
    "二十一",
    "二十二",
    "二十三",
    "二十四",
    "二十五",
    "二十六",
    "二十七",
    "二十八",
    "二十九",
    "三十",
    "三十一",
    "三十二",
    "三十三",
    "三十四",
    "三十五",
    "三十六",
    "三十七",
    "三十八",
    "三十九",
    "四十",
  )
  chineseNum.at(num - 1)
}

#let romanNumMap(num) = {
  let romanNum = (
    "I",
    "II",
    "III",
    "IV",
    "V",
    "VI",
    "VII",
    "VIII",
    "IX",
    "X",
    "XI",
    "XII",
    "XIII",
    "XIV",
    "XV",
    "XVI",
    "XVII",
    "XVIII",
    "XIX",
    "XX",
    "XXI",
    "XXII",
    "XXIII",
    "XXIV",
    "XXV",
    "XXVI",
    "XXVII",
    "XXVIII",
    "XXIX",
    "XXX",
    "XXXI",
    "XXXII",
    "XXXIII",
    "XXXIV",
    "XXXV",
    "XXXVI",
    "XXXVII",
    "XXXVIII",
    "XXXIX",
    "XL",
  )
  romanNum.at(num - 1)
}

#let FONTSIZE = (
  SanHao: 16pt,
  XiaoSan: 15pt,
  SiHao: 14pt,
  XiaoSi: 12pt,
  WuHao: 10.5pt,
  XiaoWu: 9pt,
)

#let FONTSET = (
  English: "Times New Roman",
  Hei: "Source Han Sans SC",
  Song: "STSong",
  // Song:    "Source Han Serif SC",
  Kai: "STKaiti",
)

#let tableCounter = counter("Table")
#let figureCounter = counter("Figure")
#let equationCounter = counter("Equation")

#let bupt-doc(
  titleZH: "",
  body,
) = {
  set page(paper: "a4", margin: 2.5cm)
  set text(font: (FONTSET.at("English"), FONTSET.at("Song")).flatten(), weight: "regular", size: FONTSIZE.XiaoSi)

  show math.equation: it => if it.fields().keys().contains("label") {
    context {
      set par(leading: 1.5em)
      let chapterLevel = counter(heading).at(here()).at(0)

      grid(
        columns: (100pt, 1fr, 100pt),
        [],
        align(center, it),
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
    it
  }

  /* custom code block: suppose lang does not include `_` */
  show raw: it => {
    if it.lang != none and it.lang.contains("_") {
      let parts = it.lang.split("_")
      let style-prefix = parts.at(0)
      let lang = parts.at(1)

      if style-prefix == "border" {
        block(
          stroke: 0.5pt,
          width: 100%,
          inset: 1em,
        )[
          #show raw: set text(
            font: ("Hack Nerd Font Mono", FONTSET.at("English"), FONTSET.at("Song")).flatten(),
            size: FONTSIZE.XiaoWu,
          )
          #text[
            #raw(it.text, lang: lang, block: true)
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

/* 全角括号有序列表 */
#let FullWidthParenList(content) = {
  set enum(numbering: "（1）")
  content
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
  #show figure: it => context {
    let chapterLevel = counter(heading).get().first()

    align(center)[
      #it.body
      #text(
        font: (FONTSET.at("English"), FONTSET.at("Kai")).flatten(),
        size: FONTSIZE.WuHao,
        [图 #chapterLevel\-#figureCounter.display() #caption],
      )
    ]

    figureCounter.step()
  }

  #figure(image(content, height: height, width: width))
]

/* 表格 */
#let Table(caption, columnsSet, alignSet, inset: 8pt, breakable: false, body) = block(
  breakable: breakable,
  width: 100%,
)[
  #show table: it => context {
    let chapterLevel = counter(heading).get().first()

    align(center)[
      #text(
        font: (FONTSET.at("English"), FONTSET.at("Kai")).flatten(),
        size: FONTSIZE.WuHao,
        [表 #chapterLevel\-#tableCounter.display() #caption],
      )
      #it
    ]

    tableCounter.step()
  }

  #table(
    columns: columnsSet,
    align: alignSet,
    inset: inset,
    stroke: 0.5pt,
    ..body
  )
]
