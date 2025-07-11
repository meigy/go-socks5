@echo off
echo SOCKS5代理服务器启动脚本
echo ================================

echo 正在启动SOCKS5代理服务器...
echo 默认配置:
echo   地址: 127.0.0.1
echo   端口: 1080
echo   用户名: admin
echo   密码: password
echo.

echo 按 Ctrl+C 停止服务器
echo.

go run main.go

pause 