#!/bin/bash

echo "SOCKS5代理服务器简化打包脚本"
echo "================================"

VERSION="1.0.0"
APP_NAME="socks5-server"

# 清理旧的构建文件
echo "正在清理旧的构建文件..."
rm -rf dist
mkdir -p dist

echo "开始编译当前平台版本..."

go build -ldflags "-s -w -X main.Version=$VERSION" -o dist/${APP_NAME} .
if [ $? -ne 0 ]; then
    echo "编译失败！"
    exit 1
fi

echo ""
echo "复制配置文件到dist目录..."
cp config.json dist/
cp config.example.json dist/
cp README.md dist/

echo ""
echo "创建发布包..."
cd dist
zip -r socks5-server-${VERSION}.zip \
    socks5-server \
    config.json \
    config.example.json \
    README.md
cd ..

echo ""
echo "================================"
echo "打包完成！"
echo ""
echo "生成的文件:"
ls -la dist/
echo ""
echo "版本: $VERSION"
echo "构建时间: $(date)"
echo "================================" 