import { createSlice, PayloadAction } from '@reduxjs/toolkit'
import {StructogramNode} from "@/types/structogram";
import {RootState} from "@/app/editor/store";

// Define a type for the slice state
interface WindowsState {
    value: string[]
}

// Define the initial state using that type
const initialState: WindowsState = {
    value: ["code"],
}

export const windowSlice = createSlice({
    name: 'windows',
    initialState,
    reducers: {
        setWindows: (state, action: PayloadAction<string[]>) => {
            state.value = action.payload
        },
    },
})

export const { setWindows } = windowSlice.actions

export const windows = (state: RootState) => state.windows.value

export default windowSlice.reducer