// socket.go
package main

import (
	"fmt"
	"net"
)

func writeToUnixSocket(socketPath, message string) error {
	conn, err := net.Dial("unix", socketPath)
	if err != nil {
		return fmt.Errorf("Error connecting to UNIX socket: %v", err)
	}
	defer conn.Close()

	_, err = conn.Write([]byte(message))
	if err != nil {
		return fmt.Errorf("Error writing to UNIX socket: %v", err)
	}

	return nil
}
