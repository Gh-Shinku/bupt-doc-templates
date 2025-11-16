# 北京邮电大学小论文/报告模板

本模板在 [北京邮电大学本科学士学位论文模板](https://github.com/QQKdeGit/bupt-typst) 的基础上修改而来。

各种基础注意事项请参照原 repo。

我认为课程报告算不上有多正式，但鉴于 word 在排版上的不便性与 Latex 的历史包袱，转而选择 Typst 作为排版工具。

> 排版圆神，启动！

## function list

### 多样式代码块
当前模板中只定义了 border style 的代码块，可以通过如下方式调用：

````typst
```border_c
#include <stdio.h>
int main() {
    printf("Hello, world!");
    return 0;
}
```
````

用"```"创建的代码块会调用 `raw` 函数，并带有 `lang` 参数，通过在 `lang` 中嵌入样式信息可实现 style 的区分。
