#!/bin/bash

# ログを保存するディレクトリ
LOG_DIR="logs"
mkdir -p "$LOG_DIR"

# タイムスタンプを取得
TIMESTAMP=$(date "+%Y%m%d_%H%M%S")
LOG_FILE="$LOG_DIR/docker_build_$TIMESTAMP.log"

echo "Dockerビルドを開始します。ログは $LOG_FILE に保存されます..."

# ビルドコマンドを実行し、出力をターミナルに表示しながらログファイルにも保存
docker compose build 2>&1 | tee "$LOG_FILE"

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo "ビルドが正常に完了しました。ログは $LOG_FILE に保存されました。"
else
    echo "ビルドに失敗しました。詳細は $LOG_FILE を確認してください。"
fi
