const Parser = require('tree-sitter');
const Cpp = require('tree-sitter-cpp');

// Initialize a new Tree Sitter parser
const parser = new Parser();
parser.setLanguage(Cpp);

// C++ code to parse
const code = `
#include <iostream>

int main() {
    std::cout << "Hello, world!" << std::endl;
    return 0;
}
`;

// Parse the code
const tree = parser.parse(code);

// Print out the syntax tree
console.log('Syntax Tree:', tree.rootNode.toString());

// Traverse the tree and print each node's type
function printNode(node, indent = 0) {
    console.log(`${' '.repeat(indent)}${node.type}`);
    node.children.forEach(child => printNode(child, indent + 2));
}

printNode(tree.rootNode);