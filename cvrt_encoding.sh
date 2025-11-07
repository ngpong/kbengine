#!/bin/bash
# 将所有编码为 ISO-8859-1 的文件从 GBK 转成 UTF-8

find . -type f | while read -r f; do
    enc=$(file -bi "$f" | sed -n "s/.*charset=//p")
    if [ "$enc" = "iso-8859-1" ]; then
        echo "Converting: $f ($enc → utf-8)"
        tmp="${f}.tmp"
        if iconv -f GBK -t UTF-8 "$f" -o "$tmp"; then
            mv "$tmp" "$f"
        else
            echo "❌ Failed to convert: $f"
            rm -f "$tmp"
        fi
    fi
done
