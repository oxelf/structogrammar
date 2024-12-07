"use client"
import {StructogramNode} from "@/types/structogram";
import {useAppDispatch} from "@/app/editor/store";
import {setSelectedNode} from "@/app/editor/selected-node-slice";
import {
    ContextMenu,
    ContextMenuContent,
    ContextMenuItem, ContextMenuSeparator,
    ContextMenuSub, ContextMenuSubContent, ContextMenuSubTrigger,
} from "@/components/ui/context-menu";
import {useState} from "react";
import {deleteNode, insertAfter, insertBefore} from "@/app/editor/structogram-slice";
import {
    getBorderStyle, titleStyleNormal, titleStyleSelected, blockStyleNormal, blockStyleSelected,
} from "@/components/structogram/style";
import {LoopComponent} from "@/components/structogram/for-node";
import {InstructionComponent} from "@/components/structogram/instruction-node";
import {
    getForTemplate,
    getIfTemplate,
    getInstructionTemplate, getWhileTemplate
} from "@/components/structogram/templates";
import {IfComponent} from "@/components/structogram/if-node";

interface StructogramBlockProps {
    data: StructogramNode;
    borders: [boolean, boolean, boolean, boolean];
    nonDeletable: boolean;
    selectedNode: StructogramNode | null;
    readOnly: boolean;
}

export function StructogramBlock({data, nonDeletable, selectedNode, borders, readOnly}: StructogramBlockProps) {
    const [localData, setLocalData] = useState(data.data);
    let [editing, setEditing] = useState(false);
    const dispatch = useAppDispatch();
    let borderStyle = getBorderStyle(borders);

    let titleStyle = titleStyleNormal;
    let blockStyle = blockStyleNormal;
    if (selectedNode?.id == data.id) {
        titleStyle = titleStyleSelected;
        blockStyle = blockStyleSelected;
    } else {
        editing = false
    }


    function onSelected() {
        console.log("inner tap on " + data.id);
        if (readOnly) {
            return;
        }
        dispatch(setSelectedNode(data));
    }

    function onEdit() {
        setEditing(true);
    }

    function duplicateNode() {
        let newNode = new StructogramNode(data.type, new Map(data.data), data.children)
        dispatch(insertAfter({after: data.id, node: newNode}))
    }

    function deleteNodeFunc() {
        dispatch(deleteNode(data.id))
    }

    let contextMenuContent =
        <ContextMenuContent className="w-64">
            <ContextMenuItem onSelect={duplicateNode} inset>
                Duplizieren
            </ContextMenuItem>
            <ContextMenuItem disabled={nonDeletable} onSelect={deleteNodeFunc} inset>
                Löschen
            </ContextMenuItem>
            <ContextMenuSeparator/>
            <ContextMenuSub>
                <ContextMenuSubTrigger inset>Davor einfügen</ContextMenuSubTrigger>
                <ContextMenuSubContent className="w-48">
                    <ContextMenuItem onSelect={() => {
                        dispatch(insertBefore({node: getInstructionTemplate(), before: data.id}))
                    }}>
                        Anweisung
                    </ContextMenuItem>
                    <ContextMenuSeparator/>
                    <ContextMenuItem onSelect={() => {
                        dispatch(insertBefore({node: getIfTemplate(), before: data.id}))
                    }}>Bedingte Verzweigung</ContextMenuItem>
                    <ContextMenuItem>Fall Auswahl</ContextMenuItem>
                    <ContextMenuSeparator/>
                    <ContextMenuItem onSelect={() => {
                        dispatch(insertBefore({node: getForTemplate(), before: data.id}))
                    }}>Zählschleife</ContextMenuItem>
                    <ContextMenuItem onSelect={() => {
                        dispatch(insertBefore({node: getWhileTemplate(), before: data.id}))
                    }}>Solange Schleife</ContextMenuItem>
                    <ContextMenuItem>Bis Schleife</ContextMenuItem>
                </ContextMenuSubContent>
            </ContextMenuSub>
            <ContextMenuSub>
                <ContextMenuSubTrigger inset>Danach einfügen</ContextMenuSubTrigger>
                <ContextMenuSubContent className="w-48">
                    <ContextMenuItem onSelect={() => {
                        dispatch(insertAfter({after: data.id, node: getInstructionTemplate()}))
                    }}>
                        Anweisung
                    </ContextMenuItem>
                    <ContextMenuSeparator/>
                    <ContextMenuItem>Bedingte Verzweigung</ContextMenuItem>
                    <ContextMenuItem>Fall Auswahl</ContextMenuItem>
                    <ContextMenuSeparator/>
                    <ContextMenuItem>Zählschleife</ContextMenuItem>
                    <ContextMenuItem>Solange Schleife</ContextMenuItem>
                    <ContextMenuItem>Bis Schleife</ContextMenuItem>
                </ContextMenuSubContent>
            </ContextMenuSub>
        </ContextMenuContent>

    contextMenuContent = readOnly ? <div></div> : contextMenuContent;

    return (
        <>
            <ContextMenu>
                {contextMenuContent}
                <div className={borderStyle}>
                    {
                        (data.type == "instruction") ?
                            InstructionComponent({data: data, readOnly: readOnly, selectedNode: selectedNode}) :
                            (data.type == "for" || data.type == "while") ?
                                LoopComponent({data: data, selectedNode: selectedNode, readOnly: readOnly}) :
                                (data.type == "if") ?
                                    IfComponent({data: data, selectedNode: selectedNode, readOnly: readOnly}) :
                                    <div></div>
                    }
                </div>
            </ContextMenu>
        </>
    )
}