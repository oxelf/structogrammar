"use server"
import '@xyflow/react/dist/style.css';
import EditorView from "@/app/editor/[id]/editor-view";
import {Provider} from "react-redux";
import {EditorProvider} from "@/app/editor/[id]/editor-provider";


const initialNodes = [
    { id: '1', position: { x: 0, y: 0 }, data: { label: '1' } },
    { id: '2', position: { x: 0, y: 100 }, data: { label: '2' } },
];
const initialEdges = [{ id: 'e1-2', source: '1', target: '2' }];

export default async function EditorPage({
                                             params,
                                         }: {
    params: Promise<{ id: string }>
}) {
    const data = await params; // Example async operation
    return (
        <EditorProvider>
            <EditorView projectData={data.id} />
        </EditorProvider>
    );
}