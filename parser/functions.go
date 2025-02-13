package parser

import (
	"context"
	"structo/util"

	sitter "github.com/smacker/go-tree-sitter"
)

func QueryFunctions(source []byte, lang LanguageConfig, old *sitter.Tree) []FunctionQueryResult {
	p := sitter.NewParser()
	p.SetLanguage(lang.TSLanguage())

	tree, _ := p.ParseCtx(context.Background(), old, []byte(source))
	q, _ := sitter.NewQuery([]byte(lang.FunctionQuery()), lang.TSLanguage())

	qc := sitter.NewQueryCursor()
	qc.Exec(q, tree.RootNode())

	results := []FunctionQueryResult{}

	for {
		m, ok := qc.NextMatch()
		if !ok {
			break
		}

		result := FunctionQueryResult{}

		for _, c := range m.Captures {
			captureName := q.CaptureNameForId(c.Index)

			switch captureName {
			case "FUNCTION":
				result.Node = c.Node
			case "name":
				result.Name = c.Node.Content([]byte(source))
			case "params":
				result.Params = util.RemoveBraces(c.Node.Content([]byte(source)))
			case "return_type":
				result.ReturnType = c.Node.Content([]byte(source))
			}
		}
		results = append(results, result)
	}
	return results
}
