#import "template.typ": *
#import "template-cover.typ": project
#import "@preview/itemize:0.2.0" as el
#show: el.default-enum-list

#show: project.with(
  title: "模板样式测试",
  logo: "images/bupt-badge-binary.png",
  info: (
    ("题目", "模板样式测试"),
    ("姓名", "张三"),
    ("学号", "1281890421"),
    ("班级", "1232144222"),
  ),
  date: today.display("[year] 年 [month] 月 [day] 日"),
)

#show: bupt-doc.with(
  titleZH: "模板样式测试",
  abstract: [
    这是摘要样式测试文本。摘要段落用于检查中文正文、英文 mixed text、数字 12345、行距和首行缩进效果。
  ],
  keywords: ("模板", "样式", "Typst"),
)

= 一级标题样式

正文段落样式测试。中文、English words、数字 12345、标点符号，以及较长文本用于检查默认字号、行距、首行缩进和页面宽度下的换行效果。

数字映射测试：#chineseNumMap(1)、#chineseNumMap(10)、#chineseNumMap(11)、#chineseNumMap(20)、#chineseNumMap(41)、#chineseNumMap(101)、#chineseNumMap(1001)；#romanNumMap(1)、#romanNumMap(4)、#romanNumMap(9)、#romanNumMap(40)、#romanNumMap(41)、#romanNumMap(99)。

== 二级标题样式

=== 三级标题样式

==== 四级标题样式

多级标题后的正文段落测试。

== 列表样式

#CustomList(style: EnumStyles.num-dot)[
  + 一级有序项
    #CustomList(style: EnumStyles.num-circle)[
      + 嵌套有序项
      + 嵌套有序项
    ]
  + 一级有序项
    #CustomList(style: EnumStyles.num-rparen-zh)[
      + 中文右括号编号
      + 中文右括号编号
    ]
]

== 引用块样式

#blockquote[
  引用块样式测试。该块用于检查左侧竖线、内边距、文字颜色和段落宽度。
]

= 图表与公式样式

== 图片样式

#figureCC(
  "images/夜明けと蛍.png",
  [普通图片题注],
  width: 80%,
)

#figureCC(
  rect(
    stroke: 0.5pt + gray,
    inset: 6pt,
    block(width: 60%, height: 40pt)[wrapped content],
  ),
  "wrapped content 图题",
)

== 表格样式

#Table(
  "三线表示例",
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
  caption: [Booktabs table title],
  columns: (auto, 1.5fr, 1fr),
  align: (left, left, left),
  table.cell(colspan: 2, align: center)[Part],
  [],
  table.hline(y: 1, start: 0, end: 2, stroke: 0.5pt),
  [*Name*],
  [*Description*],
  [*Size ($mu$m)*],
  table.hline(y: 2, stroke: 0.5pt),
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

== 公式样式

$ E = m c^2 $ <eq:relativity>

$ e^(i pi) + 1 = 0 $ <eq:euler>

公式引用：@eq:relativity，@eq:euler。

$ a + b = c $

$ x + y = z $ <eq:compat-test>

兼容性公式引用：@eq:compat-test。

= 代码与引用样式

== 代码块样式

```python
def hello():
    print("Hello, Typst!")
```

```border_python
def hello_with_border():
    print("Hello, Border!")
```

```border_
print("border without language")
```

```abc_def_ghi
print("unknown style fallback")
```

== 参考文献样式

文献引用测试：@cn_ref，@webster_social_media。

#show: Appendix.with(
  bibliographyFile: "reference.yml",
)
