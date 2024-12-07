import {ContextMenuTrigger} from "@/components/ui/context-menu";
import {setNode} from "@/app/editor/structogram-slice";
import {
    blockStyleNormal,
    blockStyleSelected,
    childrenStyle,
    inputStyle,
    titleStyleNormal,
    titleStyleSelected
} from "@/components/structogram/style";
import {useState} from "react";
import {useAppDispatch} from "@/app/editor/store";
import {StructogramNode} from "@/types/structogram";
import {StructogramBlock} from "@/components/structogram/structogram-node";
import {setSelectedNode} from "@/app/editor/selected-node-slice";

interface IfComponentProps {
    data: StructogramNode;
    selectedNode: StructogramNode | null;
    readOnly: boolean;
}

export function IfComponent({data, readOnly, selectedNode}: IfComponentProps) {
    const [localData, setLocalData] = useState(data.data);
    let [editing, setEditing] = useState(false);
    const dispatch = useAppDispatch();

    let titleStyle = titleStyleNormal;
    let blockStyle = blockStyleNormal;
    if (selectedNode?.id == data.id) {
        titleStyle = titleStyleSelected;
        blockStyle = blockStyleSelected;
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

    function onBlur(input: any) {
        setEditing(false)
        let value = input.value;
        console.log("blur value: ", value);
        const updatedData = {...data, data: new Map(localData)};
        dispatch(setNode(updatedData))
    }

    function onKeyDown(event: any,) {
        if (event.key === "Escape" || event.key === "Enter") {
            console.log(event.currentTarget.value)
            onBlur(event.currentTarget);
            event.currentTarget.blur();
        }
    }

    function onChange(value: any) {
        if (value == "") {
            value = " ";
        }
        console.log("setting value: ", value.target.value);
        const updatedLocalData = new Map(localData);
        updatedLocalData.set("condition", value.target.value);
        setLocalData(updatedLocalData);
    }

    let trueChildren = data.children.filter((e) => e.data.get("condition") == "true");
    let falseChildren = data.children.filter((e) => e.data.get("condition") == "false");

    return (
        <>
            <div>
                <ContextMenuTrigger>
                    <div onClick={onSelected} onDoubleClick={onEdit} className={titleStyle}>
                        {
                            (editing) ? <input onChange={onChange}
                                               onBlur={onBlur}
                                               onKeyDown={onKeyDown}
                                               className={inputStyle} value={localData.get("condition")}>
                                </input>
                                : <div>{localData.get("condition")}</div>
                        }
                    </div>
                </ContextMenuTrigger>
                <div className="flex flex-row">
                    <div className={childrenStyle}>
                        {trueChildren.map((node, index) => {
                            return <StructogramBlock readOnly={readOnly} selectedNode={selectedNode}
                                                     nonDeletable={trueChildren.length <= 1}
                                                     borders={[false, false, index % 2 == 0, (index % 2 == 0 && index != trueChildren.length - 1)]}
                                                     key={node.id} data={node}/>
                        })}
                    </div>
                    <div className="w-0.5 flex flex-col">
                        <div className="w-0.5 h-full border-l dark:border-l-white border-l-black"></div>
                    </div>
                    <div className={childrenStyle}>
                        {falseChildren.map((node, index) => {
                            return <StructogramBlock nonDeletable={(falseChildren.length <= 1)}
                                                     selectedNode={selectedNode} readOnly={readOnly}
                                                     borders={[false, false, index % 2 == 0, (index % 2 == 0 && index != falseChildren.length - 1)]}
                                                     key={node.id} data={node}/>
                        })}
                    </div>
                </div>
            </div>
        </>
    );
}