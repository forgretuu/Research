#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE="$SCRIPT_DIR/templates/daily.md"

# 日付: 引数があればそれを使用、なければ今日
if [ $# -ge 1 ]; then
    DATE="$1"
    # 日付フォーマット検証
    if ! date -j -f "%Y-%m-%d" "$DATE" "+%Y-%m-%d" >/dev/null 2>&1; then
        echo "エラー: 日付の形式が正しくありません (YYYY-MM-DD)" >&2
        exit 1
    fi
else
    DATE="$(date +%Y-%m-%d)"
fi

YEAR="$(echo "$DATE" | cut -d- -f1)"
MONTH="$(echo "$DATE" | cut -d- -f2)"

# 月から学期を判定
case "$MONTH" in
    01|02|03) SEMESTER="1S" ;;
    04|05|06) SEMESTER="2S" ;;
    07|08|09) SEMESTER="3S" ;;
    10|11|12) SEMESTER="4S" ;;
esac

DIR="$SCRIPT_DIR/daily/${YEAR}-${SEMESTER}"
FILE="$DIR/${DATE}.md"

if [ -f "$FILE" ]; then
    echo "既に存在します: $FILE"
    exit 0
fi

mkdir -p "$DIR"
sed "s/YYYY-MM-DD/$DATE/" "$TEMPLATE" > "$FILE"
echo "作成しました: $FILE"
