"use client"
import { StructogramNode } from "@/types/structogram";

export function structogramNewIds(node: StructogramNode): StructogramNode {
    let newNode = {
        ...node,
        data: new Map(node.data),
        children: node.children.map(child => structogramNewIds(child))
    };

    newNode.id = crypto.randomUUID();

    return newNode;
}


