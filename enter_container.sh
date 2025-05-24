#!/bin/bash

# コンテナが実行中かチェック
CONTAINER_NAME="ros2-humble"
CONTAINER_RUNNING=$(docker ps -q -f name=${CONTAINER_NAME})

if [ -z "${CONTAINER_RUNNING}" ]; then
    echo "コンテナ ${CONTAINER_NAME} が実行されていません。起動します..."
    docker compose up -d
    # コンテナの起動を少し待つ
    sleep 2
fi

# コンテナに入る
echo "コンテナ ${CONTAINER_NAME} に接続しています..."
docker exec -it ${CONTAINER_NAME} bash
