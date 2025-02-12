package ast

type NodeType string

const (
	FUNCTION    NodeType = "FUNCTION"
	CALL        NodeType = "CALL"
	INSTRUCTION NodeType = "INSTRUCTION"
	HEADLOOP    NodeType = "HEADLOOP"
	TAILLOOP    NodeType = "TAILLOOP"
	CONDITION   NodeType = "CONDITION"
	SWITCH      NodeType = "SWITCH"
	TRY         NodeType = "TRY"
)

type Node interface {
	Type() NodeType
	HTML(styles NodeStyle) string
	Tag() string
	AdditionalCSS() string
}
