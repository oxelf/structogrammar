"use client"
import React, { memo } from 'react';
import {Handle, Position, Node, NodeProps} from '@xyflow/react';
import {Structogram, StructogramNode} from "@/types/structogram";
import {StructogramBlock} from "@/app/editor/[id]/structogram-node";
import {useAppSelector} from "@/app/editor/store";

interface StructogramProps {
    data: Structogram;
    structogram: Structogram;
    isConnectable: boolean;
}

export type DrawStructogram = Node<
    {
        structogram: Structogram;
        readOnly: boolean;
    },
    'structogram'
>;

export function DrawStructogram(props: NodeProps<DrawStructogram>) {
    console.log("drawing structogram: ", props.data.structogram);
    let selectedNode = null;
    if (!props.data.readOnly) {
        selectedNode = useAppSelector((state) => state.selectedNode.value);
    }
    return (
        <>
            <div className="bg-white cursor-default dark:bg-zinc-800 rounded-lg px-4 pb-4 pt-2 border dark:border-white border-black">
                <p className="mb-2">{props.data.structogram.functionName}</p>
                {props.data.structogram.nodes.map((node, index) => {
                return <StructogramBlock selectedNode={selectedNode} readOnly={props.data.readOnly} nonDeletable={props.data.structogram.nodes.length <= 1}  borders={[true, true, index % 2 == 0, (index % 2== 0 || index == props.data.structogram.nodes.length - 1)]} key={node.id} data={node}/>
                })}
            </div>
        </>
    );
}