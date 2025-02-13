package main

import (
	"bytes"
	"fmt"
	"html/template"
	"os"
	"path/filepath"
	gostructogram "structo/go_structogram"
	"structo/parser"
	"structo/web"
)

func Html(input []byte, function *parser.FunctionQueryResult, htmlPath string) {
	n := parser.Parse(input, &parser.CppConfig{}, *function)
	t, err := template.ParseFS(web.TemplateFS, "static.tmpl")
	if err != nil {
		fmt.Println(err)
		return
	}

	rendered := gostructogram.Render(&n)

	var out bytes.Buffer
	t.Execute(&out, map[string]interface{}{
		"structogram": template.HTML(rendered),
		"css":         template.CSS(gostructogram.CSS()),
	})

	os.WriteFile(htmlPath, out.Bytes(), 0o644)

	absOutPath, _ := filepath.Abs(htmlPath)

	openUrl("file://" + absOutPath)
}
