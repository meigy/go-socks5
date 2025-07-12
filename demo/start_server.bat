@echo off
chcp 65001 >nul
echo SOCKS5代理服务器启动脚本
echo ================================

echo 正在启动SOCKS5代理服务器...
echo 使用配置文件: config.json
echo.

echo 配置文件内容:
echo   {
echo     "server": {
echo       "host": "127.0.0.1",
echo       "port": 1080
echo     },
echo     "auth": {
echo       "username": "admin",
echo       "password": "password"
echo     }
echo   }
echo.

echo 按 Ctrl+C 停止服务器
echo.

go run main.go -config config.json

pause 