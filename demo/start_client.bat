@echo off
echo SOCKS5客户端测试程序
echo ================================

echo 请确保代理服务器正在运行...
echo 默认配置:
echo   代理地址: 127.0.0.1:1080
echo   用户名: admin
echo   密码: password
echo.

cd client
go run main.go

pause 