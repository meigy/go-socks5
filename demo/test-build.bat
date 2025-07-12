@echo off
chcp 65001 >nul
echo 测试构建结果
echo ================================

if not exist dist\socks5-server.exe (
    echo 错误: 未找到构建的可执行文件！
    echo 请先运行构建脚本: .\build-simple.bat
    pause
    exit /b 1
)

echo 测试可执行文件...
echo.

echo [1/3] 测试帮助信息...
.\dist\socks5-server.exe -help
if %ERRORLEVEL% neq 0 (
    echo 错误: 帮助信息测试失败！
    pause
    exit /b 1
)

echo.
echo [2/3] 测试配置文件加载...
.\dist\socks5-server.exe -config config.json
if %ERRORLEVEL% neq 0 (
    echo 错误: 配置文件加载测试失败！
    pause
    exit /b 1
)

echo.
echo [3/3] 检查文件信息...
echo 可执行文件大小: 
dir dist\socks5-server.exe | findstr "socks5-server.exe"

echo.
echo 配置文件:
dir dist\config.json
dir dist\config.example.json

echo.
echo ================================
echo 测试完成！构建成功！
echo ================================

pause 