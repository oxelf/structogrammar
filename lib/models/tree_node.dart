class TreeNode {
  final String type;
  final String data;
  final String? condition;
  final List<TreeNode> nodes;

  TreeNode({required this.data,required this.type, required this.nodes, this.condition});

  factory TreeNode.fromJson(Map<String, dynamic> json) {
    List<TreeNode> nodes = [];
    List<dynamic> jsonNodes = [];
    if (json["nodes"] != null) {
      jsonNodes = json["nodes"];
    }
    for (int i = 0;  i < jsonNodes.length; i++) {
      nodes.add(TreeNode.fromJson(jsonNodes[i]));
    }
    return TreeNode(type: json["type"] ?? "instruction", data: json["data"]?? "", nodes: nodes, condition: json["condition"]);
  }
}