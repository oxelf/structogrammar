package ast

import (
	"bytes"
	"fmt"
	"html/template"
	templs "structo/go_structogram/templates"
)

type SwitchBranch struct {
	Condition       string
	Body            []Node
	HTML            template.HTML
	ConditionBorder template.CSS
}

type Switch struct {
	Variable string
	Branches []SwitchBranch
	Default  SwitchBranch
	HtmlTag  string
	css      string
}

func (s Switch) Tag() string {
	return s.HtmlTag
}

func (s Switch) AdditionalCSS() string {
	return s.HtmlTag
}

func (s *Switch) Type() NodeType {
	return SWITCH
}

func (s *Switch) HTML(styles NodeStyle) string {
	var rendered bytes.Buffer
	tmpl, err := template.ParseFS(templs.TemplateFS, "switch.tmpl")
	if err != nil {
		panic(err)
	}
	for i, b := range s.Branches {
		body := ""
		for _, n := range b.Body {
			s := Style().BorderRight().BorderTop()
			body += n.HTML(s)
		}
		s.Branches[i].HTML = template.HTML(body)
		s.Branches[i].ConditionBorder = template.CSS(Style().BorderRight())
	}
	body := ""
	for _, n := range s.Default.Body {
		s := Style().BorderTop()
		body += n.HTML(s)
	}
	s.Default.HTML = template.HTML(body)
	s.Default.ConditionBorder = template.CSS("")

	err = tmpl.Execute(&rendered, map[string]interface{}{
		"variable":    s.Variable,
		"branches":    append(s.Branches, s.Default),
		"branchClass": fmt.Sprintf("switchHead%d", len(s.Branches)),
		"styles":      template.CSS(styles),
		"offset":      (100 / (len(s.Branches) + 1)) * len(s.Branches),
	})
	if err != nil {
		return ""
	}
	return rendered.String()
}
