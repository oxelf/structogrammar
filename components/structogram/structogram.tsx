import {StructogramBlock} from "@/components/structogram/structogram-node";
import React from "react";
import {Structogram, StructogramNode} from "@/types/structogram";

interface StructogramComponentProps {
    structogram: Structogram;
    selectedNode: StructogramNode | null;
    readOnly: boolean;
}

export function StructogramComponent({structogram, selectedNode, readOnly}: StructogramComponentProps) {
    return (
        <>
            <div className="bg-white cursor-default dark:bg-zinc-800 rounded-lg px-4 pb-4 pt-2 border dark:border-white border-black">
                <p className="mb-2">{structogram.functionName}</p>
                {structogram.nodes.map((node, index) => {
                    return <StructogramBlock selectedNode={selectedNode} readOnly={readOnly} nonDeletable={structogram.nodes.length <= 1}  borders={[true, true, index % 2 == 0, (index % 2== 0 || index == structogram.nodes.length - 1)]} key={node.id} data={node}/>
                })}
            </div>
        </>
    );
}