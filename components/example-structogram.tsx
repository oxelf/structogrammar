"use client"
import {Structogram, StructogramNode} from "@/types/structogram";
import {Provider} from "react-redux";
import {store} from "@/app/editor/store";
import Atropos from 'atropos/react';
import 'atropos/css';
import {StructogramComponent} from "@/components/structogram/structogram";
let exampleStructogram =  new Structogram("main", [
    new StructogramNode("instruction", new Map([["value", 'std::cout << "Hello world" << std::endl']]), []),
    new StructogramNode("for", new Map([["condition", "int i = 0; i < 10; i++"]]), [
        new StructogramNode("instruction", new Map([["value", 'std::cout << i << std::endl']]), []),
        new StructogramNode("instruction", new Map([["value", 'std::cout << i * i << std::endl']]), []),
    ]),
    new StructogramNode("instruction", new Map([["value", 'std::cout << "Program exited" << std::endl']]), []),
]);

export function ExampleStructogram() {
    return (
        <>
            <Provider store={store}>
                <Atropos shadow={true}
                         highlight={true}>
                    <div data-atropos-offset="0">
                        <StructogramComponent structogram={exampleStructogram} selectedNode={null} readOnly={true}/>
                    </div>
                </Atropos>
            </Provider>
        </>
    )
}
