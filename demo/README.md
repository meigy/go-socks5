# SOCKS5代理服务器Demo

这是一个基于go-socks5库的SOCKS5代理服务器demo程序，支持用户名密码认证。

## 功能特性

- ✅ SOCKS5协议支持
- ✅ 用户名密码认证
- ✅ CONNECT命令支持
- ✅ 命令行参数配置
- ✅ 详细的日志输出
- ✅ 客户端测试程序

## 文件结构

```
demo/
├── main.go          # SOCKS5代理服务器
├── client/          # 客户端测试程序
│   └── main.go      # SOCKS5客户端
└── README.md        # 使用说明
```

## 使用方法

### 1. 启动SOCKS5代理服务器

```bash
# 使用默认配置启动
go run main.go

# 自定义配置启动
go run main.go -host 0.0.0.0 -port 1080 -user admin -pass mypassword

# 查看帮助信息
go run main.go -help
```

#### 命令行参数

- `-host`: 代理服务器监听地址 (默认: 127.0.0.1)
- `-port`: 代理服务器监听端口 (默认: 1080)
- `-user`: 用户名 (默认: admin)
- `-pass`: 密码 (默认: password)
- `-help`: 显示帮助信息

### 2. 测试客户端

```bash
# 进入客户端目录
cd client

# 运行客户端测试
go run main.go
```

## 客户端配置示例

### 浏览器配置

1. **Firefox浏览器**:
   - 设置 → 网络设置 → 连接设置
   - 选择"手动配置代理"
   - SOCKS主机: 127.0.0.1
   - 端口: 1080
   - 选择"SOCKS v5"
   - 勾选"远程DNS"

2. **Chrome浏览器**:
   - 需要安装代理扩展插件，如"Proxy SwitchyOmega"
   - 配置SOCKS5代理: 127.0.0.1:1080
   - 用户名: admin
   - 密码: password

### 命令行工具配置

```bash
# curl使用SOCKS5代理
curl --socks5 127.0.0.1:1080 --socks5-user admin --socks5-pass password http://www.google.com

# wget使用SOCKS5代理
wget --proxy-user=admin --proxy-password=password --proxy=127.0.0.1:1080 http://www.google.com
```

### 系统代理配置

#### Windows
```
设置 → 网络和Internet → 代理
手动设置代理
地址: 127.0.0.1
端口: 1080
```

#### macOS
```
系统偏好设置 → 网络 → 高级 → 代理
勾选"SOCKS代理"
服务器: 127.0.0.1
端口: 1080
```

#### Linux
```bash
export http_proxy=socks5://admin:password@127.0.0.1:1080
export https_proxy=socks5://admin:password@127.0.0.1:1080
```

## 安全注意事项

1. **默认密码**: 请修改默认的用户名和密码
2. **网络访问**: 使用`0.0.0.0`监听地址时，确保防火墙配置正确
3. **日志安全**: 生产环境中避免在日志中输出敏感信息
4. **访问控制**: 考虑添加IP白名单等访问控制机制

## 故障排除

### 常见问题

1. **端口被占用**
   ```
   错误: listen tcp 127.0.0.1:1080: bind: address already in use
   解决: 更换端口或停止占用端口的程序
   ```

2. **认证失败**
   ```
   错误: 认证失败
   解决: 检查用户名密码是否正确
   ```

3. **连接被拒绝**
   ```
   错误: 连接被拒绝
   解决: 检查代理服务器是否正在运行
   ```

### 调试模式

启动服务器时查看详细日志：
```bash
go run main.go -host 0.0.0.0 -port 1080 -user admin -pass password
```

## 扩展功能

可以基于此demo扩展以下功能：

1. **多用户支持**: 从配置文件或数据库读取用户信息
2. **访问控制**: 添加IP白名单、域名过滤等
3. **流量统计**: 记录连接数和流量使用情况
4. **日志记录**: 详细的访问日志和错误日志
5. **TLS支持**: 添加TLS加密传输
6. **负载均衡**: 支持多个后端代理服务器

## 许可证

本项目基于MIT许可证开源。 