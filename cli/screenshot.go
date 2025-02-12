package main

import (
	"context"
	"fmt"
	"os"
	"path/filepath"

	"github.com/chromedp/chromedp"
	"github.com/google/uuid"
)

func Screenshot(outPath string, html string) error {
	ctx, cancel := chromedp.NewContext(
		context.Background(),
	)
	defer cancel()

	tempFileName := fmt.Sprintf("temp_%s.html", uuid.NewString())

	os.WriteFile(tempFileName, []byte(html), 0o644)

	defer os.Remove(tempFileName)

	absTempFileName, _ := filepath.Abs(tempFileName)

	var buf []byte
	if err := chromedp.Run(ctx, fullScreenshot(`file://`+absTempFileName, 90, &buf)); err != nil {
		return err
	}
	if err := os.WriteFile(outPath, buf, 0o644); err != nil {
		return err
	}
	return nil
}

func fullScreenshot(urlstr string, quality int, res *[]byte) chromedp.Tasks {
	return chromedp.Tasks{
		chromedp.Navigate(urlstr),
		chromedp.FullScreenshot(res, quality),
	}
}
