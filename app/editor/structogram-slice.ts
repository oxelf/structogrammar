import {createSlice, PayloadAction} from '@reduxjs/toolkit'
import {Structogram, StructogramNode} from "@/types/structogram";
import {RootState} from "@/app/editor/store";
import {structogramNewIds} from "@/app/editor/structogram-util"

// Define a type for the slice state
interface StructogramState {
    value: Structogram[]
}

const initialState: StructogramState = {
    value: [
        new Structogram("main",
            [{
                id: crypto.randomUUID(),
                type: "instruction",
                data: new Map([["value", "int a = 0;"]]),
                children: []
            },
                {
                    id: crypto.randomUUID(),
                    type: "for",
                    data: new Map([["condition", "int i = 0; i < list.lengthijfdjkjdkdfjkdfjdfkjdf; i++"]]),
                    children: [
                        {
                            id: crypto.randomUUID(),
                            type: "instruction",
                            data: new Map([["value", "a += list[i];"]]),
                            children: [],
                        },
                        {
                            id: crypto.randomUUID(),
                            type: "for",
                            data: new Map([["condition", "int i = 0; i < list.lengthijfdjkjdkdfjkdfjdfkjdf; i++"]]),
                            children: [
                                {
                                    id: crypto.randomUUID(),
                                    type: "instruction",
                                    data: new Map([["value", "a += list[i];"]]),
                                    children: [],
                                },
                                {
                                    id: crypto.randomUUID(),
                                    type: "instruction",
                                    data: new Map([["value", "a += list[i];"]]),
                                    children: [],
                                },
                            ]
                        },
                        {
                            id: crypto.randomUUID(),
                            type: "instruction",
                            data: new Map([["value", "a += list[i];"]]),
                            children: [],
                        },
                    ]
                },
                {
                    id: crypto.randomUUID(),
                    type: "instruction",
                    data: new Map([["value", "return 0;"]]),
                    children: []
                },
            ] ),
    ]
}

export const structogramSlice = createSlice({
    name: 'structograms',
    initialState,
    reducers: {
        setStructograms: (state, action: PayloadAction<Structogram[]>) => {
            state.value = action.payload
        },
       addStructogram: (state, action: PayloadAction<Structogram>) => {
            state.value = [...state.value, action.payload];
       },
        setNode: (state, action: PayloadAction<StructogramNode>) => {

            const id = action.payload.id;
            const newNode = action.payload;
            const copy = state.value.map(structogram => ({
                ...structogram,
                nodes: structogram.nodes.map(node => ({ ...node }))
            }));

            function recursivelySetNode(node: StructogramNode, id: String, newNode: StructogramNode): StructogramNode {
                if (node.id === id) {
                    return newNode;
                }
                return {
                    ...node,
                    children: node.children.map(child => recursivelySetNode(child, id, newNode))
                };
            }

            for (let i = 0; i < copy.length; i++) {
                copy[i].nodes = copy[i].nodes.map(node => recursivelySetNode(node, id, newNode));
            }

            state.value = copy;
        } ,
        insertAfter: (state, action: PayloadAction<{ node: StructogramNode, after: String }>) => {
            let id = action.payload.after;
            let newNode = structogramNewIds(action.payload.node);
            let copy = state.value.map(structogram => ({
                ...structogram,
                nodes: structogram.nodes.map(node => ({...node}))
            }));

            function recursivelyInsertAfter(node: StructogramNode, id: String, newNode: StructogramNode): boolean {
                for (let i = 0; i < node.children.length; i++) {
                    if (node.children[i].id == id) {
                        node.children = [...node.children.slice(0, i + 1), newNode, ...node.children.slice(i + 1)];
                        return true;
                    }
                    if (recursivelyInsertAfter(node.children[i], id, newNode)) {
                        node.children = [...node.children];
                        return true;
                    }
                }
                return false;
            }

            for (let i = 0; i < copy.length; i++) {
                for (let j = 0; j < copy[i].nodes.length; j++) {
                    if (copy[i].nodes[j].id == id) {
                        copy[i].nodes = [...copy[i].nodes.slice(0, j + 1), newNode, ...copy[i].nodes.slice(j + 1)];
                        state.value = copy;
                        return;
                    }
                    if (recursivelyInsertAfter(copy[i].nodes[j], id, newNode)) {
                        state.value = copy;
                        return;
                    }
                }
            }
            state.value = copy;
        },
        insertBefore: (state, action: PayloadAction<{ node: StructogramNode, before: String }>) => {
            let id = action.payload.before;
            let newNode = structogramNewIds(action.payload.node);
            let copy = state.value.map(structogram => ({
                ...structogram,
                nodes: structogram.nodes.map(node => ({...node}))
            }));

            function recursivelyInsertBefore(node: StructogramNode, id: String, newNode: StructogramNode): boolean {
                for (let i = 0; i < node.children.length; i++) {
                    if (node.children[i].id == id) {
                        node.children = [...node.children.slice(0, i), newNode, ...node.children.slice(i)];
                        return true;
                    }
                    if (recursivelyInsertBefore(node.children[i], id, newNode)) {
                        node.children = [...node.children];
                        return true;
                    }
                }
                return false;
            }

            for (let i = 0; i < copy.length; i++) {
                for (let j = 0; j < copy[i].nodes.length; j++) {
                    if (copy[i].nodes[j].id == id) {
                        copy[i].nodes = [...copy[i].nodes.slice(0, j), newNode, ...copy[i].nodes.slice(j)];
                        state.value = copy;
                        return;
                    }
                    if (recursivelyInsertBefore(copy[i].nodes[j], id, newNode)) {
                        state.value = copy;
                        return;
                    }
                }
            }
            state.value = copy;
        },
        setNodePosition: (state, action: PayloadAction<{ id: String, x: number, y: number }>) => {
            state.value = state.value.map(structogram => ({
                ...structogram,
                nodes: structogram.nodes.map(node => {
                    if (node.id == action.payload.id) {
                        return {
                            ...node,
                            x: action.payload.x,
                            y: action.payload.y
                        }
                    }
                    return node;
                })
            }));
        },
        deleteNode: (state, action: PayloadAction<String>) => {
            let id = action.payload;
            let copy = state.value.map(structogram => ({
                ...structogram,
                nodes: structogram.nodes.map(node => ({ ...node }))
            }));

            function recursivelyDeleteNode(node: StructogramNode, id: String): boolean {
                for (let i = 0; i < node.children.length; i++) {
                    if (node.children[i].id == id) {
                        node.children = [...node.children.slice(0, i), ...node.children.slice(i + 1)];
                        return true;
                    }
                    if (recursivelyDeleteNode(node.children[i], id)) {
                        node.children = [...node.children];
                        return true;
                    }
                }
                return false;
            }

            for (let i = 0; i < copy.length; i++) {
                for (let j = 0; j < copy[i].nodes.length; j++) {
                    if (copy[i].nodes[j].id == id) {
                        copy[i].nodes = [...copy[i].nodes.slice(0, j), ...copy[i].nodes.slice(j + 1)];
                        state.value = copy;
                        return;
                    }
                    if (recursivelyDeleteNode(copy[i].nodes[j], id)) {
                        state.value = copy;
                        return;
                    }
                }
            }
            state.value = copy;
        },
    }
})

export const { setNode, setNodePosition, addStructogram, deleteNode, setStructograms, insertAfter, insertBefore } = structogramSlice.actions

export const structograms = (state: RootState) => state.structograms.value

export default structogramSlice.reducer