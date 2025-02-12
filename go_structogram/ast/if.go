package ast

import (
	"bytes"
	"fmt"
	"html/template"
	templs "structo/go_structogram/templates"
)

type If struct {
	Condition   string
	Consequence []Node
	Alternative []Node
	HtmlTag     string
	css         string
}

func (i If) Tag() string {
	return i.HtmlTag
}

func (i If) AdditionalCSS() string {
	return i.HtmlTag
}
func (i If) Type() NodeType {
	return CONDITION
}

func (i If) HTML(styles NodeStyle) string {
	var rendered bytes.Buffer
	tmpl, err := template.ParseFS(templs.TemplateFS, "if.tmpl")
	if err != nil {
		panic(err)
	}
	var consequence string
	for _, n := range i.Consequence {
		s := Style().BorderRight().BorderTop()
		fmt.Println("parsing n for if html: ", n)
		consequence += n.HTML(s)
	}
	var alternative string
	for _, n := range i.Alternative {
		s := Style().BorderTop()
		fmt.Println("parsing n for if html: ", n)
		alternative += n.HTML(s)
	}
	err = tmpl.Execute(&rendered, map[string]interface{}{
		"condition":   i.Condition,
		"consequence": template.HTML(consequence),
		"alternative": template.HTML(alternative),
		"styles":      template.CSS(styles),
	})
	if err != nil {
		return ""
	}
	return rendered.String()
}
