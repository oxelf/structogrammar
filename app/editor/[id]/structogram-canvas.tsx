import React, { useState, useEffect } from 'react';
import {Background, BackgroundVariant, ColorMode, Controls, MiniMap, ReactFlow} from '@xyflow/react';
import '@xyflow/react/dist/style.css';
import { useTheme } from 'next-themes';
import { DrawStructogram } from '@/app/editor/[id]/structogram';
import {useAppDispatch, useAppSelector} from "@/app/editor/store";

const initialNodes = [
    { id: '1', type: 'structogram', position: { x: 0, y: 0 }, data: { label: '1' } },
];
const nodeTypes = {
    structogram: DrawStructogram,
};
const defaultViewport = { x: 0, y: 0, zoom: 1.5, maxZoom: 3 };

interface StructogramCanvasProps {
}

export default function StructogramCanvas({}: StructogramCanvasProps) {
    'use client';
    const dispatch = useAppDispatch();
    const structograms = useAppSelector((state) => state.structograms.value);
    console.log("structograms update: ", structograms);
    const { theme } = useTheme();
    const [clientTheme, setClientTheme] = useState<string | undefined>(undefined);

    useEffect(() => {
        setClientTheme(theme);
    }, [theme]);

    if (clientTheme === undefined) {
        return null;
    }


    const colorMode = clientTheme === 'dark' ? 'dark' : 'light';
    return (
        <div className="z-0 w-full h-full">
            <ReactFlow
                fitViewOptions={{ duration: 250 }}
                proOptions={{ hideAttribution: true }}
                nodeTypes={nodeTypes}
                colorMode={colorMode as ColorMode}  // Use the client-side theme dynamically
                panOnScroll={true}
                fitView={true}
                defaultViewport={defaultViewport}
                selectionOnDrag={true}
                nodes={structograms.map((structogram, index) => {
                    return {
                        id: index.toString(),
                        type: 'structogram',
                        position: { x: 0, y: 0 },
                        data: {  label: structogram.functionName, structogram: structogram },
                    };
                })}
            >
                <Background variant={BackgroundVariant.Dots} gap={12} size={1} />
                <MiniMap />
                <Controls />
            </ReactFlow>
        </div>
    );
}