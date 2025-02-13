package server

import (
	"fmt"
	"io"

	"github.com/gin-gonic/gin"
)

func HeadersMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Content-Type", "text/event-stream")
		c.Writer.Header().Set("Cache-Control", "no-cache")
		c.Writer.Header().Set("Connection", "keep-alive")
		c.Writer.Header().Set("Transfer-Encoding", "chunked")
		c.Next()
	}
}

func (s *Server) changeStream(c *gin.Context) {
	disconnected := c.Stream(func(w io.Writer) bool {
		channel := s.changeChan

		if _, ok := <-channel; ok {
			c.SSEvent("reload", "")
			return true
		}
		return false
	})
	if disconnected {
		fmt.Println("Client disconnected")
	}
}
