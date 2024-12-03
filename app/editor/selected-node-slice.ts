import { createSlice, PayloadAction } from '@reduxjs/toolkit'
import {StructogramNode} from "@/types/structogram";
import {RootState} from "@/app/editor/store";

// Define a type for the slice state
interface SelectedNodeState {
    value: StructogramNode | null
}

// Define the initial state using that type
const initialState: SelectedNodeState = {
    value: null,
}

export const selectedNodeSlice = createSlice({
    name: 'selectedNode',
    initialState,
    reducers: {
        set: (state, action: PayloadAction<StructogramNode | null>) => {
            state.value = action.payload
        },
    },
})

export const { set } = selectedNodeSlice.actions

export const selectCount = (state: RootState) => state.selectedNode.value

export default selectedNodeSlice.reducer