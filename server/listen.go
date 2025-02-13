package server

import (
	"fmt"
	"strings"

	"github.com/fsnotify/fsnotify"
)

func (s *Server) listen(absPath string) {
	split := strings.Split(absPath, "/")
	dir := ""
	if len(split) > 1 {
		dir = strings.Join(split[:len(split)-1], "/")
	}
	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		return
	}
	err = watcher.Add(dir)
	if err != nil {
		return
	}

	defer watcher.Close()
	for {
		select {
		case event, ok := <-watcher.Events:
			if !ok {
				return
			}
			if event.Has(fsnotify.Create) {
				if event.Name == absPath || event.Name[:len(event.Name)-1] == absPath {
					s.changeChan <- 1
				}
			}
		case err, ok := <-watcher.Errors:
			if !ok {
				return
			}
			fmt.Println("error:", err)
		}
	}
}
