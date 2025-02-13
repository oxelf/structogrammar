package main

import (
	"os/exec"
	"runtime"
)

func openUrl(url string) {
	if runtime.GOOS == "windows" {
		exec.Command("cmd", "/C", "start", url).Run()
		return
	} else if runtime.GOOS == "darwin" {
		exec.Command("open", url).Run()
		return
	} else {
		exec.Command("xdg-open", url).Run()
	}
}
