package ast

import (
	"bytes"
	"html/template"
	templs "structo/go_structogram/templates"
)

type Function struct {
	Name       string
	ReturnType string
	Parameters string
	Body       []Node
	HtmlTag    string
	css        string
}

func (f Function) Tag() string {
	return f.HtmlTag
}

func (f Function) AdditionalCSS() string {
	return f.css
}

func (f Function) Type() NodeType {
	return FUNCTION
}

func (f Function) HTML(styles NodeStyle) string {
	body := ""
	for i, n := range f.Body {
		s := Style().BorderLeft().BorderRight().BorderBottom()
		if i == 0 {
			s = s.BorderTop()
		}
		body += n.HTML(s)
	}
	var rendered bytes.Buffer
	tmpl, err := template.ParseFS(templs.TemplateFS, "function.tmpl")
	if err != nil {
		panic(err)
	}
	//	htmlBody := template.HTML(body)
	err = tmpl.Execute(&rendered, map[string]interface{}{
		"name":       f.Name,
		"type":       f.ReturnType,
		"parameters": f.Parameters,
		"body":       template.HTML(body),
		"styles":     template.CSS(styles),
	})
	if err != nil {
		return ""
	}
	return rendered.String()
}
