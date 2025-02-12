package parser

import "testing"

func TestParser(t *testing.T) {
	input := `
    #include <iostream>
    int main(int m)  {
    return 0;
    }`
	Parse(input, "main")
}
