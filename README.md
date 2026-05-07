# 北京邮电大学小论文/报告模板

本模板在 [北京邮电大学本科学士学位论文模板](https://github.com/QQKdeGit/bupt-typst) 的基础上修改而来。

各种基础注意事项请参照原 repo。

我认为课程报告算不上有多正式，但鉴于 word 在排版上的不便性与 Latex 的历史包袱，转而选择 Typst 作为排版工具。

> 排版圆神，启动！

## 用法 / Usage

### 快速开始

1. 将本仓库克隆或下载到本地。
2. 复制 `main.typ` 作为起点，或参考下方说明自行编写文档。

### 基本结构

每个文档由三部分组成：导入 → 封面 → 正文 → 附录。最小示例如下：

```typst
#import "template.typ": *
#import "template-cover.typ": project

// 封面
#show: project.with(
  title: "实验报告标题",
  logo: "images/bupt-badge-binary.png",
  info: (
    ("题目", "你的题目"),
    ("姓名", "张三"),
    ("学号", "2024000001"),
    ("班级", "2024111100"),
  ),
  date: today.display("[year] 年 [month] 月 [day] 日"),
)

// 正文模板
#show: bupt-doc.with(
  titleZH: "实验报告标题",
)

// 正文内容
= 第一章

...内容...

= 第二章

...内容...

// 附录（参考文献）
#show: Appendix.with(
  bibliographyFile: "reference.yml",
)
```

### 封面配置

`project` 函数参数：

| 参数 | 说明 |
|------|------|
| `title` | 报告标题 |
| `logo` | 校徽图片路径 |
| `info` | 信息表格，格式为 `(("键", "值"), ...)` 的数组 |
| `date` | 日期，可直接用 `today.display(...)` |

### 正文配置

`bupt-doc` 函数参数：

| 参数 | 说明 |
|------|------|
| `titleZH` | 中文标题，会显示在页眉中 |

### 功能一览

#### 图片

使用 `figureCC` 插入带自动编号的图片：

```typst
#figureCC(
  "images/your-image.png",
  [图片题注],
  width: 80%,
)
```

#### 表格

**标准表格**（上粗下细三线表）：

```typst
#Table(
  "表格题注",
  (1fr, 1fr, 1fr),
  center,
  [*列1*], [*列2*], [*列3*],
  [A], [B], [C],
  [1], [2], [3],
)
```

**booktabs 风格表格**（支持复杂表头）：

```typst
#booktabs_table(
  caption: [表格题注],
  columns: (auto, 1.5fr, 1fr),
  align: (left, left, left),
  table.cell(colspan: 2, align: center)[Part],
  [],
  table.hline(y: 1, start: 0, end: 2, stroke: 0.5pt),
  [*Name*], [*Description*], [*Size*],
  table.hline(y: 2, stroke: 0.5pt),
  [Dendrite], [Input terminal], [$~100$],
  [Axon], [Output terminal], [$~10$],
)
```

#### 公式

数学公式自动按章节编号：

```typst
$ E = m c^2 $ <eq:relativity>
$ e^(i pi) + 1 = 0 $ <eq:euler>
```

#### 代码块

标准代码高亮：

````typst
```python
def hello():
    print("Hello, Typst!")
```
````

边框样式（在语言名前加 `border_` 前缀）：

````typst
```border_python
def hello():
    print("Hello, Border!")
```
````

#### 自定义列表

使用 `CustomList` 控制列表编号样式：

```typst
#CustomList(style: EnumStyles.num-dot)[
  + 第一项
    #CustomList(style: EnumStyles.num-circle)[
      + 子项一
      + 子项二
    ]
  + 第二项
]
```

可用的 `EnumStyles` 样式参考 `template.typ:EnumStyles`。

#### 引用块

```typst
#blockquote[
  这是一个引用块示例，左侧有竖线标识。
]
```

#### 参考文献

在正文中使用 `@key` 引用，附录中使用 `Appendix` 渲染：

```typst
// 正文中引用
参见文献 @my_ref 。

// 文档末尾
#show: Appendix.with(
  bibliographyFile: "reference.yml",
)
```

支持 `.yml` 和 `.bib` 格式的参考文献文件，引用格式为 **GB/T 7714-2015 numeric**。
