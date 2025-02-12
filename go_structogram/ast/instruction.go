package ast

import (
	"bytes"
	"html/template"
	templs "structo/go_structogram/templates"
)

type Instruction struct {
	Instr   string
	HtmlTag string
	css     string
}

func (i Instruction) Tag() string {
	return i.HtmlTag
}

func (i Instruction) AdditionalCSS() string {
	return i.HtmlTag
}

func (i Instruction) Type() NodeType {
	return INSTRUCTION
}

func (i Instruction) HTML(styles NodeStyle) string {
	var rendered bytes.Buffer
	tmpl, err := template.ParseFS(templs.TemplateFS, "instruction.tmpl")
	if err != nil {
		panic(err)
	}
	err = tmpl.Execute(&rendered, map[string]interface{}{
		"instruction": i.Instr,
		"styles":      template.CSS(styles),
	})
	if err != nil {
		return ""
	}
	return rendered.String()
}
