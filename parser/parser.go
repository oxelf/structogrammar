package parser

import (
	"structo/go_structogram/ast"

	sitter "github.com/smacker/go-tree-sitter"
)

type FunctionQueryResult struct {
	Node       *sitter.Node
	Name       string
	Params     string
	ReturnType string
}

type Parser struct {
	source []byte
	conf   LanguageConfig
}

func Parse(source []byte, lang LanguageConfig, function FunctionQueryResult) ast.Function {
	n := ast.Function{Name: function.Name, ReturnType: function.ReturnType, Parameters: function.Params}
	p := Parser{conf: lang, source: source}
	bodyNode := function.Node.ChildByFieldName(lang.ParseRules().Block)
	n.Body = p.parseBlock(bodyNode)
	return n
}
