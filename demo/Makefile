# SOCKS5代理服务器构建配置
VERSION := 1.0.0
APP_NAME := socks5-server
BUILD_DIR := dist

# 支持的平台和架构
PLATFORMS := windows linux darwin
ARCHITECTURES := amd64 386 arm64

# 默认目标
.PHONY: all
all: clean build-all

# 清理构建目录
.PHONY: clean
clean:
	@echo "清理构建目录..."
	@rm -rf $(BUILD_DIR)
	@mkdir -p $(BUILD_DIR)

# 构建当前平台版本
.PHONY: build
build: clean
	@echo "构建当前平台版本..."
	@go build -ldflags "-s -w -X main.Version=$(VERSION)" -o $(BUILD_DIR)/$(APP_NAME) .
	@echo "复制配置文件..."
	@cp config.json $(BUILD_DIR)/
	@cp config.example.json $(BUILD_DIR)/
	@cp README.md $(BUILD_DIR)/

# 构建所有平台版本
.PHONY: build-all
build-all: clean
	@echo "构建所有平台版本..."
	@$(MAKE) build-windows
	@$(MAKE) build-linux
	@$(MAKE) build-darwin
	@echo "复制配置文件..."
	@cp config.json $(BUILD_DIR)/
	@cp config.example.json $(BUILD_DIR)/
	@cp README.md $(BUILD_DIR)/

# 构建Windows版本
.PHONY: build-windows
build-windows:
	@echo "构建Windows版本..."
	@GOOS=windows GOARCH=amd64 go build -ldflags "-s -w -X main.Version=$(VERSION)" -o $(BUILD_DIR)/$(APP_NAME)-windows-amd64.exe .
	@GOOS=windows GOARCH=386 go build -ldflags "-s -w -X main.Version=$(VERSION)" -o $(BUILD_DIR)/$(APP_NAME)-windows-386.exe .

# 构建Linux版本
.PHONY: build-linux
build-linux:
	@echo "构建Linux版本..."
	@GOOS=linux GOARCH=amd64 go build -ldflags "-s -w -X main.Version=$(VERSION)" -o $(BUILD_DIR)/$(APP_NAME)-linux-amd64 .
	@GOOS=linux GOARCH=arm64 go build -ldflags "-s -w -X main.Version=$(VERSION)" -o $(BUILD_DIR)/$(APP_NAME)-linux-arm64 .

# 构建macOS版本
.PHONY: build-darwin
build-darwin:
	@echo "构建macOS版本..."
	@GOOS=darwin GOARCH=amd64 go build -ldflags "-s -w -X main.Version=$(VERSION)" -o $(BUILD_DIR)/$(APP_NAME)-darwin-amd64 .
	@GOOS=darwin GOARCH=arm64 go build -ldflags "-s -w -X main.Version=$(VERSION)" -o $(BUILD_DIR)/$(APP_NAME)-darwin-arm64 .

# 创建发布包
.PHONY: package
package: build-all
	@echo "创建发布包..."
	@cd $(BUILD_DIR) && \
	zip -r $(APP_NAME)-windows-$(VERSION).zip \
		$(APP_NAME)-windows-amd64.exe \
		$(APP_NAME)-windows-386.exe \
		config.json \
		config.example.json \
		README.md && \
	zip -r $(APP_NAME)-linux-$(VERSION).zip \
		$(APP_NAME)-linux-amd64 \
		$(APP_NAME)-linux-arm64 \
		config.json \
		config.example.json \
		README.md && \
	zip -r $(APP_NAME)-darwin-$(VERSION).zip \
		$(APP_NAME)-darwin-amd64 \
		$(APP_NAME)-darwin-arm64 \
		config.json \
		config.example.json \
		README.md
	@echo "发布包创建完成！"

# 创建当前平台发布包
.PHONY: package-current
package-current: build
	@echo "创建当前平台发布包..."
	@cd $(BUILD_DIR) && \
	zip -r $(APP_NAME)-$(VERSION).zip \
		$(APP_NAME) \
		config.json \
		config.example.json \
		README.md
	@echo "发布包创建完成！"

# 运行测试
.PHONY: test
test:
	@echo "运行测试..."
	@go test -v ./...

# 格式化代码
.PHONY: fmt
fmt:
	@echo "格式化代码..."
	@go fmt ./...

# 代码检查
.PHONY: lint
lint:
	@echo "代码检查..."
	@if command -v golint >/dev/null 2>&1; then \
		golint ./...; \
	else \
		echo "golint未安装，跳过代码检查"; \
	fi

# 显示帮助信息
.PHONY: help
help:
	@echo "SOCKS5代理服务器构建命令"
	@echo "================================"
	@echo "make build          - 构建当前平台版本"
	@echo "make build-all      - 构建所有平台版本"
	@echo "make build-windows  - 构建Windows版本"
	@echo "make build-linux    - 构建Linux版本"
	@echo "make build-darwin   - 构建macOS版本"
	@echo "make package        - 创建所有平台发布包"
	@echo "make package-current- 创建当前平台发布包"
	@echo "make test           - 运行测试"
	@echo "make fmt            - 格式化代码"
	@echo "make lint           - 代码检查"
	@echo "make clean          - 清理构建目录"
	@echo "make help           - 显示此帮助信息"
	@echo ""
	@echo "版本: $(VERSION)"
	@echo "================================"

# 显示构建信息
.PHONY: info
info:
	@echo "构建信息"
	@echo "================================"
	@echo "应用名称: $(APP_NAME)"
	@echo "版本: $(VERSION)"
	@echo "构建目录: $(BUILD_DIR)"
	@echo "Go版本: $(shell go version)"
	@echo "================================" 