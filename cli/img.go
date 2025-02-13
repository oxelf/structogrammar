package main

import (
	"bytes"
	"fmt"
	"html/template"
	gostructogram "structo/go_structogram"
	"structo/parser"
	"structo/web"
)

func Img(input []byte, function *parser.FunctionQueryResult, imagePath string) {
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

	Screenshot(imagePath, out.String())
	return
}
