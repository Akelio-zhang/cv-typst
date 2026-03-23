# 变量定义
default_lang := "zh"
default_output := "concise"

# 默认构建
default:
    @just compile {{default_lang}} {{default_output}}

# 通用编译命令
compile lang output:
    typst compile --input la={{lang}} --input output={{output}} cv.typ cv_{{lang}}_{{output}}.pdf
    @echo "✓ Generated cv_{{lang}}_{{output}}.pdf"

# 快捷命令
zh:
    @just compile zh concise

zh-full:
    @just compile zh full

en:
    @just compile en concise

en-full:
    @just compile en full

# 编译所有变体
all:
    @just zh
    @just zh-full
    @just en
    @echo "✓ All variants generated"

# 清理生成的 PDF
clean:
    rm -f cv*.pdf
    @echo "✓ Cleaned PDF files"

# 查看可用字体
fonts:
    typst fonts | head -20
