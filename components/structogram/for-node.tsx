import {ContextMenuTrigger} from "@/components/ui/context-menu";
import {setNode} from "@/app/editor/structogram-slice";
import {
    blockStyleNormal, blockStyleSelected,
    childrenStyle,
    inputStyle,
    titleStyleNormal, titleStyleSelected
} from "@/components/structogram/style";
import {useState} from "react";
import {useAppDispatch} from "@/app/editor/store";
import {StructogramNode} from "@/types/structogram";
import {StructogramBlock} from "@/components/structogram/structogram-node";
import {setSelectedNode} from "@/app/editor/selected-node-slice";
import saveStructogram from "@/app/editor/[id]/save-structogram";

interface LoopComponentProps {
    data: StructogramNode;
    selectedNode: StructogramNode | null;
    readOnly: boolean;
}

export function LoopComponent({data, readOnly, selectedNode}: LoopComponentProps) {
    const [localData, setLocalData] = useState(data.data);
    let [editing, setEditing] = useState(false);
    const dispatch = useAppDispatch();

    let titleStyle = titleStyleNormal;
    let blockStyle = blockStyleNormal;
    if (selectedNode?.id == data.id ) {
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

    async function onBlur(input: any) {
        try {
            console.log('Structogram saved successfully');
        } catch (error) {
            console.error('Error saving structogram:', error);
        }
        let value = input.value;
        onChange(value);
        setEditing(false)
        const updatedData = {...data, data: new Map(localData)};
        dispatch(setNode(updatedData))
    }

    function onKeyDown(event: any) {
        if (event.key === "Escape" || event.key === "Enter") {
            event.currentTarget.blur();
            onBlur(event.currentTarget);
        }
    }

    function onChange(value: any) {
        const updatedLocalData = new Map(localData);
        updatedLocalData.set("condition", value.target.value);
        setLocalData(updatedLocalData);
    }

    return (
        <>
            <div>
            <ContextMenuTrigger>
                <div onClick={onSelected} onDoubleClick={onEdit} className={titleStyle}>
                    {
                        (editing)?<input onChange={onChange}
                                         onBlur={onBlur}
                                         onKeyDown={onKeyDown}
                                         className={inputStyle} value={localData.get("condition")}>
                            </input>
                            :<div>{localData.get("condition")}</div>
                    }
                </div>
            </ContextMenuTrigger>
                <div className="flex flex-row flex-grow">
                    <div onClick={onSelected} className={blockStyle}>
                    </div>
                    <div className={childrenStyle}>
                        {data.children.map((node, index) => {
                            return <StructogramBlock readOnly={readOnly} selectedNode={selectedNode} nonDeletable={data.children.length <= 1} borders={[true, false, index % 2 == 0, (index % 2== 0 && index != data.children.length - 1)]} key={node.id} data={node}/>
                        })}
                    </div>
                </div>
            </div>
        </>
    );
}