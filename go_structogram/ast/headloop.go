package ast

import (
	"bytes"
	"html/template"
	templs "structo/go_structogram/templates"
)

type HeadLoop struct {
	Condition string
	Body      []Node
	HtmlTag   string
	css       string
}

func (h HeadLoop) Tag() string {
	return h.HtmlTag
}

func (h HeadLoop) AdditionalCSS() string {
	return h.HtmlTag
}
func (h *HeadLoop) Type() NodeType {
	return HEADLOOP
}

func (h *HeadLoop) HTML(styles NodeStyle) string {
	var rendered bytes.Buffer
	tmpl, err := template.ParseFS(templs.TemplateFS, "headloop.tmpl")
	if err != nil {
		panic(err)
	}
	var body string
	for _, n := range h.Body {
		s := Style().BorderLeft().BorderTop()
		body += n.HTML(s)
	}
	err = tmpl.Execute(&rendered, map[string]interface{}{
		"condition": h.Condition,
		"body":      template.HTML(body),
		"styles":    template.CSS(styles),
	})
	if err != nil {
		return ""
	}
	return rendered.String()
}
