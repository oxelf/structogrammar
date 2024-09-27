# structogrammar

A new Flutter project.

## Building Tree Sitter for Windows ##
I was losing my sanity about this.

tree-sitter.dll:
- put this at the top of the lib/include/tree-sitter/api.h: #define EXPORT __declspec(dllexport)
- then export every function or constant using EXPORT. 
- use x64 Native Tools Command Prompt for VS 2022
- cl /c lib\src\lib.c /Ilib\src /Ilib\include /Fo:lib.obj
- cl /LD lib\src\lib.c /Ilib\src /Ilib\include /Fe:tree-sitter.dll

cpp.dll:
- download tree-sitter cli from here: https://github.com/tree-sitter/tree-sitter/releases/tag/v0.23.0
- clone grammar repository: https://github.com/tree-sitter/tree-sitter-cpp.git
- put the tree-sitter.exe cli in the root of the grammar repository.
- run tree-sitter.exe init-config
- run tree-sitter.exe build

  




