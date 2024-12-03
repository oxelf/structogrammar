export class Structogram {
    public id: string = crypto.randomUUID();
    public functionName: string = "";
    public nodes: StructogramNode[] = [];

    constructor(functionName:string, nodes:StructogramNode[]) {
        this.functionName = functionName;
        this.nodes = nodes;
    }
}

export type structogramNodeType = "instruction" | "for" | "while" | "do-while" | "if";

export class StructogramNode {
    public id: string = crypto.randomUUID();
    public type: structogramNodeType = "instruction";
    public data: Map<string, any> = new Map();
    public children: StructogramNode[] = [];
}