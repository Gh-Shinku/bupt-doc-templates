#import "template.typ": *
#import "template-cover.typ": project
#import "@preview/itemize:0.2.0" as el
#show: el.default-enum-list

#show: project.with(
  title: "标题",
  logo: "images/bupt-badge-binary.png",
  info: (
    ("题目", "题目"),
    ("姓名", "张三"),
    ("学号", "1281890421"),
    ("班级", "1232144222"),
  ),
  date: "2099 年 99 月 99 日",
)

#show: bupt-doc.with(
  titleZH: "题目",
)


// 正文
= 模板功能演示

本模板旨在提供 BUPT 实验报告的 Typst 模板。

== 字体与排版

本模板预设了符合中文排版习惯的字体设置：
- 中文主要使用 *Source Han Serif SC* (思源宋体)。
- 英文主要使用 *Times New Roman*。
- 标题使用 *Source Han Sans SC* (思源黑体)。
- 代码块使用 *Hack Nerd Font Mono*。

正文默认字号为小四 (12pt)，行间距适中。

== 列表样式

除了标准的无序列表和有序列表外，本模板还提供了一种全角括号的有序列表样式：

#FullWidthParenList[
  + 第一项
  + 第二项
  + 第三项
]

== 引用块

可以使用 `blockquote` 函数来实现类似 Markdown 中 `>` 的引用块效果：

#blockquote[
  这是一个引用块示例。它左侧有一条竖线，背景色略有不同，用于突出显示引用的内容。
]

== 图表与公式

本模板实现了按章节编号的图、表和公式。

=== 图片

使用 `figureCC` 函数插入图片，题注会自动包含章节号：

#figureCC(
  "images/夜明けと蛍.png",
  [夜明けと蛍],
  width: 80%,
)

=== 表格

使用 `Table` 函数插入表格，题注同样包含章节号：

#Table(
  "示例表格",
  (1fr, 1fr, 1fr),
  center,
  [*列1*],
  [*列2*],
  [*列3*],
  [A],
  [B],
  [C],
  [1],
  [2],
  [3],
)

#booktabs_table(
  caption: [Sample table title],
  columns: (auto, 1.5fr, 1fr),
  align: (left, left, left),
  // Row 0: The spanning header
  table.cell(colspan: 2, align: center)[Part],
  [], // Empty cell above "Size"

  // Partial line under "Part" (from column 0 to 2)
  table.hline(y: 1, start: 0, end: 2, stroke: 0.5pt),

  // Row 1: The sub-headers
  [*Name*],
  [*Description*],
  [*Size ($mu$m)*],

  // Main separator under the full header
  table.hline(y: 2, stroke: 0.5pt),

  // Data Rows
  [Dendrite],
  [Input terminal],
  [$~100$],
  [Axon],
  [Output terminal],
  [$~10$],
  [Soma],
  [Cell body],
  [up to $10^6$],
)

=== 公式

数学公式会自动编号，格式为“式（章节号-序号）”：

$ E = m c^2 $ <eq:relativity>

$ e^(i pi) + 1 = 0 $ <eq:euler>

公式会自动在右侧显示编号。

== 代码块

支持标准的代码块高亮：

```python
def hello():
    print("Hello, Typst!")
```

此外，通过在语言名称前加上 `border_` 前缀，可以给代码块添加边框：

```border_python
def hello_with_border():
    print("Hello, Border!")
```

== 参考文献

这是一个参考文献 @cn_ref 的引用 @webster_social_media 。

// 附页
#show: Appendix.with(
  bibliographyFile: "reference.yml",
)
