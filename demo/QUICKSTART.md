# SOCKS5代理服务器快速开始指南

## 🚀 5分钟快速开始

### 1. 环境准备
确保已安装Go 1.16+：
```bash
go version
```

### 2. 修复依赖（如需要）
如果遇到网络问题，运行依赖修复脚本：
```cmd
# Windows
.\fix-deps.bat

# Linux/macOS
chmod +x fix-deps.sh
./fix-deps.sh
```

### 3. 快速构建
```cmd
# Windows
.\build-simple.bat

# Linux/macOS
chmod +x build-simple.sh
./build-simple.sh

# 或使用Makefile
make build
```

### 4. 测试构建结果
```cmd
# Windows
.\test-build.bat

# 手动测试
.\dist\socks5-server.exe -help
```

### 5. 启动服务器
```cmd
# 使用默认配置
.\dist\socks5-server.exe

# 使用自定义配置
.\dist\socks5-server.exe -config config.example.json
```

## 📋 常用命令

### 构建命令
```bash
# 快速构建（当前平台）
make build

# 完整构建（所有平台）
make package

# 查看构建选项
make help
```

### 开发命令
```bash
# 运行测试
make test

# 格式化代码
make fmt

# 代码检查
make lint
```

### 服务器命令
```bash
# 启动服务器
.\start_server.bat

# 查看帮助
.\dist\socks5-server.exe -help
```

## 🔧 配置文件

### 默认配置 (config.json)
```json
{
  "server": {
    "host": "127.0.0.1",
    "port": 1080
  },
  "auth": {
    "username": "admin",
    "password": "password"
  }
}
```

### 自定义配置
复制 `config.example.json` 并修改参数：
```json
{
  "server": {
    "host": "0.0.0.0",
    "port": 1080
  },
  "auth": {
    "username": "myuser",
    "password": "mypassword"
  }
}
```

## 🌐 客户端配置

### 浏览器配置
- **代理类型**: SOCKS5
- **服务器**: 127.0.0.1
- **端口**: 1080
- **用户名**: admin
- **密码**: password

### 命令行工具
```bash
# curl
curl --socks5 127.0.0.1:1080 --socks5-user admin --socks5-pass password http://www.google.com

# wget
wget --proxy-user=admin --proxy-password=password --proxy=127.0.0.1:1080 http://www.google.com
```

## 🐛 常见问题

### 构建问题
1. **依赖下载失败**: 运行 `.\fix-deps.bat`
2. **编译错误**: 确保在demo目录中运行
3. **乱码问题**: 脚本已设置UTF-8编码

### 运行问题
1. **端口被占用**: 修改配置文件中的端口
2. **认证失败**: 检查用户名密码
3. **连接被拒绝**: 检查服务器是否启动

## 📁 输出文件

构建完成后，`dist/` 目录包含：
- `socks5-server.exe` - 可执行文件
- `config.json` - 配置文件
- `config.example.json` - 示例配置
- `README.md` - 说明文档

## 🔗 相关文档

- [完整使用说明](README.md)
- [构建详细说明](BUILD.md)
- [项目主页](../README.md)

## 💡 提示

- 首次使用建议运行 `.\test-build.bat` 验证构建结果
- 生产环境请修改默认用户名和密码
- 使用 `0.0.0.0` 监听地址允许外部访问
- 定期更新Go版本以获得最佳性能 