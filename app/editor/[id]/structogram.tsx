"use client"
import React, { memo } from 'react';
import {Handle, Position, Node, NodeProps} from '@xyflow/react';
import {Structogram, StructogramNode} from "@/types/structogram";
import {StructogramBlock} from "@/app/editor/[id]/structogram-node";

interface StructogramProps {
    data: Structogram;
    structogram: Structogram;
    isConnectable: boolean;
}

export type DrawStructogram = Node<
    {
        structogram: Structogram;
        selectedNode: StructogramNode | null;
    },
    'structogram'
>;

export function DrawStructogram(props: NodeProps<DrawStructogram>) {
    return (
        <>
            <div className="bg-white cursor-default dark:bg-zinc-800 rounded-lg px-4 pb-4 pt-2 border dark:border-white border-black">
                <p className="mb-2">{props.data.structogram.functionName}</p>
                {props.data.structogram.nodes.map((node, index) => {
                return <StructogramBlock nonDeletable={props.data.structogram.nodes.length <= 1} selectedNode={props.data.selectedNode} borders={[true, true, index % 2 == 0, (index % 2== 0 || index == props.data.structogram.nodes.length - 1)]} key={node.id} data={node}/>
                })}
            </div>
        </>
    );
}