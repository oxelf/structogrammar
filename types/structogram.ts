export class Structogram {
    public id: string = crypto.randomUUID();
    public functionName: string = "";
    public nodes: StructogramNode[] = [];
    public x: number = 0;
    public y: number = 0;

    constructor(functionName:string, nodes:StructogramNode[], x: number = 0, y: number = 0) {
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

    constructor(type:structogramNodeType, data:Map<string, any>, children:StructogramNode[]) {
        this.id = crypto.randomUUID();
        this.type = type;
        this.data = data;
        this.children = children;
    }
}