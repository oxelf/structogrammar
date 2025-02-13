package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"structo/parser"
	"structo/server"
)

func isFlagPassed(name string) bool {
	found := false
	flag.Visit(func(f *flag.Flag) {
		if f.Name == name {
			found = true
		}
	})
	return found
}
func main() {
	img := flag.String("img", "out.png", "convert to img, you can specify a file like this: -img=out.png")
	htmlPath := flag.String("html", "out.html", "convert to html, you can specify a file like this: -html=out.html")
	flag.Parse()
	file := flag.Arg(0)
	funcName := flag.Arg(1)
	input, err := os.ReadFile(file)
	if err != nil {
		fmt.Println(err)
		return
	}
	htmlPassed := isFlagPassed("html")
	imgPassed := isFlagPassed("img")

	errors := parser.QueryErrors(input, &parser.CppConfig{}, nil)
	if len(errors) != 0 && (htmlPassed || imgPassed) {
		fmt.Printf("Found %d errors in %s\n", len(errors), file)
		fmt.Printf("Please fix any syntax errors before generating a structogram\n")
		parser.PrettyPrintErrors(errors)
		return
	}
	funcs := parser.QueryFunctions(input, &parser.CppConfig{}, nil)
	var function *parser.FunctionQueryResult
	for _, f := range funcs {
		if f.Name == funcName {
			function = &f
			break
		}
	}
	if len(funcs) == 1 {
		function = &funcs[0]
	}
	if len(funcs) > 1 && function == nil {
		fmt.Printf("Found %d functions in %s\n", len(funcs), file)
		for _, f := range funcs {
			fmt.Printf("%s %s%s\n", f.ReturnType, f.Name, f.Params)
		}
		fmt.Printf("Please specifiy your function like this: \n structogrammar <file> <function>\n")
		return
	}
	if isFlagPassed("img") {
		Img(input, function, *img)
		return
	}
	if isFlagPassed("html") {
		Html(input, function, *htmlPath)
	}
	f := parser.Parse(input, &parser.CppConfig{}, *function)
	absPath, _ := filepath.Abs(file)
	port := server.StartServer(&f, absPath, errors)
	fmt.Printf("Server started on http://localhost:%d\n", port)
	openUrl(fmt.Sprintf("http://localhost:%d", port))
	for {
	}
}
