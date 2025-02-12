package gostructogram

import (
	"bytes"
	"structo/go_structogram/ast"
	templs "structo/go_structogram/templates"
	"text/template"
)

func Render(function *ast.Function) string {
	return function.HTML(ast.Style().BorderAll())
}

func CSS() string {
	var rendered bytes.Buffer
	tmpl, err := template.ParseFS(templs.TemplateFS, "styles.css")
	if err != nil {
		panic(err)
	}
	tmpl.Execute(&rendered, nil)
	return rendered.String()
}
