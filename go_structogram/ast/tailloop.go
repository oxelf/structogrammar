package ast

import (
	"bytes"
	"html/template"
	templs "structo/go_structogram/templates"
)

type Tailloop struct {
	Condition string
	Body      []Node
	HtmlTag   string
	css       string
}

func (t Tailloop) Tag() string {
	return t.HtmlTag
}

func (t Tailloop) AdditionalCSS() string {
	return t.HtmlTag
}
func (t *Tailloop) Type() NodeType {
	return HEADLOOP
}

func (t *Tailloop) HTML(styles NodeStyle) string {
	var rendered bytes.Buffer
	tmpl, err := template.ParseFS(templs.TemplateFS, "tailloop.tmpl")
	if err != nil {
		panic(err)
	}
	var body string
	for _, n := range t.Body {
		s := Style().BorderLeft().BorderBottom()
		body += n.HTML(s)
	}
	err = tmpl.Execute(&rendered, map[string]interface{}{
		"condition": t.Condition,
		"body":      template.HTML(body),
		"styles":    template.CSS(styles),
	})
	if err != nil {
		return ""
	}
	return rendered.String()
}
