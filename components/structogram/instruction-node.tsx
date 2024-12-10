import {ContextMenuTrigger} from "@/components/ui/context-menu";
import {setNode} from "@/app/editor/structogram-slice";
import {inputStyle, titleSpacerStyle, titleStyleNormal, titleStyleSelected} from "@/components/structogram/style";
import {useState} from "react";
import {useAppDispatch} from "@/app/editor/store";
import {StructogramNode} from "@/types/structogram";
import {setSelectedNode} from "@/app/editor/selected-node-slice";

interface InstructionComponentProps {
    data: StructogramNode;
    selectedNode: StructogramNode | null;
    readOnly: boolean;
}

export function InstructionComponent({data, selectedNode, readOnly}: InstructionComponentProps) {
    const [localData, setLocalData] = useState(data.data);
    let [editing, setEditing] = useState(false);
    const dispatch = useAppDispatch();

    let titleStyle = titleStyleNormal;
    if (selectedNode?.id == data.id) {
        titleStyle = titleStyleSelected;
    } else {
        editing = false
    }

    function onSelected() {
        if (!readOnly) {
            dispatch(setSelectedNode(data));
        }
    }

    function onEdit() {
        setEditing(true);
    }

    function onBlur() {
        setEditing(false)
        const updatedData = {...data, data: new Map(localData)};
        dispatch(setNode(updatedData))
    }

    function onKeyDown(event: any) {
        if (event.key === "Escape" || event.key === "Enter") {
            event.currentTarget.blur();
            onBlur();
        }
    }

    function onChange(value: any) {
        const updatedLocalData = new Map(localData);
        updatedLocalData.set("value", value.target.value);
        setLocalData(updatedLocalData);
    }

function onKeyUp(event: any) {
    event.currentTarget.size = event.currentTarget.value.length;
}

    return (
        <>
            <ContextMenuTrigger>
                <div onClick={onSelected} onDoubleClick={onEdit} className={titleStyle}>
                    <div className={titleSpacerStyle}></div>
                    {
                        (editing) ? <input onChange={onChange}
                                           onBlur={onBlur}
                                           onKeyDown={onKeyDown}
                                           onKeyUp={onKeyUp}
                                           className={inputStyle} value={localData.get("value")}>
                            </input>
                            : <div>{localData.get("value")}</div>
                    }
                    <div className={titleSpacerStyle}></div>
                </div>
            </ContextMenuTrigger>
        </>
    );
}
