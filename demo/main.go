package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"log"
	"net"
	"os"

	"go-socks5"
)

// Version 版本信息
var Version = "1.0.0"

// Config 配置文件结构
type Config struct {
	Server struct {
		Host string `json:"host"`
		Port int    `json:"port"`
	} `json:"server"`
	Auth struct {
		Username string `json:"username"`
		Password string `json:"password"`
	} `json:"auth"`
	Logging struct {
		EnableConnectionLog bool   `json:"enable_connection_log"`
		LogLevel           string `json:"log_level"`
	} `json:"logging"`
}

// ConnectionLogger 连接日志记录器
type ConnectionLogger struct {
	config *Config
	logger *log.Logger
}

// NewConnectionLogger 创建新的连接日志记录器
func NewConnectionLogger(config *Config) *ConnectionLogger {
	return &ConnectionLogger{
		config: config,
		logger: log.New(os.Stdout, "[连接日志] ", log.LstdFlags),
	}
}

// LogConnection 记录连接信息
func (cl *ConnectionLogger) LogConnection(clientAddr net.Addr, username string, success bool) {
	if !cl.config.Logging.EnableConnectionLog {
		return
	}

	status := "失败"
	if success {
		status = "成功"
	}

	cl.logger.Printf("客户端 %s 认证%s", clientAddr.String(), status)
}

// LogRequest 记录请求信息
func (cl *ConnectionLogger) LogRequest(clientAddr net.Addr, targetAddr string, method string) {
	if !cl.config.Logging.EnableConnectionLog {
		return
	}

	cl.logger.Printf("客户端 %s 请求 %s 方法: %s", clientAddr.String(), targetAddr, method)
}

// CustomAuthenticator 自定义认证器
type CustomAuthenticator struct {
	credentials socks5.StaticCredentials
	logger      *ConnectionLogger
}

// Valid 验证用户名密码
func (ca *CustomAuthenticator) Valid(user, password string) bool {
	expectedPassword, exists := ca.credentials[user]
	if !exists {
		return false
	}
	return password == expectedPassword
}

// GetCode 返回认证方法代码
func (ca *CustomAuthenticator) GetCode() uint8 {
	return 2 // UserPassAuth
}

// Authenticate 认证方法
func (ca *CustomAuthenticator) Authenticate(reader io.Reader, writer io.Writer) (*socks5.AuthContext, error) {
	// 获取客户端地址（如果可能）
	var clientAddr net.Addr
	if conn, ok := reader.(interface{ RemoteAddr() net.Addr }); ok {
		clientAddr = conn.RemoteAddr()
	}

	// 创建标准的用户名密码认证器
	auth := &socks5.UserPassAuthenticator{
		Credentials: ca.credentials,
	}

	// 执行认证
	authContext, err := auth.Authenticate(reader, writer)
	
	// 记录认证日志
	if clientAddr != nil && authContext != nil {
		username := authContext.Payload["Username"]
		success := err == nil
		ca.logger.LogConnection(clientAddr, username, success)
	}
	
	return authContext, err
}

// loadConfig 从配置文件加载配置
func loadConfig(configPath string) (*Config, error) {
	file, err := os.Open(configPath)
	if err != nil {
		return nil, fmt.Errorf("打开配置文件失败: %v", err)
	}
	defer file.Close()

	var config Config
	decoder := json.NewDecoder(file)
	if err := decoder.Decode(&config); err != nil {
		return nil, fmt.Errorf("解析配置文件失败: %v", err)
	}

	return &config, nil
}

func main() {
	// 定义命令行参数
	var (
		configPath = flag.String("config", "config.json", "配置文件路径")
		help       = flag.Bool("help", false, "显示帮助信息")
	)
	flag.Parse()

	// 显示帮助信息
	if *help {
		fmt.Println("SOCKS5代理服务器")
		fmt.Println("用法:")
		flag.PrintDefaults()
		fmt.Println("\n配置文件格式 (config.json):")
		fmt.Println(`{
  "server": {
    "host": "127.0.0.1",
    "port": 1080
  },
  "auth": {
    "username": "admin",
    "password": "password"
  }
}`)
		fmt.Println("\n示例:")
		fmt.Println("  go run main.go -config config.json")
		return
	}

	// 加载配置文件
	config, err := loadConfig(*configPath)
	if err != nil {
		log.Fatalf("加载配置文件失败: %v", err)
	}

	// 创建连接日志记录器
	connLogger := NewConnectionLogger(config)

	// 创建用户名密码认证存储
	creds := socks5.StaticCredentials{
		config.Auth.Username: config.Auth.Password,
	}

	// 创建自定义认证器
	auth := &CustomAuthenticator{
		credentials: creds,
		logger:      connLogger,
	}

	// 创建SOCKS5服务器配置
	conf := &socks5.Config{
		AuthMethods: []socks5.Authenticator{auth},
		Logger:      log.New(os.Stdout, "[服务器] ", log.LstdFlags),
	}

	// 创建SOCKS5服务器
	server, err := socks5.New(conf)
	if err != nil {
		log.Fatalf("创建SOCKS5服务器失败: %v", err)
	}

	// 构建监听地址
	addr := fmt.Sprintf("%s:%d", config.Server.Host, config.Server.Port)

	log.Printf("启动SOCKS5代理服务器...")
	log.Printf("配置文件: %s", *configPath)
	log.Printf("监听地址: %s", addr)
	log.Printf("连接日志: %v", config.Logging.EnableConnectionLog)
	log.Printf("按 Ctrl+C 停止服务器")

	// 启动服务器
	if err := server.ListenAndServe("tcp", addr); err != nil {
		log.Fatalf("启动SOCKS5服务器失败: %v", err)
	}
}
