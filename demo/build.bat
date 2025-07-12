@echo off
chcp 65001 >nul
echo SOCKS5代理服务器打包脚本
echo ================================

set VERSION=1.0.0
set APP_NAME=socks5-server

echo 正在清理旧的构建文件...
if exist dist rmdir /s /q dist
mkdir dist

echo 开始编译...

echo [1/6] 编译 Windows x64 版本...
set GOOS=windows
set GOARCH=amd64
go build -ldflags "-s -w -X main.Version=%VERSION%" -o dist\%APP_NAME%-windows-amd64.exe .
if %ERRORLEVEL% neq 0 (
    echo 编译 Windows x64 版本失败！
    pause
    exit /b 1
)

echo [2/6] 编译 Windows x86 版本...
set GOOS=windows
set GOARCH=386
go build -ldflags "-s -w -X main.Version=%VERSION%" -o dist\%APP_NAME%-windows-386.exe .
if %ERRORLEVEL% neq 0 (
    echo 编译 Windows x86 版本失败！
    pause
    exit /b 1
)

echo [3/6] 编译 Linux x64 版本...
set GOOS=linux
set GOARCH=amd64
go build -ldflags "-s -w -X main.Version=%VERSION%" -o dist\%APP_NAME%-linux-amd64 .
if %ERRORLEVEL% neq 0 (
    echo 编译 Linux x64 版本失败！
    pause
    exit /b 1
)

echo [4/6] 编译 Linux ARM64 版本...
set GOOS=linux
set GOARCH=arm64
go build -ldflags "-s -w -X main.Version=%VERSION%" -o dist\%APP_NAME%-linux-arm64 .
if %ERRORLEVEL% neq 0 (
    echo 编译 Linux ARM64 版本失败！
    pause
    exit /b 1
)

echo [5/6] 编译 macOS x64 版本...
set GOOS=darwin
set GOARCH=amd64
go build -ldflags "-s -w -X main.Version=%VERSION%" -o dist\%APP_NAME%-darwin-amd64 .
if %ERRORLEVEL% neq 0 (
    echo 编译 macOS x64 版本失败！
    pause
    exit /b 1
)

echo [6/6] 编译 macOS ARM64 版本...
set GOOS=darwin
set GOARCH=arm64
go build -ldflags "-s -w -X main.Version=%VERSION%" -o dist\%APP_NAME%-darwin-arm64 .
if %ERRORLEVEL% neq 0 (
    echo 编译 macOS ARM64 版本失败！
    pause
    exit /b 1
)

echo.
echo 复制配置文件到dist目录...
copy config.json dist\
copy config.example.json dist\
copy README.md dist\

echo.
echo 创建发布包...
cd dist
echo 创建 Windows 发布包...
powershell Compress-Archive -Path "socks5-server-windows-amd64.exe", "socks5-server-windows-386.exe", "config.json", "config.example.json", "README.md" -DestinationPath "socks5-server-windows-%VERSION%.zip"

echo 创建 Linux 发布包...
powershell Compress-Archive -Path "socks5-server-linux-amd64", "socks5-server-linux-arm64", "config.json", "config.example.json", "README.md" -DestinationPath "socks5-server-linux-%VERSION%.zip"

echo 创建 macOS 发布包...
powershell Compress-Archive -Path "socks5-server-darwin-amd64", "socks5-server-darwin-arm64", "config.json", "config.example.json", "README.md" -DestinationPath "socks5-server-darwin-%VERSION%.zip"

cd ..

echo.
echo ================================
echo 打包完成！
echo.
echo 生成的文件:
dir dist
echo.
echo 发布包:
dir dist\*.zip
echo.
echo 版本: %VERSION%
echo 构建时间: %date% %time%
echo ================================

pause 