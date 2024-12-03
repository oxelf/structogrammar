"use client"
import {StructogramNode} from "@/types/structogram";
import {AppDispatch, RootState,  useAppDispatch, useAppSelector} from "@/app/editor/store";
import {set} from "@/app/editor/selected-node-slice";
import {
    ContextMenu,
    ContextMenuContent,
    ContextMenuItem, ContextMenuSeparator, ContextMenuShortcut,
    ContextMenuSub, ContextMenuSubContent, ContextMenuSubTrigger,
    ContextMenuTrigger
} from "@/components/ui/context-menu";
import {useState} from "react";
import {deleteNode, insertAfter, setNode} from "@/app/editor/structogram-slice";
import {
    getBorderStyle,
    inputStyle,
    childrenStyle, titleStyleNormal, titleStyleSelected, blockStyleNormal, blockStyleSelected,
} from "@/app/editor/[id]/(structogram-components)/style";

interface StructogramBlockProps {
    data: StructogramNode;
    selectedNode: StructogramNode | null;
    borders: [boolean, boolean, boolean, boolean];
    nonDeletable: boolean;
}

export function StructogramBlock({data, borders}: StructogramBlockProps) {
    const [localData, setLocalData] = useState(data.data);
    let [editing, setEditing] = useState(false);
    const dispatch = useAppDispatch();
    const selectedNode = useAppSelector((state) => state.selectedNode.value);
    let borderStyle = getBorderStyle(borders);

    let titleStyle = titleStyleNormal;
    let blockStyle = blockStyleNormal;
    if (selectedNode?.id == data.id ) {
        titleStyle = titleStyleSelected;
        blockStyle = blockStyleSelected;
    } else {
        editing = false
    }


    function onSelected() {
        console.log("inner tap on " + data.id);
        dispatch(set(data));
    }

    function onEdit() {
        setEditing(true);
    }

    function duplicateNode() {
        let newNode = new StructogramNode()
        newNode.type = data.type
        newNode.data = new Map(data.data)
        newNode.children = data.children
        dispatch(insertAfter({after: data.id,node: newNode}))
    }

    function deleteNodeFunc() {
        dispatch(deleteNode(data.id))
    }

    let contextMenuContent =
        <ContextMenuContent className="w-64">
            <ContextMenuItem onSelect={duplicateNode} inset>
                Duplizieren
            </ContextMenuItem>
            <ContextMenuItem onSelect={deleteNodeFunc} inset>
                Löschen
            </ContextMenuItem>
            <ContextMenuSeparator/>
            <ContextMenuSub>
                <ContextMenuSubTrigger inset>Davor einfügen</ContextMenuSubTrigger>
                <ContextMenuSubContent className="w-48">
                    <ContextMenuItem onSelect={() => {
                        let newNode = new StructogramNode()
                        newNode.type = "instruction"
                        newNode.data = new Map([["value", "a += list[i];"]])
                        dispatch(insertAfter({after: data.id,node: newNode}))
                    }}>
                        Anweisung
                    </ContextMenuItem>
                    <ContextMenuSeparator/>
                    <ContextMenuItem>Bedingte Verzweigung</ContextMenuItem>
                    <ContextMenuItem>Fall Auswahl</ContextMenuItem>
                    <ContextMenuSeparator />
                    <ContextMenuItem>Zählschleife</ContextMenuItem>
                    <ContextMenuItem>Solange Schleife</ContextMenuItem>
                    <ContextMenuItem>Bis Schleife</ContextMenuItem>
                </ContextMenuSubContent>
            </ContextMenuSub>
            <ContextMenuSub>
                <ContextMenuSubTrigger inset>Danach einfügen</ContextMenuSubTrigger>
                <ContextMenuSubContent className="w-48">
                    <ContextMenuItem onSelect={() => {
                        console.log("instruction");
                        let newNode = new StructogramNode()
                        newNode.type = "instruction"
                        newNode.data = new Map([["value", "a += list[i];"]])
                        console.log("inserting: ", newNode);
                        dispatch(insertAfter({after: data.id,node: newNode}))
                    }}>
                        Anweisung
                    </ContextMenuItem>
                    <ContextMenuSeparator/>
                    <ContextMenuItem>Bedingte Verzweigung</ContextMenuItem>
                    <ContextMenuItem>Fall Auswahl</ContextMenuItem>
                    <ContextMenuSeparator />
                    <ContextMenuItem>Zählschleife</ContextMenuItem>
                    <ContextMenuItem>Solange Schleife</ContextMenuItem>
                    <ContextMenuItem>Bis Schleife</ContextMenuItem>
                </ContextMenuSubContent>
            </ContextMenuSub>
        </ContextMenuContent>

    if (data.type == "for" || data.type == "while") {
        return (
            <>
                <ContextMenu>
                    {contextMenuContent}
                    <div className={borderStyle}>
                        <div>
                            <ContextMenuTrigger>
                                <div onClick={onSelected} onDoubleClick={onEdit} className={titleStyle}>
                                    {
                                        (editing)?<input onChange={(value) => {
                                                const updatedLocalData = new Map(localData);
                                                updatedLocalData.set("condition", value.target.value);
                                                setLocalData(updatedLocalData);
                                            }}
                                                         onBlur={() => {
                                                             const updatedData = { ...data, data: new Map(localData) };
                                                             dispatch(setNode(updatedData))                                    }}
                                                         onKeyDown={(event) => {
                                                             if (event.key === "Escape" || event.key === "Enter") {
                                                                 event.currentTarget.blur(); // Lose focus on Esc or Enter
                                                                 setEditing(false)
                                                                 const updatedData = {...data, data: new Map(localData)};
                                                                 dispatch(setNode(updatedData))
                                                             }
                                                         }}
                                                         className={inputStyle} value={localData.get("condition")}></input>
                                            :<div>{localData.get("condition")}</div>
                                    }
                                </div>
                            </ContextMenuTrigger>
                            <div className="flex flex-row flex-grow">
                                <div onClick={onSelected} className={blockStyle}>
                                </div>
                                <div className={childrenStyle}>
                                    {data.children.map((node, index) => {
                                        return <StructogramBlock selectedNode={selectedNode} borders={[true, false, index % 2 == 0, (index % 2== 0 && index != data.children.length - 1)]} key={node.id} data={node}/>
                                    })}
                                </div>
                            </div>
                        </div>
                    </div>
                </ContextMenu>
            </>
        );
    }
    if (data.type == "if") {
        let trueChildren = data.children.filter((e) => e.data.get("condition") == "true");
        let falseChildren = data.children.filter((e) => e.data.get("condition") == "false");
        return (
            <>
                <div className={borderStyle}>
                    <div>
                        <div onClick={onSelected} className={titleStyle}>{data.data.get("condition")}</div>
                        <div className="flex flex-row">
                            <div className={childrenStyle}>
                                {trueChildren.map((node, index) => {
                                    return <StructogramBlock  selectedNode={selectedNode} borders={[false, false, index % 2 == 0, (index % 2== 0 && index != trueChildren.length - 1)]} key={node.id} data={node}/>
                                })}
                            </div>
                            <div className="w-0.5 flex flex-col">
                                <div className="w-0.5 h-full border-l dark:border-l-white border-l-black"></div>
                            </div>
                            <div className={childrenStyle}>
                                {falseChildren.map((node, index) => {
                                    return <StructogramBlock selectedNode={selectedNode} borders={[false, false, index % 2 == 0, (index % 2== 0 && index != falseChildren.length - 1)]} key={node.id} data={node}/>
                                })}
                            </div>
                        </div>
                    </div>
                </div>
            </>
        );
    }
    return (
        <>
            <div onClick={onSelected} className={borderStyle + " box-border"}>
                <div className={titleStyle}>{data.data.get("value")}</div>
            </div>
        </>
    );
}