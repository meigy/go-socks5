@echo off
chcp 65001 >nul
echo SOCKS5代理服务器简化打包脚本
echo ================================

set VERSION=1.0.0
set APP_NAME=socks5-server

echo 正在清理旧的构建文件...
if exist dist rmdir /s /q dist
mkdir dist

echo 开始编译当前平台版本...

go build -ldflags "-s -w -X main.Version=%VERSION%" -o dist\%APP_NAME%.exe .
if %ERRORLEVEL% neq 0 (
    echo 编译失败！
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
powershell Compress-Archive -Path "socks5-server.exe", "config.json", "config.example.json", "README.md" -DestinationPath "socks5-server-%VERSION%.zip"
cd ..

echo.
echo ================================
echo 打包完成！
echo.
echo 生成的文件:
dir dist
echo.
echo 版本: %VERSION%
echo 构建时间: %date% %time%
echo ================================

pause 