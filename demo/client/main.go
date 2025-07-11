package main

import (
	"bufio"
	"fmt"
	"log"
	"net"
	"os"
	"strings"
)

// SOCKS5客户端测试程序
func testSocks5Client() {
	// 代理服务器配置
	proxyHost := "127.0.0.1"
	proxyPort := 1080
	username := "admin"
	password := "password"

	// 连接代理服务器
	proxyAddr := fmt.Sprintf("%s:%d", proxyHost, proxyPort)
	conn, err := net.Dial("tcp", proxyAddr)
	if err != nil {
		log.Fatalf("连接代理服务器失败: %v", err)
	}
	defer conn.Close()

	log.Printf("已连接到代理服务器: %s", proxyAddr)

	// SOCKS5握手
	if err := socks5Handshake(conn, username, password); err != nil {
		log.Fatalf("SOCKS5握手失败: %v", err)
	}

	log.Println("SOCKS5握手成功!")

	// 测试连接到一个网站
	targetHost := "www.google.com"
	targetPort := 80

	if err := socks5Connect(conn, targetHost, targetPort); err != nil {
		log.Fatalf("SOCKS5连接请求失败: %v", err)
	}

	log.Printf("成功通过代理连接到 %s:%d", targetHost, targetPort)

	// 发送HTTP请求
	httpRequest := fmt.Sprintf("GET / HTTP/1.1\r\nHost: %s\r\nConnection: close\r\n\r\n", targetHost)
	_, err = conn.Write([]byte(httpRequest))
	if err != nil {
		log.Fatalf("发送HTTP请求失败: %v", err)
	}

	// 读取响应
	response, err := bufio.NewReader(conn).ReadString('\n')
	if err != nil {
		log.Fatalf("读取响应失败: %v", err)
	}

	log.Printf("收到响应: %s", strings.TrimSpace(response))
}

// SOCKS5握手
func socks5Handshake(conn net.Conn, username, password string) error {
	// 发送支持的认证方法
	// 版本5，1个认证方法，用户名密码认证(0x02)
	_, err := conn.Write([]byte{0x05, 0x01, 0x02})
	if err != nil {
		return err
	}

	// 读取服务器响应
	response := make([]byte, 2)
	_, err = conn.Read(response)
	if err != nil {
		return err
	}

	if response[0] != 0x05 {
		return fmt.Errorf("不支持的SOCKS版本: %d", response[0])
	}

	if response[1] != 0x02 {
		return fmt.Errorf("服务器不支持用户名密码认证: %d", response[1])
	}

	// 发送用户名密码
	authRequest := []byte{0x01} // 认证子协议版本
	authRequest = append(authRequest, byte(len(username)))
	authRequest = append(authRequest, []byte(username)...)
	authRequest = append(authRequest, byte(len(password)))
	authRequest = append(authRequest, []byte(password)...)

	_, err = conn.Write(authRequest)
	if err != nil {
		return err
	}

	// 读取认证响应
	authResponse := make([]byte, 2)
	_, err = conn.Read(authResponse)
	if err != nil {
		return err
	}

	if authResponse[0] != 0x01 {
		return fmt.Errorf("认证子协议版本错误: %d", authResponse[0])
	}

	if authResponse[1] != 0x00 {
		return fmt.Errorf("认证失败: %d", authResponse[1])
	}

	return nil
}

// SOCKS5连接请求
func socks5Connect(conn net.Conn, host string, port int) error {
	// 构建连接请求
	request := []byte{0x05, 0x01, 0x00, 0x03} // 版本5，CONNECT命令，保留字段，域名类型
	request = append(request, byte(len(host)))
	request = append(request, []byte(host)...)
	request = append(request, byte(port>>8), byte(port&0xFF))

	_, err := conn.Write(request)
	if err != nil {
		return err
	}

	// 读取连接响应
	response := make([]byte, 10)
	_, err = conn.Read(response)
	if err != nil {
		return err
	}

	if response[0] != 0x05 {
		return fmt.Errorf("不支持的SOCKS版本: %d", response[0])
	}

	if response[1] != 0x00 {
		return fmt.Errorf("连接失败，错误代码: %d", response[1])
	}

	return nil
}

func main() {
	fmt.Println("SOCKS5客户端测试程序")
	fmt.Println("请确保代理服务器正在运行...")
	fmt.Println("按回车键开始测试...")

	reader := bufio.NewReader(os.Stdin)
	reader.ReadString('\n')

	testSocks5Client()
}
