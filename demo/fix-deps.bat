@echo off
chcp 65001 >nul
echo 修复Go依赖问题
echo ================================

echo 设置Go代理...
go env -w GOPROXY=https://goproxy.cn,direct
go env -w GOSUMDB=sum.golang.google.cn

echo 清理模块缓存...
go clean -modcache

echo 下载依赖...
go mod download

echo 整理模块...
go mod tidy

echo 验证模块...
go mod verify

echo.
echo ================================
echo 依赖修复完成！
echo ================================

pause 