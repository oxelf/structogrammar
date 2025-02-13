package parser

import (
	"context"
	"fmt"
	"strings"

	"github.com/fatih/color"
	sitter "github.com/smacker/go-tree-sitter"
)

const ErrorQuery = `
(ERROR) @error-node
  `

func PrettyPrintErrors(errors []SyntaxError) {
	for _, e := range errors {
		fmt.Println()
		lineNumberStringLen := len(fmt.Sprintf("%d", e.LineNumber+1))
		fmt.Printf("%s|\n", strings.Repeat(" ", lineNumberStringLen))
		fmt.Printf("%d|%s\n", e.LineNumber+1, e.Line)
		fmt.Printf("%s|%s%s", strings.Repeat(" ", lineNumberStringLen), strings.Repeat(" ", e.LineColumn-1), color.RedString("^"))
		color.Red("\nError at %d:%d : %s\n", e.LineNumber+1, e.LineColumn+1, e.Message)
	}
}

type SyntaxError struct {
	Message    string
	Line       string
	LineNumber int
	LineColumn int
}

func getLine(source []byte, line int) string {
	last := 0
	lastLine := 0
	for i, c := range source {
		if c == '\n' {
			if lastLine == line {
				return string(source[last:i])
			}
			lastLine++
			last = i + 1
		}
	}
	return ""
}

func QueryErrors(source []byte, lang LanguageConfig, old *sitter.Tree) []SyntaxError {
	errors := []SyntaxError{}
	p := sitter.NewParser()
	p.SetLanguage(lang.TSLanguage())

	tree, _ := p.ParseCtx(context.Background(), old, []byte(source))
	q, err := sitter.NewQuery([]byte(ErrorQuery), lang.TSLanguage())
	if err != nil || q == nil {
		return errors
	}

	qc := sitter.NewQueryCursor()
	qc.Exec(q, tree.RootNode())

	for {
		m, ok := qc.NextMatch()
		if !ok {
			break
		}

		result := SyntaxError{}

		for _, c := range m.Captures {
			captureName := q.CaptureNameForId(c.Index)

			switch captureName {
			case "error-node":
				result.Message = "Syntax error"
				result.Line = getLine(source, int(c.Node.StartPoint().Row))
				result.LineNumber = int(c.Node.StartPoint().Row)
				result.LineColumn = int(c.Node.StartPoint().Column)
			case "missing-node":
				result.Message = "Missing error"
				result.Line = string(source[c.Node.StartByte():c.Node.EndByte()])
				result.LineNumber = int(c.Node.StartPoint().Row)
				result.LineColumn = int(c.Node.StartPoint().Column)
			}
		}
		errors = append(errors, result)
	}
	return errors
}
