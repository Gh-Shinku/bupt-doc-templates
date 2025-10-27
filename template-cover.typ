#let FONTSIZE = (
  ErHao: 22pt,
  SanHao: 16pt,
  XiaoSan: 15pt,
  SiHao: 14pt,
  XiaoSi: 12pt,
  WuHao: 10.5pt,
  XiaoWu: 9pt,
)

#let buildMainHeader(mainHeadingContent) = {
  [
    #align(center, smallcaps(mainHeadingContent))
    #line(length: 100%)
  ]
}

#let buildSecondaryHeader(mainHeadingContent, secondaryHeadingContent) = {
  [
    #smallcaps(mainHeadingContent) #h(1fr) #emph(secondaryHeadingContent)
    #line(length: 100%)
  ]
}

// To know if the secondary heading appears after the main heading
#let isAfter(secondaryHeading, mainHeading) = {
  let secHeadPos = secondaryHeading.location().position()
  let mainHeadPos = mainHeading.location().position()
  if (secHeadPos.at("page") > mainHeadPos.at("page")) {
    return true
  }
  if (secHeadPos.at("page") == mainHeadPos.at("page")) {
    return secHeadPos.at("y") > mainHeadPos.at("y")
  }
  return false
}

#let getHeader() = {
  locate(loc => {
    // Find if there is a level 1 heading on the current page
    let nextMainHeading = query(heading.where(level: 1).after(loc), loc).find(headIt => {
      headIt.location().page() == loc.page()
    })
    if (nextMainHeading != none) {
      return buildMainHeader(nextMainHeading.body)
    }
    // Find the last previous level 1 heading -- at this point surely there's one :-)
    let lastMainHeading = query(heading.where(level: 1).before(loc), loc).last()

    // Find if the last level > 1 heading in previous pages
    let previousSecondaryHeadingArray = query(heading.before(loc), loc).filter(headIt => {
      headIt.level > 1
    })
    let lastSecondaryHeading = if (previousSecondaryHeadingArray.len() != 0) {
      previousSecondaryHeadingArray.last()
    } else { none }
    // Find if the last secondary heading exists and if it's after the last main heading
    if (lastSecondaryHeading != none and isAfter(lastSecondaryHeading, lastMainHeading)) {
      return buildSecondaryHeader(lastMainHeading.body, lastSecondaryHeading.body)
    }
    return buildMainHeader(lastMainHeading.body)
  })
}

#let project(
  title: "",
  abstract: [],
  author: "",
  authors: (),
  info: (),
  logo: none,
  date: " 年 月 日",
  body,
) = {
  // Set the document's basic properties.
  set document(author: author, title: title)
  set text(font: "FZXiaoBiaoSong-B05S", lang: "zh") // 方正小标宋简体
  show math.equation: set text(weight: 400)
  set heading(numbering: "1.1")
  set par(justify: true)

  // Logo
  if logo != none {
    v(1.2cm)
    align(center, image(logo, width: 60%))
  } else {
    v(0.75fr)
  }

  // Title
  v(1cm)
  align(center)[
    #set text(FONTSIZE.ErHao, weight: 700)
    #set par(leading: 1.5em)
    #text(title)
  ]
  v(0.9fr)

  // Author information
  pad(
    top: 1em,
    bottom: 1cm,
    grid(
      columns: 1fr,
      gutter: 1em,
      align(center)[
        #set text(font: ("Times New Roman", "STKaiti"), size: FONTSIZE.SanHao)
        #let myunderline(body) = context {
          let w = measure(body).width
          underline(
            extent: (21em - w) / 2,
            stroke: 0.3pt,
            offset: 3pt,
            evade: false,
            box(width: 21em, body),
          )
        }
        #grid(
          columns: (auto, 21em),
          column-gutter: 0.7em,
          row-gutter: 0.7cm,
          ..info.map(i => ([#i.at(0)：], [#myunderline(i.at(1))])).flatten()
        )
      ],
    ),
  )


  align(center)[
    #text(font: ("Times New Roman", "STKaiti"), size: 16pt, date)
  ]

  pagebreak()

  body
}
