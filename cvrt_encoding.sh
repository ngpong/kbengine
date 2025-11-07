#!/bin/bash
# 批量将 C/C++ 文件（GBK/GB2312/GB18030/ASCII）转换为 UTF-8
# 依赖：uchardet、iconv

LOG_FILE="./convert_log.txt"
> "$LOG_FILE"  # 清空旧日志

# 只匹配 C/C++ 文件类型
find . -type f \( \
    -iname "*.c" -o -iname "*.cpp" -o -iname "*.h" -o -iname "*.hpp" -o \
    -iname "*.cc" -o -iname "*.cxx" \
\) | while read -r f; do
    # 检测编码
    enc=$(uchardet "$f" 2>/dev/null | tr '[:upper:]' '[:lower:]')

    # 判断是否需要转换
    case "$enc" in
        gb18030|gbk|gb2312|ascii)
            echo "Converting: $f ($enc → utf-8)"
            tmp="${f}.tmp"
            if iconv -f "$enc" -t utf-8 "$f" -o "$tmp" 2>/dev/null; then
                mv "$tmp" "$f"
                echo "$f: $enc --> utf-8" >> "$LOG_FILE"
            else
                echo "❌ Failed to convert: $f ($enc)" | tee -a "$LOG_FILE"
                rm -f "$tmp"
            fi
            ;;
        *)
            # 不需要转换的文件不记录日志
            :
            ;;
    esac
done

echo "✅ Conversion complete. Log saved to $LOG_FILE"
