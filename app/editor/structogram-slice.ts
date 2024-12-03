import { createSlice, PayloadAction } from '@reduxjs/toolkit'
import {Structogram, StructogramNode} from "@/types/structogram";
import {RootState} from "@/app/editor/store";
import {structogramNewIds} from "@/app/editor/structogram-util";

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
                            type: "while",
                            data: new Map([["condition", "int i = 0; i < list.lengthijfdjkjdkdfjkdfjdfkjdf; i++"]]),
                            children: [
                                {
                                    id: crypto.randomUUID(),
                                    type: "instruction",
                                    data: new Map([["value", "a += list[i];"]]),
                                    children: [],
                                },
                            ],
                        },
                        {
                            id: crypto.randomUUID(),
                            type: "if",
                            data: new Map([["condition", "a == 1"]]),
                            children: [
                                {
                                    id: crypto.randomUUID(),
                                    type: "instruction",
                                    data: new Map([["value", `a += list[i]jfkdjfkdfjkjdfkdjkdfjjdkcjdlkcj;`], ["condition", "true"]]),
                                    children: [],
                                },
                                {
                                    id: crypto.randomUUID(),
                                    type: "instruction",
                                    data: new Map([["value", "a += list[i];"], ["condition", "false"]]),
                                    children: [],
                                },
                                {
                                    id: crypto.randomUUID(),
                                    type: "instruction",
                                    data: new Map([["value", "a += list[i];"], ["condition", "false"]]),
                                    children: [],
                                },
                                {
                                    id: crypto.randomUUID(),
                                    type: "instruction",
                                    data: new Map([["value", "a += list[i];"], ["condition", "true"]]),
                                    children: [],
                                },
                                {
                                    id: crypto.randomUUID(),
                                    type: "instruction",
                                    data: new Map([["value", "a += list[i];"], ["condition", "true"]]),
                                    children: [],
                                },
                            ],
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
                {
                    id: crypto.randomUUID(),
                    type: "if",
                    data: new Map([["condition", "a == 1"]]),
                    children: [
                        {
                            id: crypto.randomUUID(),
                            type: "instruction",
                            data: new Map([["value", "a += list[i];"], ["condition", "true"]]),
                            children: [],
                        },
                        {
                            id: crypto.randomUUID(),
                            type: "instruction",
                            data: new Map([["value", "a += list[i];"], ["condition", "false"]]),
                            children: [],
                        },
                    ],
                },
            ] ),
    ]
}

export const structogramSlice = createSlice({
    name: 'structograms',
    initialState,
    reducers: {
        set: (state, action: PayloadAction<Structogram[]>) => {
            state.value = action.payload
        },
        setNode: (state, action: PayloadAction<StructogramNode>) => {
            let id = action.payload.id;
            let copy = state.value;
            function recursivelySetNode(node: StructogramNode, id: String, newNode: StructogramNode) {
                for (let i = 0; i < node.children.length; i++) {
                    if (node.children[i].id == id) {
                        node.children[i] = newNode;
                        return;
                    }
                    recursivelySetNode(node.children[i], id, newNode);
                }
            }

            for (let i = 0; i < copy.length; i++) {
                for (let j = 0; j < copy[i].nodes.length; j++) {
                    if (copy[i].nodes[j].id == id) {
                        copy[i].nodes[j] = action.payload;
                        return;
                    }
                    recursivelySetNode(copy[i].nodes[j], id, action.payload);
                }
            }
            state.value = copy;
        },
        insertAfter: (state, action: PayloadAction<{ node: StructogramNode, after: String }>) => {
            let id = action.payload.after;
            let newNode = structogramNewIds(action.payload.node)
            let copy = state.value;


            function recursivelyInsertAfter(node: StructogramNode, id: String, newNode: StructogramNode): boolean {
                for (let i = 0; i < node.children.length; i++) {
                    if (node.children[i].id == id) {
                        node.children.splice(i + 1, 0, newNode);
                        return true;
                    }
                    if (recursivelyInsertAfter(node.children[i], id, newNode)) {
                        return true;
                    }
                }
                return false;
            }

            for (let i = 0; i < copy.length; i++) {
                for (let j = 0; j < copy[i].nodes.length; j++) {
                    if (copy[i].nodes[j].id == id) {
                        copy[i].nodes.splice(j + 1, 0, newNode);
                        state.value = [...copy];
                        return;
                    }
                    if (recursivelyInsertAfter(copy[i].nodes[j], id, newNode)) {
                        state.value = [...copy];
                        return;
                    }
                }
            }
            state.value = copy;
        },
    deleteNode: (state, action: PayloadAction<String>) => {
            let id = action.payload;
            let copy = state.value;

            function recursivelyDeleteNode(node: StructogramNode, id: String): boolean {
                for (let i = 0; i < node.children.length; i++) {
                    if (node.children[i].id == id) {
                        node.children.splice(i, 1);
                        return true;
                    }
                    if (recursivelyDeleteNode(node.children[i], id)) {
                        return true;
                    }
                }
                return false;
            }

            for (let i = 0; i < copy.length; i++) {
                for (let j = 0; j < copy[i].nodes.length; j++) {
                    if (copy[i].nodes[j].id == id) {
                        copy[i].nodes.splice(j, 1);
                        state.value = [...copy];
                        return;
                    }
                    if (recursivelyDeleteNode(copy[i].nodes[j], id)) {
                        state.value = [...copy];
                        return;
                    }
                }
            }
            state.value = copy;
        }
    }
})

export const { setNode,deleteNode, set, insertAfter } = structogramSlice.actions

export const structograms = (state: RootState) => state.structograms.value

export default structogramSlice.reducer