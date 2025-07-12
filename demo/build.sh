#!/bin/bash

echo "SOCKS5代理服务器打包脚本"
echo "================================"

VERSION="1.0.0"
APP_NAME="socks5-server"

# 清理旧的构建文件
echo "正在清理旧的构建文件..."
rm -rf dist
mkdir -p dist

echo "开始编译..."

# 编译 Windows x64 版本
echo "[1/6] 编译 Windows x64 版本..."
GOOS=windows GOARCH=amd64 go build -ldflags "-s -w -X main.Version=$VERSION" -o dist/${APP_NAME}-windows-amd64.exe .
if [ $? -ne 0 ]; then
    echo "编译 Windows x64 版本失败！"
    exit 1
fi

# 编译 Windows x86 版本
echo "[2/6] 编译 Windows x86 版本..."
GOOS=windows GOARCH=386 go build -ldflags "-s -w -X main.Version=$VERSION" -o dist/${APP_NAME}-windows-386.exe .
if [ $? -ne 0 ]; then
    echo "编译 Windows x86 版本失败！"
    exit 1
fi

# 编译 Linux x64 版本
echo "[3/6] 编译 Linux x64 版本..."
GOOS=linux GOARCH=amd64 go build -ldflags "-s -w -X main.Version=$VERSION" -o dist/${APP_NAME}-linux-amd64 .
if [ $? -ne 0 ]; then
    echo "编译 Linux x64 版本失败！"
    exit 1
fi

# 编译 Linux ARM64 版本
echo "[4/6] 编译 Linux ARM64 版本..."
GOOS=linux GOARCH=arm64 go build -ldflags "-s -w -X main.Version=$VERSION" -o dist/${APP_NAME}-linux-arm64 .
if [ $? -ne 0 ]; then
    echo "编译 Linux ARM64 版本失败！"
    exit 1
fi

# 编译 macOS x64 版本
echo "[5/6] 编译 macOS x64 版本..."
GOOS=darwin GOARCH=amd64 go build -ldflags "-s -w -X main.Version=$VERSION" -o dist/${APP_NAME}-darwin-amd64 .
if [ $? -ne 0 ]; then
    echo "编译 macOS x64 版本失败！"
    exit 1
fi

# 编译 macOS ARM64 版本
echo "[6/6] 编译 macOS ARM64 版本..."
GOOS=darwin GOARCH=arm64 go build -ldflags "-s -w -X main.Version=$VERSION" -o dist/${APP_NAME}-darwin-arm64 .
if [ $? -ne 0 ]; then
    echo "编译 macOS ARM64 版本失败！"
    exit 1
fi

echo ""
echo "复制配置文件到dist目录..."
cp config.json dist/
cp config.example.json dist/
cp README.md dist/

echo ""
echo "创建发布包..."

# 创建 Windows 发布包
echo "创建 Windows 发布包..."
cd dist
zip -r socks5-server-windows-${VERSION}.zip \
    socks5-server-windows-amd64.exe \
    socks5-server-windows-386.exe \
    config.json \
    config.example.json \
    README.md

# 创建 Linux 发布包
echo "创建 Linux 发布包..."
zip -r socks5-server-linux-${VERSION}.zip \
    socks5-server-linux-amd64 \
    socks5-server-linux-arm64 \
    config.json \
    config.example.json \
    README.md

# 创建 macOS 发布包
echo "创建 macOS 发布包..."
zip -r socks5-server-darwin-${VERSION}.zip \
    socks5-server-darwin-amd64 \
    socks5-server-darwin-arm64 \
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
echo "发布包:"
ls -la dist/*.zip
echo ""
echo "版本: $VERSION"
echo "构建时间: $(date)"
echo "================================" 