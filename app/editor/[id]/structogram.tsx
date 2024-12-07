"use client"
import React, { memo } from 'react';
import {Handle, Position, Node, NodeProps} from '@xyflow/react';
import {Structogram, StructogramNode} from "@/types/structogram";
import {useAppSelector} from "@/app/editor/store";
import {StructogramComponent} from "@/components/structogram/structogram";

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
            <StructogramComponent structogram={props.data.structogram} selectedNode={selectedNode} readOnly={props.data.readOnly}/>
        </>
    );
}