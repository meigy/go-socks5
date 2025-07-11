package main

import (
	"flag"
	"fmt"
	"log"
	"os"

	"go-socks5"
)

func main() {
	// 定义命令行参数
	var (
		host     = flag.String("host", "127.0.0.1", "代理服务器监听地址")
		port     = flag.Int("port", 1080, "代理服务器监听端口")
		username = flag.String("user", "admin", "用户名")
		password = flag.String("pass", "password", "密码")
		help     = flag.Bool("help", false, "显示帮助信息")
	)
	flag.Parse()

	// 显示帮助信息
	if *help {
		fmt.Println("SOCKS5代理服务器")
		fmt.Println("用法:")
		flag.PrintDefaults()
		fmt.Println("\n示例:")
		fmt.Println("  go run main.go -host 0.0.0.0 -port 1080 -user admin -pass mypassword")
		fmt.Println("\n客户端配置:")
		fmt.Println("  代理类型: SOCKS5")
		fmt.Println("  服务器地址:", *host)
		fmt.Println("  端口:", *port)
		fmt.Println("  用户名:", *username)
		fmt.Println("  密码:", *password)
		return
	}

	// 创建用户名密码认证存储
	creds := socks5.StaticCredentials{
		*username: *password,
	}

	// 创建SOCKS5服务器配置
	conf := &socks5.Config{
		Credentials: creds,
		Logger:      log.New(os.Stdout, "", log.LstdFlags),
	}

	// 创建SOCKS5服务器
	server, err := socks5.New(conf)
	if err != nil {
		log.Fatalf("创建SOCKS5服务器失败: %v", err)
	}

	// 构建监听地址
	addr := fmt.Sprintf("%s:%d", *host, *port)

	log.Printf("启动SOCKS5代理服务器...")
	log.Printf("监听地址: %s", addr)
	log.Printf("认证信息: 用户名=%s, 密码=%s", *username, *password)
	log.Printf("按 Ctrl+C 停止服务器")

	// 启动服务器
	if err := server.ListenAndServe("tcp", addr); err != nil {
		log.Fatalf("启动SOCKS5服务器失败: %v", err)
	}
}
