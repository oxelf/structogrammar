package parser

import (
	"structo/go_structogram/ast"

	sitter "github.com/smacker/go-tree-sitter"
)

func (p *Parser) parseBlock(node *sitter.Node) []ast.Node {
	nodes := []ast.Node{}
	for i := 0; i < int(node.ChildCount()); i++ {
		child := node.Child(i)
		n := p.parseNode(child)
		if n != nil {
			nodes = append(nodes, n)
		}
	}
	return nodes
}
