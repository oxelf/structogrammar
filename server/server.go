package server

import (
	"html/template"
	"net"
	"net/http"
	"os"
	gostructogram "structo/go_structogram"
	"structo/go_structogram/ast"
	"structo/parser"
	"structo/web"

	"github.com/gin-gonic/gin"
)

type Server struct {
	function    *ast.Function
	absFilePath string
	html        template.HTML
	changeChan  chan int
	errors      []parser.SyntaxError
}

func createListener() (l net.Listener, close func()) {
	l, err := net.Listen("tcp", ":0")
	if err != nil {
		panic(err)
	}
	return l, func() {
		_ = l.Close()
	}
}

func StartServer(function *ast.Function, absFilePath string, initialErrors []parser.SyntaxError) int {
	changeChan := make(chan int)
	s := &Server{function: function, absFilePath: absFilePath, errors: initialErrors, html: template.HTML(gostructogram.Render(function)), changeChan: changeChan}
	gin.SetMode(gin.ReleaseMode)
	router := gin.New()

	tmpl := template.Must(template.New("").ParseFS(web.TemplateFS, "*"))
	router.SetHTMLTemplate(tmpl)

	router.GET("/", func(c *gin.Context) {
		c.HTML(200, "site.tmpl", gin.H{
			"structogram": s.html,
			"css":         template.CSS(gostructogram.CSS()),
		})
	})

	router.GET("/js/sse.js", func(c *gin.Context) {
		content, err := web.TemplateFS.ReadFile("sse.js")
		if err != nil {
			c.String(500, "Error reading file")
			return
		}
		c.Data(200, "application/javascript", content)
	})
	router.GET("/js/htmx.min.js", func(c *gin.Context) {
		content, err := web.TemplateFS.ReadFile("htmx.min.js")
		if err != nil {
			c.String(500, "Error reading file")
			return
		}
		c.Data(200, "application/javascript", content)
	})

	router.GET("/change", HeadersMiddleware(), s.changeStream)

	router.GET("/errors", func(c *gin.Context) {
		if len(s.errors) == 0 || s.errors == nil {
			c.String(200, "")
			return
		}
		c.HTML(200, "errors.tmpl", gin.H{
			"errors": s.errors,
		})
	})

	router.GET("/structogram", func(c *gin.Context) {
		fileContent, err := os.ReadFile(s.absFilePath)
		if err != nil {
			c.String(500, "Error reading file")
			return
		}
		errors := parser.QueryErrors(fileContent, &parser.CppConfig{}, nil)
		s.errors = errors
		if len(errors) != 0 {
			c.String(500, "Error parsing file")
			return
		}
		funcs := parser.QueryFunctions(fileContent, &parser.CppConfig{}, nil)
		var res parser.FunctionQueryResult
		for _, f := range funcs {
			if f.Name == s.function.Name {
				res = f
				break
			}
		}
		parsedFunc := parser.Parse(fileContent, &parser.CppConfig{}, res)
		html := gostructogram.Render(&parsedFunc)
		c.String(200, html)
		return
	})

	l, _ := createListener()

	go s.listen(absFilePath)
	go http.Serve(l, router)
	return l.Addr().(*net.TCPAddr).Port
}
