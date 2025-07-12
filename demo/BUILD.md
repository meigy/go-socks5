# SOCKS5代理服务器构建说明

本文档详细说明了如何构建和打包SOCKS5代理服务器。

## 构建脚本概览

项目提供了多种构建脚本，满足不同的构建需求：

### Windows平台
- `build.bat` - 完整跨平台构建脚本
- `build-simple.bat` - 简化版构建脚本（仅当前平台）

### Linux/macOS平台
- `build.sh` - 完整跨平台构建脚本
- `build-simple.sh` - 简化版构建脚本（仅当前平台）

### 通用构建工具
- `Makefile` - 灵活的构建配置，支持多种构建选项

## 构建要求

### 必需工具
- **Go 1.16+** - 编程语言环境
- **Git** - 版本控制（可选）

### 可选工具
- **Make** - 用于Makefile构建（Linux/macOS）
- **zip** - 用于创建压缩包（Linux/macOS）
- **PowerShell** - 用于Windows压缩包创建

## 构建方法

### 1. 使用批处理脚本（Windows）

#### 完整构建（推荐）
```cmd
# 构建所有平台版本并创建发布包
build.bat
```

#### 简化构建
```cmd
# 仅构建当前平台版本
build-simple.bat
```

### 2. 使用Shell脚本（Linux/macOS）

#### 完整构建（推荐）
```bash
# 给脚本执行权限
chmod +x build.sh

# 构建所有平台版本并创建发布包
./build.sh
```

#### 简化构建
```bash
# 给脚本执行权限
chmod +x build-simple.sh

# 仅构建当前平台版本
./build-simple.sh
```

### 3. 使用Makefile（推荐）

#### 查看帮助
```bash
make help
```

#### 构建当前平台版本
```bash
make build
```

#### 构建所有平台版本
```bash
make build-all
```

#### 创建发布包
```bash
# 创建所有平台发布包
make package

# 创建当前平台发布包
make package-current
```

#### 其他有用命令
```bash
# 运行测试
make test

# 格式化代码
make fmt

# 代码检查
make lint

# 清理构建目录
make clean

# 显示构建信息
make info
```

## 构建输出

### 构建目录结构
```
dist/
├── socks5-server-windows-amd64.exe    # Windows x64版本
├── socks5-server-windows-386.exe      # Windows x86版本
├── socks5-server-linux-amd64          # Linux x64版本
├── socks5-server-linux-arm64          # Linux ARM64版本
├── socks5-server-darwin-amd64         # macOS x64版本
├── socks5-server-darwin-arm64         # macOS ARM64版本
├── config.json                        # 配置文件
├── config.example.json                # 示例配置文件
├── README.md                          # 说明文档
├── socks5-server-windows-1.0.0.zip   # Windows发布包
├── socks5-server-linux-1.0.0.zip     # Linux发布包
└── socks5-server-darwin-1.0.0.zip    # macOS发布包
```

### 发布包内容
每个发布包包含：
- 对应平台的可执行文件
- `config.json` - 默认配置文件
- `config.example.json` - 示例配置文件
- `README.md` - 使用说明

## 版本管理

### 修改版本号
在构建脚本中修改 `VERSION` 变量：

```bash
# build.sh / build-simple.sh
VERSION="1.0.1"

# build.bat / build-simple.bat
set VERSION=1.0.1

# Makefile
VERSION := 1.0.1
```

### 构建标志
所有构建都使用以下标志优化二进制文件：
- `-s` - 去除符号表
- `-w` - 去除DWARF调试信息
- `-X main.Version=$(VERSION)` - 注入版本信息

## 平台支持

### 支持的平台和架构
| 平台 | 架构 | 输出文件名 |
|------|------|------------|
| Windows | x64 | socks5-server-windows-amd64.exe |
| Windows | x86 | socks5-server-windows-386.exe |
| Linux | x64 | socks5-server-linux-amd64 |
| Linux | ARM64 | socks5-server-linux-arm64 |
| macOS | x64 | socks5-server-darwin-amd64 |
| macOS | ARM64 | socks5-server-darwin-arm64 |

## 故障排除

### 常见问题

#### 1. Go命令未找到
```
错误: go: 无法将"go"项识别为 cmdlet、函数、脚本文件或可运行程序的名称
解决: 安装Go并确保在PATH环境变量中
```

#### 2. 权限不足
```bash
错误: permission denied
解决: 给脚本添加执行权限 chmod +x build.sh
```

#### 3. 依赖缺失
```
错误: cannot find package "go-socks5"
解决: 确保在正确的目录中运行，或运行 go mod tidy
```

#### 4. 跨平台编译失败
```
错误: unsupported GOOS/GOARCH pair
解决: 确保Go版本支持目标平台，或跳过不支持的平台
```

### 调试构建
```bash
# 显示详细构建信息
go build -v -ldflags "-s -w -X main.Version=1.0.0" main.go

# 检查二进制文件信息
file dist/socks5-server-*

# 检查二进制文件大小
ls -lh dist/
```

## 自动化构建

### CI/CD集成
可以将构建脚本集成到CI/CD流程中：

```yaml
# GitHub Actions示例
- name: Build for multiple platforms
  run: |
    make build-all
    make package
```

### 定时构建
使用cron任务定期构建：

```bash
# 每天凌晨2点构建
0 2 * * * cd /path/to/project && make package
```

## 最佳实践

1. **版本管理**: 使用语义化版本号
2. **测试**: 构建前运行测试 `make test`
3. **代码质量**: 使用 `make fmt` 和 `make lint`
4. **备份**: 保留重要版本的发布包
5. **文档**: 及时更新构建说明

## 联系支持

如果遇到构建问题，请：
1. 检查构建要求是否满足
2. 查看故障排除部分
3. 提交Issue并附上详细错误信息 