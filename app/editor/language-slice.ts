import { createSlice, PayloadAction } from '@reduxjs/toolkit'
import {StructogramNode} from "@/types/structogram";
import {RootState} from "@/app/editor/store";

// Define a type for the slice state
interface CodeLanguageSlice {
    value: string
}

// Define the initial state using that type
const initialState: CodeLanguageSlice = {
    value: "cpp",
}

export const codeLanguageSlice = createSlice({
    name: 'codeLanguage',
    initialState,
    reducers: {
        setLanguage: (state, action: PayloadAction<string>) => {
            state.value = action.payload
        },
    },
})

export const { setLanguage} = codeLanguageSlice.actions

export const codeLanguage = (state: RootState) => state.codeLanguage.value

export default codeLanguageSlice.reducer