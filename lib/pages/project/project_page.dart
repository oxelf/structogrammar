
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/pages/struct_editor/struct_editor.dart';
import 'package:structogrammar/riverpod/projects.dart';
import 'package:structogrammar/util/app_colors.dart';

class ProjectPage extends ConsumerStatefulWidget {
  const ProjectPage({super.key, required this.projectId});

  final int projectId;

  @override
  ConsumerState createState() => _ProjectPageState();
}

class _ProjectPageState extends ConsumerState<ProjectPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // cppParser.parseTree('int main() {cout << "Hello World"; return 1;}');
    // TreeSitterConfig.setLibraryPath(path.join(Directory.current.path, 'libtree-sitter.dylib'));
    // final parser =
    // Parser(sharedLibrary: 'cpp.dylib', entryPoint: 'tree_sitter_cpp');
    // final program = "class A {}";
    // final tree = parser.parse(program);
    // print(tree.root.string);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //var projects = ref.watch(projectsPod);
    // var index = projects.indexWhere((e) => e.projectId == widget.projectId);
    // if (index == -1) {
    //   return Center(
    //     child: Text("This project was not found"),
    //   );
    // }
    // var project = projects[index];
    var projectStream = ref.watch(projectPod(widget.projectId));
    return projectStream.when(
        data: (project) {
          StructHead? struct = project.struct.value;
          return Scaffold(
            backgroundColor: AppColors.editorBackground,
            body: StructEditor(
              struct: struct!.toStruct(),
              projectId: widget.projectId,
            ),
          );
        },
        error: (e, s) => const Center(
              child: Text("Something went wrong"),
            ),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }

  @override
  bool get wantKeepAlive => true;
}
