import {Structogram, StructogramNode} from "@/types/structogram";

export function structogramNewIds(node: StructogramNode) {
    let newNode = new StructogramNode(node.type, new Map(node.data), node.children);
    let id = crypto.randomUUID();
    let children = newNode.children;
    for (let i = 0; i < children.length; i++) {
         children[i] = structogramNewIds(children[i]);
    }
    newNode.id = id;
    return newNode;
}


export async function updateStructogram(structogram: Structogram) {

}
