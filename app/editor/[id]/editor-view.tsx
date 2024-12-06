"use client"

import {ResizableHandle, ResizablePanel, ResizablePanelGroup} from "@/components/ui/resizable";
import {EditorTreeView} from "@/app/editor/[id]/tree-view";
import StructogramCanvas, {StructogramCanvasWithProvider} from "@/app/editor/[id]/structogram-canvas";
import MonacoEditorComponent from "@/app/editor/[id]/code_editor";
import {EditorToolbar} from "@/app/editor/[id]/editor_toolbar";
import {Provider} from "react-redux";
import {store, useAppDispatch, useAppSelector} from "@/app/editor/store";
import {ReactFlowProvider} from "@xyflow/react";


interface EditorViewProps {
    projectData: any;
}

export default function EditorView({projectData}: EditorViewProps) {
    "use client"
    const dispatch = useAppDispatch();
    const windows = useAppSelector((state) => state.windows.value);
        let treeView = [
        <ResizablePanel className={(!windows.includes("tree"))?"hidden":"visible"} defaultSize={20} minSize={10} maxSize={30}>
            <EditorTreeView />
        </ResizablePanel>,
            <ResizableHandle />
];

        let codeView = [
            <ResizableHandle />,
            <ResizablePanel className={(!windows.includes("code"))?"hidden":"visible"} defaultSize={25} minSize={15} maxSize={80}>
                <MonacoEditorComponent/>
            </ResizablePanel>,
        ];
    return (
        <ReactFlowProvider>
        <div className="flex flex-col h-screen">

            <EditorToolbar  projectName="" user=""/>
            <div className="flex-grow flex">
                < ResizablePanelGroup
                    key="resizable-panel-group"
                    direction="horizontal"
                    className="rounded-lg border h-full w-full"
                >
                    {treeView}
                    <ResizablePanel defaultSize={50} minSize={30}>
                        <StructogramCanvas/>
                    </ResizablePanel>
                    {codeView}
                </ResizablePanelGroup>
            </div>
        </div>
        </ReactFlowProvider>
    );
}