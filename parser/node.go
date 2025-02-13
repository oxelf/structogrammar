package parser

import (
	"structo/go_structogram/ast"
	"structo/util"

	sitter "github.com/smacker/go-tree-sitter"
)

func (p *Parser) parseNode(node *sitter.Node) ast.Node {
	tsMap := p.conf.TsToNode()
	rules := p.conf.ParseRules()
	nodeType := tsMap[node.Type()]
	if nodeType == "" {
		return nil
	} else {
		switch nodeType {
		case "INSTRUCTION":
			return &ast.Instruction{Instr: string(p.source[node.StartByte():node.EndByte()])}
		case "WHILE":
			condNode := node.ChildByFieldName(rules.WhileCondition)
			condition := util.RemoveBraces(string(p.source[condNode.StartByte():condNode.EndByte()]))
			bodyNode := node.ChildByFieldName(rules.WhileBody)
			body := p.parseBlock(bodyNode)
			return &ast.HeadLoop{Condition: condition, Body: body}
		case "DO_WHILE":
			condNode := node.ChildByFieldName(rules.DoWhileCondition)
			condition := util.RemoveBraces(string(p.source[condNode.StartByte():condNode.EndByte()]))
			bodyNode := node.ChildByFieldName(rules.DoWhileBody)
			body := p.parseBlock(bodyNode)
			return &ast.Tailloop{Condition: condition, Body: body}
		case "FOR":
			initNode := node.ChildByFieldName(rules.ForInitializer)
			init := ""
			if initNode != nil {
				init = string(p.source[initNode.StartByte():initNode.EndByte()])
			}
			condNode := node.ChildByFieldName(rules.ForCondition)
			condition := util.RemoveBraces(string(p.source[condNode.StartByte():condNode.EndByte()]))
			updateNode := node.ChildByFieldName(rules.ForUpdate)
			update := string(p.source[updateNode.StartByte():updateNode.EndByte()])
			bodyNode := node.ChildByFieldName(rules.ForBody)
			body := p.parseBlock(bodyNode)
			return &ast.HeadLoop{Condition: init + condition + ";" + update, Body: body}
		case "CONDITIONAL":
			condNode := node.ChildByFieldName(rules.IfCondition)
			condition := util.RemoveBraces(string(p.source[condNode.StartByte():condNode.EndByte()]))
			consNode := node.ChildByFieldName(rules.IfConsequence)
			var consequence []ast.Node
			if consNode != nil {
				if tsMap[consNode.Type()] == "BLOCK" {
					consequence = p.parseBlock(consNode)
				} else {
					consequence = append(consequence, p.parseNode(consNode))
				}
			}
			if len(consequence) == 0 {
				consequence = append(consequence, &ast.Instruction{Instr: ""})
			}
			// alternative
			altNode := node.ChildByFieldName(rules.IfAlternative)
			alternative := []ast.Node{}
			if altNode != nil {
				altBodyNode := altNode.Child(1)
				if altBodyNode != nil {
					if tsMap[altBodyNode.Type()] == "BLOCK" {
						alternative = p.parseBlock(altBodyNode)
					} else {
						alternative = append(alternative, p.parseNode(altBodyNode))
					}
				}
				if altBodyNode == nil || len(alternative) == 0 {
					alternative = append(alternative, &ast.Instruction{Instr: ""})
				}
			} else {
				alternative = append(alternative, &ast.Instruction{Instr: ""})
			}
			return &ast.If{Condition: condition, Consequence: consequence, Alternative: alternative}
		case "SWITCH":
			condNode := node.ChildByFieldName(rules.SwitchCondition)
			condition := string(p.source[condNode.StartByte():condNode.EndByte()])
			//bodyNode := node.ChildByFieldName(rules.SwitchBody)
			//body := p.parseBlock(bodyNode)
			return &ast.Switch{Variable: condition}
		default:
			return nil
		}
	}
}
