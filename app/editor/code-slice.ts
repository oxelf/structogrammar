import { createSlice, PayloadAction } from '@reduxjs/toolkit'
import {StructogramNode} from "@/types/structogram";
import {RootState} from "@/app/editor/store";

// Define a type for the slice state
interface CodeSlice {
    value: string
}

// Define the initial state using that type
const initialState: CodeSlice = {
    value: "int main() {}",
}

export const codeSlice = createSlice({
    name: 'codeLanguage',
    initialState,
    reducers: {
        setCode: (state, action: PayloadAction<string>) => {
            state.value = action.payload
        },
    },
})

export const { setCode} = codeSlice.actions

export const code = (state: RootState) => state.code.value

export default codeSlice.reducer