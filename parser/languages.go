package parser

import (
	sitter "github.com/smacker/go-tree-sitter"
	"github.com/smacker/go-tree-sitter/cpp"
)

type LanguageConfig interface {
	FunctionQuery() string
	TsToNode() map[string]string
	ParseRules() *LanguageParseRules
	TSLanguage() *sitter.Language
}

type LanguageParseRules struct {
	IfCondition       string
	IfConsequence     string
	IfAlternative     string
	IfAlternativeBody string
	ForInitializer    string
	ForCondition      string
	ForUpdate         string
	ForBody           string
	WhileCondition    string
	WhileBody         string
	DoWhileCondition  string
	DoWhileBody       string
	SwitchCondition   string
	SwitchBody        string
	CaseValue         string
	TryBody           string
	TryCatch          string
	TryCatchParams    string
	TryCatchBody      string
	Block             string
}

type CppConfig struct {
}

func (c *CppConfig) FunctionQuery() string {
	return CPP_FUNCTION_QUERY
}

func (c *CppConfig) TsToNode() map[string]string {
	return CPP_TS_TO_NODE
}

func (c *CppConfig) ParseRules() *LanguageParseRules {
	return CPP_PARSE_RULES
}

func (c *CppConfig) TSLanguage() *sitter.Language {
	return cpp.GetLanguage()
}

const CPP_FUNCTION_QUERY = `
(function_definition
  type: (_) @return_type
  declarator: (function_declarator
    declarator: (identifier) @name
    parameters: (parameter_list) @params
  )
  body: (_) @body
) @FUNCTION
    `

var CPP_TS_TO_NODE = map[string]string{
	"compound_statement":   "BLOCK",
	"expression_statement": "INSTRUCTION",
	"return_statement":     "INSTRUCTION",
	"if_statement":         "CONDITIONAL",
	"for_statement":        "FOR",
	"while_statement":      "WHILE",
	"do_statement":         "DO_WHILE",
	"switch_statement":     "SWITCH",
	"case_statement":       "CASE",
	"try_statement":        "TRY",
}

var CPP_PARSE_RULES = &LanguageParseRules{
	IfCondition:       "condition",
	IfConsequence:     "consequence",
	IfAlternative:     "alternative",
	IfAlternativeBody: "compound_statement",
	ForInitializer:    "initializer",
	ForCondition:      "condition",
	ForUpdate:         "update",
	ForBody:           "body",
	WhileCondition:    "condition",
	WhileBody:         "body",
	DoWhileCondition:  "condition",
	DoWhileBody:       "body",
	SwitchCondition:   "condition",
	SwitchBody:        "body",
	CaseValue:         "value",
	TryBody:           "body",
	TryCatch:          "catch_clause",
	TryCatchParams:    "parameters",
	TryCatchBody:      "body",
	Block:             "body",
}
