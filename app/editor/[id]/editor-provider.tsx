"use client"
import {Provider} from "react-redux";
import {store, useAppDispatch, useAppSelector} from "@/app/editor/store";
export function EditorProvider({
                                   children,
                               }: React.PropsWithChildren) {
    return <Provider store={store}>
        {children}
    </Provider>
}
